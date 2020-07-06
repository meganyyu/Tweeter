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

@protocol TweetCellDelegate;
// Note: The type of the property "delegate" is TweetCellDelegate and the protocol method tweetCell: uses the class TweetCell as one of the arguments’ type. So we first declare the protocol as @protocol TweetCellDelegate and then define it after defining the class

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (void)refreshData;

@end

@protocol TweetCellDelegate

- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end

NS_ASSUME_NONNULL_END
