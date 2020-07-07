//
//  TweetViewController.m
//  twitter
//
//  Created by meganyu on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ProfileViewController.h"

static NSString *const kProfileSegueID = @"profileSegue";
static NSString *const kTappedFavorIconID = @"favor-icon-red";
static NSString *const kUntappedFavorIconID = @"favor-icon";
static NSString *const kTappedRetweetIconID = @"retweet-icon-green";
static NSString *const kUntappedRetweetIconID = @"retweet-icon";

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *directMessageButton;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
}

- (IBAction)didTapFavorite:(id)sender {
    if (!self.tweet.favorited) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        //NSLog(@"Trying to like, value of tweet.favorited is now = %@", (self.tweet.favorited ? @"YES" : @"NO"));
        
        [self refreshData];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        //NSLog(@"Trying to unlike, value of tweet.favorited is now = %@", (self.tweet.favorited ? @"YES" : @"NO"));
        
        [self refreshData];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if (!self.tweet.retweeted) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        //NSLog(@"Trying to retweet, value of tweet.retweeted is now = %@", (self.tweet.retweeted ? @"YES" : @"NO"));
        
        [self refreshData];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        //NSLog(@"Trying to unretweet, value of tweet.retweeted is now = %@", (self.tweet.retweeted ? @"YES" : @"NO"));
        
        [self refreshData];
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    
}

- (IBAction)onTapProfileImage:(UITapGestureRecognizer *)sender {
    //NSLog(@"User recorded by tapped tweet, according to TweetVC!!!: %@", self.tweet.user.name);
    [self performSegueWithIdentifier:kProfileSegueID sender:self.tweet.user];
}

- (void)refreshData {
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    
    [self.profileImageView setImageWithURL:self.tweet.user.profileImageURL];
    [self.timestampLabel setText:self.tweet.createdAtString];
    
    self.tweetTextLabel.text = self.tweet.text;
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    if (self.tweet.favorited) {
        UIImage *const tappedFavorIcon = [UIImage imageNamed:kTappedFavorIconID];
        [self.favoriteButton setImage:tappedFavorIcon forState:UIControlStateNormal];
    } else {
        UIImage *const untappedFavorIcon = [UIImage imageNamed:kUntappedFavorIconID];
        [self.favoriteButton setImage:untappedFavorIcon forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted) {
        UIImage *const tappedRetweetIcon = [UIImage imageNamed:kTappedRetweetIconID];
        [self.retweetButton setImage:tappedRetweetIcon forState:UIControlStateNormal];
    } else {
        UIImage *const untappedRetweetIcon = [UIImage imageNamed:kUntappedRetweetIconID];
        [self.retweetButton setImage:untappedRetweetIcon forState:UIControlStateNormal];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kProfileSegueID]) {
        User *const user = sender;
        
        UINavigationController *const navigationController = [segue destinationViewController];
        ProfileViewController *const profileViewController = (ProfileViewController*)navigationController.topViewController;
        profileViewController.user = user;
        
        NSLog(@"User!!!!: %@", user.name);
    }
}

@end
