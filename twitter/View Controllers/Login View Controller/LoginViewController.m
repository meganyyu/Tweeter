//
//  LoginViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "LoginViewController.h"

#import "APIManager.h"

#pragma mark - Constants

static NSString *const kLoginSegueID = @"loginSegue";

#pragma mark - Interface

@interface LoginViewController ()

@end

#pragma mark - Implementation

@implementation LoginViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - User interaction

- (IBAction)didTapLogin:(id)sender {
    [[APIManager shared] loginWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [self performSegueWithIdentifier:kLoginSegueID sender:nil];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
