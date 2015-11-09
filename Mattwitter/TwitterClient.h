//
//  TwitterClient.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/2/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)postTweet:(NSString *)tweetContent replyID:(NSString *)replyID completion:(void (^)(id help, NSError *error))completion;
- (void)retweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion;
- (void)favourite:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion;

@end
