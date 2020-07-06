//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <TweetCellDelegate, ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tweetArray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

  // Makes a network request to get updated data
  // Updates the tableView with the new data
  // Hides the RefreshControl
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

- (void)didTweet:(Tweet *)tweet {
    NSLog(@"%@", tweet);
    [self.tweetArray addObject:tweet];
    [self loadTweets];
    NSLog(@"Reached protocol method didTweet");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweetArray[indexPath.row];
    cell.delegate = self;
    [cell refreshData];
    return cell;
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Performs segue to profile view controller
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    NSLog(@"User recorded by tapped tweetCell's tweet, according to TimelineVC!!!: %@", tweetCell.tweet.user.name);
    NSLog(@"User recorded by tapped tweetCell's user, according to TimelineVC!!!: %@", user.name);
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"viewTweetSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweetArray[indexPath.row];
        
        TweetViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.tweet = tweet;
        NSLog(@"Tapping on a tweet!");
    } else if ([[segue identifier] isEqualToString:@"profileSegue"]) {
        User *user = sender;
        
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileViewController = (ProfileViewController*)navigationController.topViewController;
        profileViewController.user = user;
        NSLog(@"User!!!!: %@", user.name);
    }
}


@end
