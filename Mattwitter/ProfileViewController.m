//
//  ProfileViewController.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/12/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _userNameLabel.text = self.user.name;
    _userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
    [_userProfileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [_userBackgroundImageView setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageUrl]];
    _tweetCount.text = [@(self.user.tweetNumber) stringValue];
    _followingCount.text = [@(self.user.followingNumber) stringValue];
    _followerCount.text = [@(self.user.followersNumber) stringValue];

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
