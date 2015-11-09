//
//  Tweet.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/3/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        _text = dictionary[@"text"];

        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        _createdAt = [formatter dateFromString:createdAtString];
        _tweetId = dictionary[@"id"];
        
        if (dictionary[@"retweeted_status"] != nil) {
            _retweetedTweet = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        } else {
            _retweetedTweet = nil;
        }
        _retweetCount = [dictionary[@"retweet_count"] integerValue];
        _favoriteCount = [dictionary[@"favorite_count"] integerValue];
        if ([(NSNumber *)dictionary[@"favorited"] boolValue] == 0) {
            _favorited = NO;
        } else {
            _favorited = YES;
        }
        
        if ([(NSNumber *)dictionary[@"retweeted"] boolValue] == 0) {
            _retweeted = NO;
        } else {
            _retweeted = YES;
        }

    }
    return self;
}

- (NSString *)hoursSinceTweet
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [[NSDate alloc] init];

    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:currentDate  toDate:_createdAt  options:0];
    
    return [NSString stringWithFormat:@"%ldm", - [breakdownInfo minute]];
}


+ (NSArray *)tweetsWithArray:(NSArray *) array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
