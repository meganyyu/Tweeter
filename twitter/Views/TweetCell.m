//
//  TweetCell.m
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

#import "APIManager.h"
#import "TweetMutator.h"
#import "UIImageView+AFNetworking.h"

#pragma mark - Constants

static NSString *const kProfileSegueID = @"profileSegue";
static NSString *const kTappedFavorIconID = @"favor-icon-red";
static NSString *const kTappedRetweetIconID = @"retweet-icon-green";
static NSString *const kUntappedFavorIconID = @"favor-icon";
static NSString *const kUntappedRetweetIconID = @"retweet-icon";

#pragma mark - Interface

@interface TweetCell ()

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

@implementation TweetCell

#pragma mark - Setup

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *const profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                                       action:@selector(didTapUserProfile:)];
    [_profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [_profileImageView setUserInteractionEnabled:YES];
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

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [_delegate tweetCell:self didTap:_tweet.user];
    NSLog(@"User recorded by tapped tweetCell's tweet, according to TweetCell!!!: %@", _tweet.user.name);
}

#pragma mark - Refresh Data

- (void)refreshData {
    _userNameLabel.text = _tweet.user.name;
    _screenNameLabel.text = [NSString stringWithFormat:@"@%@", _tweet.user.screenName];
    _tweetTextLabel.text = _tweet.text;
    _retweetCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.retweetCount];
    _favoriteCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.favoriteCount];
    _timestampLabel.text = (_tweet.hoursSinceTweet < 24 ? _tweet.timeAgoCreated : _tweet.createdAtString);
    
    [_profileImageView setImageWithURL:_tweet.user.profileImageURL];
    
    UIImage *const favorIcon = [UIImage imageNamed:(_tweet.favorited ? kTappedFavorIconID : kUntappedFavorIconID)];
    [_favoriteButton setImage:favorIcon forState:UIControlStateNormal];
    
    UIImage *const retweetIcon = [UIImage imageNamed:(_tweet.retweeted ? kTappedRetweetIconID : kUntappedRetweetIconID)];
    [_retweetButton setImage:retweetIcon forState:UIControlStateNormal];
}

@end
