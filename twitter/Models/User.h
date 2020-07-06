//
//  User.h
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSURL *profileBannerURL;
//@property (nonatomic, strong) NSString *description;
@property (nonatomic) int followersCount;
@property (nonatomic) int friendsCount;
@property (nonatomic) int statusesCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
