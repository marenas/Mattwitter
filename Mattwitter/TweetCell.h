//
//  TweetCell.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/4/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) UIViewController *parentViewController;

@end
