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
        
        NSString *const profileURLString = dictionary[@"profile_image_url_https"];
        self.profileImageURL = [NSURL URLWithString:profileURLString];
    }
    return self;
}

@end
