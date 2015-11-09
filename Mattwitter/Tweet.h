//
//  Tweet.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/3/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet *retweetedTweet;
@property (nonatomic) NSInteger retweetCount;
@property (nonatomic) NSInteger favoriteCount;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic) BOOL favorited;
@property (nonatomic) BOOL retweeted;


- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)hoursSinceTweet;

+ (NSArray *)tweetsWithArray:(NSArray *) array;
@end
