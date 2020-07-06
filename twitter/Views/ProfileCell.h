//
//  ProfileCell.h
//  twitter
//
//  Created by meganyu on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UITableViewCell

@property (strong, nonatomic) User *user;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
