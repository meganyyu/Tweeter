//
//  ComposeViewController.m
//  twitter
//
//  Created by meganyu on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: set authenticated user's profile image, name, and screen name
    
    self.composeTextView.delegate = self;
    [self.characterCountLabel setText:@"280"];
}

- (IBAction)didTapPost:(id)sender {
    [[APIManager shared] postStatusWithText:self.composeTextView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int const characterLimit = 280;
    NSString *const newText = [self.composeTextView.text stringByReplacingCharactersInRange:range withString:text];

    [self.characterCountLabel setText:[NSString stringWithFormat:@"%lu", characterLimit - newText.length]];
    
    return newText.length < characterLimit;
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
