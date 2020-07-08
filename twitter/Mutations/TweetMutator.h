//
//  TweetMutator.h
//  twitter
//
//  Created by meganyu on 7/7/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetMutator : NSObject

+ (void)setTweet:(Tweet *)tweet
       favorited:(BOOL)favorited
         failure:(void(^)(Tweet *tweet, NSError *error))failure;

+ (void)setTweet:(Tweet *)tweet
       retweeted:(BOOL)retweeted
         failure:(void(^)(Tweet *tweet, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
