//
//  ComposeViewController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/7/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (nonatomic, strong) UILabel *characterCountLabel;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyToLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetTextViewTopConstraint;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    self.characterCountLabel.font = [UIFont systemFontOfSize:12];
    self.characterCountLabel.textColor = [UIColor whiteColor];
    self.characterCountLabel.text = [@(140) stringValue];
            
    // init the nav bar items
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    UIBarButtonItem *characterCountButton = [[UIBarButtonItem alloc] initWithCustomView:self.characterCountLabel];
     self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onTweetButton)];
    self.tweetButton.enabled = NO;
    self.navigationItem.rightBarButtonItems = @[self.tweetButton, characterCountButton];
    
    User *user = [User currentUser];

    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.userNameLabel.text = user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
    
    if (self.replyToTweet != nil) {
        NSString *initialTweetText = @"";
        self.replyToLabel.text = [NSString stringWithFormat:@"↓ In reply to @%@", self.replyToTweet.user.screenname];
        if (self.replyToTweet.retweetedTweet != nil) {
            initialTweetText = [initialTweetText stringByAppendingFormat:@"@%@ ", self.replyToTweet.retweetedTweet.user.screenname];
            self.replyToLabel.text = [NSString stringWithFormat:@"↓ In reply to @%@", self.replyToTweet.retweetedTweet.user.screenname];
        }
        initialTweetText = [initialTweetText stringByAppendingFormat:@"@%@ ", self.replyToTweet.user.screenname];
        self.tweetTextView.text = initialTweetText;
    } else {
        self.replyToLabel.hidden = YES;
        self.tweetTextViewTopConstraint.constant = -16;
    }
    
    [self.tweetTextView becomeFirstResponder];
    self.tweetTextView.delegate = self;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger charactersLeft = 140 - textView.text.length;
    self.characterCountLabel.text = [@(charactersLeft) stringValue];
    self.characterCountLabel.textColor = (charactersLeft >= 20) ? [UIColor whiteColor] : [UIColor redColor];
    self.tweetButton.enabled = (charactersLeft >= 0) && (charactersLeft < 140);
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    NSString *text = self.tweetTextView.text;
    [[TwitterClient sharedInstance] postTweet:text replyID:self.replyToTweet.tweetId  completion:^(id help, NSError *error) {
        NSLog(@"tweet posted");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
