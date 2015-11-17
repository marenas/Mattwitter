//
//  SlideoutHeaderTableViewCell.m
//  Mattwitter
//
//  Created by Matias Arenas Sepulveda on 11/11/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "SlideoutHeaderTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface SlideoutHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;

@end


@implementation SlideoutHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    _userNameLabel.text = user.name;
    _userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
    [_userProfileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
}

@end
