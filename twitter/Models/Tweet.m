//
//  Tweet.m
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "Tweet.h"

#import "NSDate+DateTools.h"
#import "User.h"

#define NUMBER_OF_SECONDS_IN_ONE_HOUR 3600

#pragma mark - Constants

static NSString *const kCreatedAtID = @"created_at";
static NSString *const kFavoriteCountID = @"favorite_count";
static NSString *const kFullTextID = @"full_text";
static NSString *const kIsFavoritedID = @"favorited";
static NSString *const kIsRetweetedID = @"retweeted";
static NSString *const kRetweetCountID = @"retweet_count";
static NSString *const kRetweetedStatusID = @"retweeted_status";
static NSString *const kTweetID = @"id_str";
static NSString *const kUserID = @"user";

#pragma mark - Implementation

@implementation Tweet

#pragma mark - Setup

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // checks if this a re-tweet
        NSDictionary *const originalTweet = dictionary[kRetweetedStatusID];
        if(originalTweet != nil){
            NSDictionary *const userDictionary = dictionary[kUserID];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[kTweetID];
        self.text = dictionary[kFullTextID];
        NSLog(@"Text: %@", self.text);
        
        self.favoriteCount = [dictionary[kFavoriteCountID] intValue];
        self.favorited = [dictionary[kIsFavoritedID] boolValue];
        self.retweetCount = [dictionary[kRetweetCountID] intValue];
        self.retweeted = [dictionary[kIsRetweetedID] boolValue];
        
        // initialize user
        NSDictionary *const user = dictionary[kUserID];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Format createdAt date string
        NSString *const createdAtOriginalString = dictionary[kCreatedAtID];
        NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *const date = [formatter dateFromString:createdAtOriginalString];
        self.createdAtDate = date;
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.createdAtString = [formatter stringFromDate:date];
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *const tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

#pragma mark - Time helper methods

- (int)hoursSinceTweet {
    NSDate *const currentTime = [NSDate date];
    double secondsSinceTweet = [currentTime timeIntervalSinceDate:self.createdAtDate];
    return (int) secondsSinceTweet / NUMBER_OF_SECONDS_IN_ONE_HOUR;
}

- (NSString *)timeAgoCreated {
    return self.createdAtDate.shortTimeAgoSinceNow;
}

@end
