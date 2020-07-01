//
//  Tweet.m
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "NSDate+DateTools.h"

#define NUMBER_OF_SECONDS_IN_ONE_HOUR 3600

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {

        // Is this a re-tweet?
        NSDictionary *const originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *const userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"full_text"];
        NSLog(@"Text: %@", self.text);
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        // initialize user
        NSDictionary *const user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];

        // Format createdAt date string
        NSString *const createdAtOriginalString = dictionary[@"created_at"];
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
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

- (int)hoursSinceTweet {
    NSDate *const currentTime = [NSDate date];
    double secondsSinceTweet = [currentTime timeIntervalSinceDate:self.createdAtDate];
    return (int) secondsSinceTweet / NUMBER_OF_SECONDS_IN_ONE_HOUR;
}

- (NSString *)timeAgoCreated {
    return self.createdAtDate.shortTimeAgoSinceNow;
}

@end
