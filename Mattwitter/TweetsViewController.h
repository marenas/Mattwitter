//
//  TweetsViewController.h
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/4/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

typedef NS_ENUM(NSInteger, TimelineType) {
    	    HomeTimeline,
    	    MentionsTimeline
};

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (nonatomic) TimelineType timelineType;

@end
