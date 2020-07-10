//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"

#import "APIManager.h"
#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetViewController.h"

#pragma mark - Constants

static NSString *const kComposeSegueID = @"composeSegue";
static NSString *const kLoginViewControllerID = @"LoginViewController";
static NSString *const kMainStoryboardID = @"Main";
static NSString *const kProfileSegueID = @"profileSegue";
static NSString *const kTweetCellID = @"TweetCell";
static NSString *const kViewTweetSegueID = @"viewTweetSegue";

#pragma mark - Interface

@interface TimelineViewController () <TweetCellDelegate, ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tweetArray;

@end

#pragma mark - Implementation

@implementation TimelineViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self loadTweets];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadTweets)
              forControlEvents:UIControlEventValueChanged];
    [_tableView insertSubview:_refreshControl atIndex:0];
}

#pragma mark - Load data

/** Makes a network request to get updated data. Updates the tableView with the new data. Hides the RefreshControl. */
- (void)loadTweets {
    // Get timeline (completion block is passed in an array of already processed Tweet objects)
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetArray = (NSMutableArray *) tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            [self.tableView reloadData];
        } else {
            NSString *const errorMessage = [error localizedDescription];
            NSLog(@"😫😫😫 Error getting home timeline: %@", errorMessage);
        }
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - User actions

- (void)didTweet:(Tweet *)tweet {
    NSLog(@"%@", tweet);
    [_tweetArray addObject:tweet];
    
    [self loadTweets];
    
    NSLog(@"Reached protocol method didTweet");
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *const appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:kMainStoryboardID
                                                               bundle:nil];
    LoginViewController *const loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginViewControllerID];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

#pragma mark - TweetCellDelegate methods

/** Performs segue to profile view controller */
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    NSLog(@"User recorded by tapped tweetCell's user, according to TimelineVC!!!: %@", user.name);
    
    [self performSegueWithIdentifier:kProfileSegueID
                              sender:user];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *const cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    cell.tweet = _tweetArray[indexPath.row];
    cell.delegate = self;
    
    [cell refreshData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([[segue identifier] isEqualToString:kComposeSegueID]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([[segue identifier] isEqualToString:kViewTweetSegueID]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [_tableView indexPathForCell:tappedCell];
        Tweet *tweet = _tweetArray[indexPath.row];
        
        TweetViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.tweet = tweet;
        
        NSLog(@"Tapping on a tweet!");
    } else if ([[segue identifier] isEqualToString:kProfileSegueID]) {
        User *user = sender;
        
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileViewController = (ProfileViewController*)navigationController.topViewController;
        profileViewController.user = user;
        NSLog(@"User!!!!: %@", user.name);
    }
}


@end
