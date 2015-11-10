//
//  TweetDetailViewController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/7/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetedByUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProfileImageTopLayoutConstraint;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.title = @"Tweet";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self setViewContent];
    
}

- (IBAction)onReplyButton:(id)sender {
    [self onReply:sender];
}

- (IBAction)onRetweet:(id)sender {
    [[TwitterClient sharedInstance] retweet:_tweet.tweetId completion:^(id help, NSError *error) {
        UIImage *btnImage = [UIImage imageNamed:@"retweet-image-on"];
        [self.retweetButton setImage:btnImage forState:UIControlStateNormal];
    }];
}
- (IBAction)onFavorite:(id)sender {
    [[TwitterClient sharedInstance] favourite:_tweet.tweetId completion:^(id help, NSError *error) {
        UIImage *btnImage = [UIImage imageNamed:@"favorite-image-on.png"];
        [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];
    }];
}

- (void)onReply:(id)sender
{
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.replyToTweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}


- (void)setViewContent {
    Tweet *tweetToDisplay;
    if (self.tweet.retweetedTweet == nil) {
        // configure the cell to hide the retweeted status
        tweetToDisplay = self.tweet;
        self.retweetedIcon.hidden = YES;
        self.retweetedByUserNameLabel.hidden = YES;
        self.userProfileImageTopLayoutConstraint.constant = -8;
    } else {
        // configure the cell to show the retweeted status
        tweetToDisplay = self.tweet.retweetedTweet;
        self.retweetedIcon.hidden = NO;
        self.retweetedByUserNameLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        self.retweetedByUserNameLabel.hidden = NO;
    }
    
    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:tweetToDisplay.user.profileImageUrl]];
    self.userNameLabel.text = tweetToDisplay.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", tweetToDisplay.user.screenname];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:tweetToDisplay.createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    self.createdAtLabel.text = dateString;
    self.retweetsCountLabel.text = [NSString stringWithFormat:@"%ld", tweetToDisplay.retweetCount];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", tweetToDisplay.favoriteCount];
    
    self.tweetTextLabel.text = tweetToDisplay.text;
    if ([tweetToDisplay.retweeted boolValue] == YES ) {
        UIImage *btnImage = [UIImage imageNamed:@"retweet-image-on.png"];
        [self.retweetButton setImage:btnImage forState:UIControlStateNormal];
    } else {
        UIImage *btnImage = [UIImage imageNamed:@"retweet-image.png"];
        [self.retweetButton setImage:btnImage forState:UIControlStateNormal];
    }
    
    if ([tweetToDisplay.favorited boolValue] == YES ) {
        UIImage *btnImage = [UIImage imageNamed:@"favorite-image-on"];
        [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];
    } else {
        UIImage *btnImage = [UIImage imageNamed:@"favorite-image"];
        [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
