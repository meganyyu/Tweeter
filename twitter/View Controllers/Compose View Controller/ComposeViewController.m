//
//  ComposeViewController.m
//  twitter
//
//  Created by meganyu on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"

#import "APIManager.h"

#pragma mark - Interface

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

#pragma mark - Implementation

@implementation ComposeViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // FIXME: set authenticated user's profile image, name, and screen name
    
    _composeTextView.delegate = self;
    [_characterCountLabel setText:@"280"];
}

#pragma mark - User actions

- (IBAction)didTapPost:(id)sender {
    [[APIManager shared] postStatusWithText:_composeTextView.text
                                 completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true
                                     completion:nil];
        }
    }];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

#pragma mark - Text controls

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    int const characterLimit = 280;
    NSString *const newText = [_composeTextView.text stringByReplacingCharactersInRange:range
                                                                             withString:text];

    [_characterCountLabel setText:[NSString stringWithFormat:@"%lu", characterLimit - newText.length]];
    
    return newText.length < characterLimit;
}

@end
