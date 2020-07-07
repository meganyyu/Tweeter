//
//  ProfileViewController.m
//  twitter
//
//  Created by meganyu on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "TweetViewController.h"
#import "ProfileCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *tweetArray;

@end

@implementation ProfileViewController

NSString *const kTweetCellID = @"TweetCell";
NSString *const kHeaderViewID = @"ProfileCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Contains the user header view: picture and tagline
    // Contains a section with the users basic stats: # tweets, # following, # followers
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.navigationItem.title = self.user.name;
}

- (void)loadTweets {
    [[APIManager shared] getUserTimelineWithScreenName:self.user.screenName completion:^(NSArray *tweets, NSError *error) {
        
        if (tweets) {
            self.tweetArray = (NSMutableArray *) tweets;
            NSLog(@"😎😎😎 Successfully loaded user's timeline");
            
            [self.tableView reloadData];
        } else {
            NSString *const errorMessage = [error localizedDescription];
            
            NSLog(@"😫😫😫 Error getting user's timeline: %@", errorMessage);
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    cell.tweet = self.tweetArray[indexPath.row];
    
    [cell refreshData];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ProfileCell *header = [tableView dequeueReusableCellWithIdentifier:kHeaderViewID];
    header.user = self.user;
    
    [header refreshData];
    
    return header;
}

- (IBAction)onTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
