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
static NSString *const kconsumerKeyID = @"Consumer Key";
static NSString *const kconsumerSecretID = @"Consumer Secret";
static NSString *const kInfoPlistID = @"Info";
static NSString *const homeTimelineURLString = @"1.1/statuses/home_timeline.json?tweet_mode=extended";
static NSString *const userTimelineURLString = @"1.1/statuses/user_timeline.json?tweet_mode=extended";
static NSString *const kScreenNameID = @"screen_name";
static NSString *const postStatusURLString = @"1.1/statuses/update.json";
static NSString *const kStatusID = @"status";
static NSString *const favoriteURLString = @"1.1/favorites/create.json";
static NSString *const kTweetID = @"id";
static NSString *const retweetURLString = @"1.1/statuses/retweet.json";
static NSString *const unfavoriteURLString = @"1.1/favorites/destroy.json";
static NSString *const unretweetURLString = @"1.1/statuses/unretweet.json";

@interface APIManager()

@end

@implementation APIManager

+ (NSArray *)getKeys {
    NSDictionary *const dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kInfoPlistID ofType:@"plist"]];
    NSString *const consumerKey = [dictionary objectForKey:kconsumerKeyID];
    NSString *const consumerSecret = [dictionary objectForKey:kconsumerSecretID];
    
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
    NSString *const key = [APIManager getKeys][0];
    NSString *const secret = [APIManager getKeys][1];
    
    // Check for launch arguments override
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
//        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
//        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
//    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        NSLog(@"Successfully created APIManager with retrieved keys");
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    [self GET:homeTimelineURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
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

- (void)getUserTimelineWithScreenName:(NSString *)screenName completion:(void(^)(NSArray *tweets, NSError *error))completion {
    NSDictionary *const parameters = @{kScreenNameID: screenName};
    
    [self GET:userTimelineURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        NSMutableArray *const tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        
        completion(tweets, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);
   }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSDictionary *const parameters = @{kStatusID: text};
    
    [self POST:postStatusURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *const tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{kTweetID: tweet.idStr};
    
    [self POST:favoriteURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{kTweetID: tweet.idStr};
    
    [self POST:retweetURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{kTweetID: tweet.idStr};
    
    [self POST:unfavoriteURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{kTweetID: tweet.idStr};
    
    [self POST:unretweetURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
