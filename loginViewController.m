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
    
    [self viewWillAppear:self];
    [super viewDidLoad];
}
// To hide BACK button in navigation bar
- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginBtnPressed:(id)sender {
    [self removeSpaceFromLoginPassword];
    [self validateLoginInputs];
    //[self performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void)removeSpaceFromLoginPassword{
    newLoginPassword = [_passwordLogin.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void)validateLoginInputs{
    [[FIRAuth auth]signInWithEmail:_emailLogin.text password:newLoginPassword completion:^(FIRUser *user, NSError *error){
        if(error){
            _invalidLogin.hidden = false;
        }
        else{
            _invalidLogin.hidden = true;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loginSegue"])
    {
        FoodNetworkListTableViewController *vc = [segue destinationViewController];
        NSLog(@"%@", vc.description);
    }
}


@end
