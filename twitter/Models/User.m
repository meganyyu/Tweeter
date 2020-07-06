//
//  User.m
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *const)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        NSLog(@"%@", [NSString stringWithFormat:@"%@", dictionary[@"description"]]);
        //self.description = dictionary[@"description"];
        NSString *const profileURLString = dictionary[@"profile_image_url_https"];
        self.profileImageURL = [NSURL URLWithString:profileURLString];
        
        NSString *const profileBannerURLString = dictionary[@"profile_banner_url"];
        self.profileBannerURL = [NSURL URLWithString:profileBannerURLString];
        
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.friendsCount = [dictionary[@"friends_count"] intValue];
        self.statusesCount = [dictionary[@"statuses_count"] intValue];
    }
    return self;
}

@end
