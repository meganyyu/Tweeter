//
//  TweetMutator.m
//  twitter
//
//  Created by meganyu on 7/7/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetMutator.h"
#import "APIManager.h"

@implementation TweetMutator

+ (void)setTweet:(Tweet *)tweet
       favorited:(BOOL)favorited
         failure:(nonnull void (^)(Tweet * _Nonnull, NSError * _Nonnull))failure{
    tweet.favorited = favorited;
    tweet.favoriteCount = tweet.favoriteCount + (favorited ? 1 : -1);
    
    if (favorited) {
        [[APIManager shared] favorite:tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                tweet.favorited = !favorited;
                tweet.favoriteCount = tweet.favoriteCount + (!favorited ? 1 : -1);
                failure(tweet, error);
            } else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        [[APIManager shared] unfavorite:tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
                tweet.favorited = !favorited;
                tweet.favoriteCount = tweet.favoriteCount + (!favorited ? 1 : -1);
                failure(tweet, error);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

+ (void)setTweet:(Tweet *)tweet
       retweeted:(BOOL)retweeted
         failure:(nonnull void (^)(Tweet * _Nonnull, NSError * _Nonnull))failure {
    tweet.retweeted = retweeted;
    tweet.retweetCount = tweet.retweetCount + (retweeted ? 1 : -1);
    
    if (retweeted) {
        [[APIManager shared] retweet:tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                tweet.retweeted = !retweeted;
                tweet.retweetCount = tweet.retweetCount + (!retweeted ? 1 : -1);
                failure(tweet, error);
            } else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        [[APIManager shared] unretweet:tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                tweet.retweeted = !retweeted;
                tweet.retweetCount = tweet.retweetCount + (!retweeted ? 1 : -1);
                failure(tweet, error);
            } else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

@end
