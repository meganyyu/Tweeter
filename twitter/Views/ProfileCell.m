//
//  ProfileCell.m
//  twitter
//
//  Created by meganyu on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBannerView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusesCountLabel;


@end

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshData {
    [self.profileImageView setImageWithURL:self.user.profileImageURL];
    [self.profileBannerView setImageWithURL:self.user.profileBannerURL];
    
    [self.userNameLabel setText:self.user.name];
    [self.screenNameLabel setText:self.user.screenName];
    [self.profileDescriptionLabel setText:self.user.userDescription];
    
    [self.followersCountLabel setText:[NSString stringWithFormat:@"%d", self.user.followersCount]];
    [self.friendsCountLabel setText:[NSString stringWithFormat:@"%d", self.user.friendsCount]];
    [self.statusesCountLabel setText:[NSString stringWithFormat:@"%d", self.user.statusesCount]];
}

@end
