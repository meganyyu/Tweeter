//
//  TweetCell.m
//  twitter
//
//  Created by meganyu on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

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

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
        // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    if (!self.tweet.favorited) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        //NSLog(@"Trying to like, value of tweet.favorited = %@", (self.tweet.favorited ? @"YES" : @"NO"));
        
        [self refreshData];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        //NSLog(@"Trying to unlike, value of tweet.favorited = %@", (self.tweet.favorited ? @"YES" : @"NO"));
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
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
        //NSLog(@"Trying to retweet, value of tweet.retweeted = %@", (self.tweet.retweeted ? @"YES" : @"NO"));
        
        [self refreshData];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        //NSLog(@"Trying to unretweet, value of tweet.retweeted = %@", (self.tweet.retweeted ? @"YES" : @"NO"));
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
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

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // Call method on delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];
    NSLog(@"User recorded by tapped tweetCell's tweet, according to TweetCell!!!: %@", self.tweet.user.name);
}


- (void)refreshData {
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    [self.profileImageView setImageWithURL:self.tweet.user.profileImageURL];
    
    if (self.tweet.hoursSinceTweet < 24) {
        [self.timestampLabel setText:self.tweet.timeAgoCreated];
    } else {
        self.timestampLabel.text = self.tweet.createdAtString;
    }
    
    self.tweetTextLabel.text = self.tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    if (self.tweet.favorited) {
        UIImage *const favorIconRed = [UIImage imageNamed:@"favor-icon-red"];
        [self.favoriteButton setImage:favorIconRed forState:UIControlStateNormal];
    } else {
        UIImage *const favorIcon = [UIImage imageNamed:@"favor-icon"];
        [self.favoriteButton setImage:favorIcon forState:UIControlStateNormal];
    }
    if (self.tweet.retweeted) {
        UIImage *const retweetIconGreen = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retweetButton setImage:retweetIconGreen forState:UIControlStateNormal];
    } else {
        UIImage *const retweetIcon = [UIImage imageNamed:@"retweet-icon"];
        [self.retweetButton setImage:retweetIcon forState:UIControlStateNormal];
    }
}

@end
