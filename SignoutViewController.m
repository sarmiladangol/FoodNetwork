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
@import FirebaseDatabase;
@import Firebase;

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
    
     [self listenForChangesInUserProfile];
  //  [self getCurrentUserProfileFromFirebase];
    [self getCurrentUserProfileFromFirebase];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)listenForChangesInUserProfile {
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&& LISTENNNNNN&&&&&&&&&&&&&&");
    FIRDatabaseReference *UserProfileRef = [[[FIRDatabase database]reference]child:@"userprofile"];
    FIRDatabaseQuery *currentUserProfileChangedQuery = [[UserProfileRef queryOrderedByChild:@"userId"] queryEqualToValue:[FIRAuth auth].currentUser.uid];
    
    [currentUserProfileChangedQuery observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot) {
        
        _currentUser = [[UserProfile alloc]initUserProfileWithEmail:snapshot.value[@"email"] username:snapshot.value[@"username"] password:snapshot.value[@"password"] uid:snapshot.value[@"uid"]];
        NSLog(@"%@", _currentUser.description);
//        _currentUser = [[UserProfile alloc]initUserProfileWithEmail:snapshot.value[@"email"] username:snapshot.value[@"username"] uid:snapshot.value[@"userId"]];
//       
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [_usernameLabel setText:[NSString stringWithFormat:@"Hello, %@!", _currentUser.username]];
            [_emailLabel setText:[NSString stringWithFormat:@"Hello, %@", _currentUser.email]];
        });
    }];
}

//Gets the current user's UserProfile from Firebase.
-(void)getCurrentUserProfileFromFirebase {
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&& GET CURRENT USER FROM FB &&&&&&&&&&&&&&");
    FIRDatabaseReference *UserProfileRef = [[[FIRDatabase database]reference]child:@"userprofile"];
    FIRDatabaseQuery *currentUserProfileQuery = [[UserProfileRef queryOrderedByChild:@"userId"] queryEqualToValue:[FIRAuth auth].currentUser.uid];
    [currentUserProfileQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        _currentUserProfileKey = snapshot.key;
        _currentUser = [[UserProfile alloc]initUserProfileWithEmail:snapshot.value[@"email"] username:snapshot.value[@"username"] password:snapshot.value[@"password"] uid:snapshot.value[@"uid"]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_usernameLabel setText:[NSString stringWithFormat:@"%@!", _currentUser.username]];
            [_emailLabel setText:[NSString stringWithFormat:@"%@", _currentUser.email]];
        });
    }];
}

- (IBAction)signOutBtnPressed:(id)sender {
    NSLog(@"SIGNOUT BTN RESSED !");
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"no error");
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
