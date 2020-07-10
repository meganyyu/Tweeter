//
//  ProfileViewController.m
//  twitter
//
//  Created by meganyu on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"

#import "APIManager.h"
#import "ProfileCell.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"

#pragma mark - Constants

static NSString *const kHeaderViewID = @"ProfileCell";
static NSString *const kTweetCellID = @"TweetCell";

#pragma mark - Interface

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweetArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

#pragma mark - Implementation

@implementation ProfileViewController

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
    
    self.navigationItem.title = _user.name;
}

#pragma mark - Load data

- (void)loadTweets {
    [[APIManager shared] getUserTimelineWithScreenName:_user.screenName
                                            completion:^(NSArray *tweets, NSError *error) {
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

#pragma mark - User actions

- (IBAction)onTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _tweetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    cell.tweet = _tweetArray[indexPath.row];
    
    [cell refreshData];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    ProfileCell *header = [tableView dequeueReusableCellWithIdentifier:kHeaderViewID];
    header.user = _user;
    
    [header refreshData];
    
    return header;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
