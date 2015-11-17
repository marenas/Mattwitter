//
//  User.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/3/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;


@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic) NSInteger tweetNumber;
@property (nonatomic) NSInteger followingNumber;
@property (nonatomic) NSInteger followersNumber;


- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;

@end
