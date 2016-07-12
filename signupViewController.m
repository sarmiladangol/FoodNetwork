//
//  signupViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/11/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "signupViewController.h"
@import Firebase;
@import FirebaseAuth;

@interface signupViewController ()

@end

@implementation signupViewController
NSString *email;
NSString *password;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signupBtnPressed:(id)sender {
    NSLog(@"SIGNUP PRESSED");
    [[FIRAuth auth]
     createUserWithEmail:email
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
    [self createUserProfileOnFirebase];
     }];
}

-(void)createUserProfileOnFirebase{
    NSLog(@"CREAT USER IN FIREBASE");
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
