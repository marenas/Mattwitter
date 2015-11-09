//
//  TweetCell.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/4/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import "ComposeViewController.h"


@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *retweetedIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByUserNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProgileImageTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self reloadData];
}

- (void)reloadData {
//    self.userProfileImageView.image = nil;
    
    Tweet *tweetToDisplay;
    if (self.tweet.retweetedTweet == nil) {
        // configure the cell to hide the retweeted status
        tweetToDisplay = self.tweet;
        self.retweetedIcon.hidden = YES;
        self.retweetedByUserNameLabel.hidden = YES;
        self.userProgileImageTopLayoutConstraint.constant = -12;
    } else {
        // configure the cell to show the retweeted status
        tweetToDisplay = self.tweet.retweetedTweet;
        self.retweetedIcon.hidden = NO;
        self.retweetedByUserNameLabel.text = [NSString stringWithFormat:@"%@ Retweeted", self.tweet.user.name];
        self.retweetedByUserNameLabel.hidden = NO;
        self.userProgileImageTopLayoutConstraint.constant = 8;
    }
    
    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:tweetToDisplay.user.profileImageUrl]];
    NSLog(@"image url : %@",tweetToDisplay.user.profileImageUrl);
    self.userNameLabel.text = tweetToDisplay.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", tweetToDisplay.user.screenname];
    self.createdAtLabel.text = [tweetToDisplay hoursSinceTweet];

    self.tweetTextLabel.text = tweetToDisplay.text;
    if (tweetToDisplay.retweeted == YES) {
        UIImage *btnImage = [UIImage imageNamed:@"retweet-image-on.png"];
        [self.retweetButton setImage:btnImage forState:UIControlStateNormal];
    }
    
    if (tweetToDisplay.favorited == YES) {
        UIImage *btnImage = [UIImage imageNamed:@"favorite-image-on"];
        [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];
    }

}

- (IBAction)onReplyButton:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.replyToTweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.parentViewController presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)onRetweetButton:(id)sender {
    
    [[TwitterClient sharedInstance] retweet:_tweet.tweetId completion:^(id help, NSError *error) {
        NSLog(@"Test retweet");
        UIImage *btnImage = [UIImage imageNamed:@"retweet-image-on"];
        [self.retweetButton setImage:btnImage forState:UIControlStateNormal];
    }];
    
}
- (IBAction)onFavoriteButton:(id)sender {

    [[TwitterClient sharedInstance] favourite:_tweet.tweetId completion:^(id help, NSError *error) {
        NSLog(@"Favorited");
        UIImage *btnImage = [UIImage imageNamed:@"favorite-image-on.png"];
        [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];        
    }];
    
}


@end
