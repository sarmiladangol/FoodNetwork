//
//  loginViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/11/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "loginViewController.h"
@import Firebase;

@interface loginViewController ()
@end

@implementation loginViewController

NSString *newLoginPassword;

- (void)viewDidLoad {
    _invalidLogin.hidden = true;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginBtnPressed:(id)sender {
    [self removeSpaceFromLoginPassword];
    [self validateLoginInputs];
}

-(void)removeSpaceFromLoginPassword{
    newLoginPassword = [_passwordLogin.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void)validateLoginInputs{
    [[FIRAuth auth]signInWithEmail:_emailLogin.text password:newLoginPassword completion:^(FIRUser *user, NSError *error){
        if(error){
            _invalidLogin.hidden = false;
        }
        
    }];
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
