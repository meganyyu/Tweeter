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

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
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
    
    // FIXME: customize navigation bar
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self refreshData];
    
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

- (void)refreshData {
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    [self.profilePictureView setImageWithURL:self.tweet.user.profileImageURL];
    [self.timestampLabel setText:self.tweet.createdAtString];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
