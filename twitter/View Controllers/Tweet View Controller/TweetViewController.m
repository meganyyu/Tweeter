//
//  TweetViewController.m
//  twitter
//
//  Created by meganyu on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetViewController.h"

#import "APIManager.h"
#import "ProfileViewController.h"
#import "TweetMutator.h"
#import "UIImageView+AFNetworking.h"

static NSString *const kProfileSegueID = @"profileSegue";
static NSString *const kTappedFavorIconID = @"favor-icon-red";
static NSString *const kUntappedFavorIconID = @"favor-icon";
static NSString *const kTappedRetweetIconID = @"retweet-icon-green";
static NSString *const kUntappedRetweetIconID = @"retweet-icon";

#pragma mark - Interface

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

#pragma mark - Implementation

@implementation TweetViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
}

#pragma mark - User Actions

- (IBAction)didTapFavorite:(id)sender {
    __weak typeof (self) weakSelf = self;
    [TweetMutator setTweet:_tweet
                 favorited:!_tweet.favorited
                   failure:^(Tweet * _Nonnull tweet, NSError * _Nonnull error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        [strongSelf refreshData];
    }];
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    __weak typeof (self) weakSelf = self;
    [TweetMutator setTweet:_tweet
                 retweeted:!_tweet.retweeted
                   failure:^(Tweet * _Nonnull tweet, NSError * _Nonnull error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        [strongSelf refreshData];
    }];
    [self refreshData];
}

- (IBAction)onTapProfileImage:(UITapGestureRecognizer *)sender {
    //NSLog(@"User recorded by tapped tweet, according to TweetVC!!!: %@", _tweet.user.name);
    [self performSegueWithIdentifier:kProfileSegueID sender:_tweet.user];
}

#pragma mark - Refresh Data

- (void)refreshData {
    _userNameLabel.text = _tweet.user.name;
    _screenNameLabel.text = [NSString stringWithFormat:@"@%@", _tweet.user.screenName];
    _timestampLabel.text = _tweet.createdAtString;
    _tweetTextLabel.text = _tweet.text;
    _retweetCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.retweetCount];
    _favoriteCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.favoriteCount];
    
    [_profileImageView setImageWithURL:_tweet.user.profileImageURL];
    
    UIImage *const favorIcon = [UIImage imageNamed:(_tweet.favorited ? kTappedFavorIconID : kUntappedFavorIconID)];
    [_favoriteButton setImage:favorIcon forState:UIControlStateNormal];
    
    UIImage *const retweetIcon = [UIImage imageNamed:(_tweet.retweeted ? kTappedRetweetIconID : kUntappedRetweetIconID)];
    [_retweetButton setImage:retweetIcon forState:UIControlStateNormal];
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
