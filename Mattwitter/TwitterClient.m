//
//  TwitterClient.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/2/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"aHO1X0dxVxwinRGVOxGDCpMGb";
NSString * const kTwitterConsumerSecret = @"TmmdJYKlOf5XK0iPU8jikYaaFsxhDmI0HvMYhAXH1FC1Ag5FAp";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginComletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginComletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"mattwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
            NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
            [[UIApplication sharedApplication] openURL:authURL];
        } failure:^(NSError *error) {
            NSLog(@"Failed to get the request token");
        }];
    
}

-(void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:
     ^(BDBOAuth1Credential *accessToken) {
         [self.requestSerializer saveAccessToken:accessToken];
         [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             User *user = [[User alloc] initWithDictionary:responseObject];
             [User setCurrentUser:user];
             self.loginComletion(user, nil);
         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"failed to get current user");
            self.loginComletion(nil, error);
         }];
         
     }failure:^(NSError *error) {
        NSLog(@"failed to get access token");
        self.loginComletion(nil, error);
     }];    
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)postTweet:(NSString *)tweetContent replyID:(NSString *)replyID completion:(void (^)(id help, NSError *error))completion
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:tweetContent forKey:@"status"];
    
    if (replyID) {
        [dict setObject:replyID forKey:@"in_reply_to_status_id"];
    }
    
    [self POST:@"1.1/statuses/update.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)retweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID ];
    
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)favourite:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:tweetID forKey:@"id"];
    
    
    NSString *url = @"1.1/favorites/create.json";
    
    [self POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

@end
