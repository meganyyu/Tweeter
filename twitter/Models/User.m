//
//  User.m
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

static NSString *const kNameID = @"name";
static NSString *const kScreenNameID = @"screen_name";
static NSString *const kDescriptionID = @"description";
static NSString *const kProfileImageURLID = @"profile_image_url_https";
static NSString *const kProfileBannerURLID = @"profile_banner_url";
static NSString *const kFollowersCountID = @"followers_count";
static NSString *const kFriendsCountID = @"friends_count";
static NSString *const kStatuseCountID = @"statuses_count";

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *const)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[kNameID];
        self.screenName = dictionary[kScreenNameID];
        self.userDescription = dictionary[kDescriptionID];
        NSString *const profileURLString = dictionary[kProfileImageURLID];
        self.profileImageURL = [NSURL URLWithString:profileURLString];
        
        NSString *const profileBannerURLString = dictionary[kProfileBannerURLID];
        self.profileBannerURL = [NSURL URLWithString:profileBannerURLString];
        
        self.followersCount = [dictionary[kFollowersCountID] intValue];
        self.friendsCount = [dictionary[kFriendsCountID] intValue];
        self.statusesCount = [dictionary[kStatuseCountID] intValue];
    }
    return self;
}

@end
