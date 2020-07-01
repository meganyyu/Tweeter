//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString *const baseURLString = @"https://api.twitter.com";
// NOTE: only use constants below if you're unable to setup a LocalConfig.xcconfig file with your own keys
static NSString *const consumerKey = @""; // Enter your consumer key here
static NSString *const consumerSecret = @""; // Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager

+ (NSArray *)getKeys {
    NSDictionary *const dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    NSString *const consumerKey = [dictionary objectForKey:@"Consumer Key"];
    NSString *const consumerSecret = [dictionary objectForKey:@"Consumer Secret"];
//    NSLog(@"consumerKey: %@, consumerSecret: %@", consumerKey, consumerSecret);
    NSArray *const keys = [NSArray arrayWithObjects:consumerKey, consumerSecret, nil];
    return keys;
}

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *const baseURL = [NSURL URLWithString:baseURLString];
//    NSString *key = consumerKey;
//    NSString *secret = consumerSecret;
    NSString *key = [APIManager getKeys][0];
    NSString *secret = [APIManager getKeys][1];
    
    // Check for launch arguments override
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
//        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
//        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
//    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    NSString *const urlString = @"1.1/statuses/home_timeline.json";
    
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        NSMutableArray *const tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
       
//       // Manually cache the tweets. If the request fails, restore from cache if possible.
//       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
//       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
//
//       completion(tweetDictionaries, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);

//       NSArray *tweetDictionaries = nil;
//
//       // Fetch tweets from cache if possible
//       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
//       if (data != nil) {
//           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//       }
//
//       completion(tweetDictionaries, error);
   }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSString *const urlString = @"1.1/statuses/update.json";
    NSDictionary *const parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *const tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/statuses/retweet.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    if (!tweet.favorited) {
        NSLog(@"Error: this hasn't been favorited, should not be able to favorite");
    } else {
        NSString *urlString = @"1.1/favorites/destroy.json";
        NSDictionary *parameters = @{@"id": tweet.idStr};
        [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
            Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
            completion(tweet, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
    }
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    if (!tweet.retweeted) {
        NSLog(@"Error: this hasn't been retweeted, should not be able to unretweet");
    } else {
        NSString *urlString = @"1.1/statuses/unretweet.json";
        NSDictionary *parameters = @{@"id": tweet.idStr};
        [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
            Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
            completion(tweet, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
    }
}

@end
