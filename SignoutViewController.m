//
//  SignoutViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/25/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "SignoutViewController.h"
@import FirebaseAuth;
#import "UserProfile.h"

@interface SignoutViewController ()

@property(strong, nonatomic) UserProfile *currentUser;

@end

@implementation SignoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Trigger hamburger menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)signOutBtnPressed:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        [self performSegueWithIdentifier:@"signoutSegue" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"signoutSegue"])
    {
        loginViewController *vc = [segue destinationViewController];
    }
}


@end
