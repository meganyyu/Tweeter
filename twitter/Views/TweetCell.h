//
//  TweetCell.h
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
