//
//  signupViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/11/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "signupViewController.h"
#import "UserProfile.h"
@import Firebase;
@import FirebaseAuth;

@interface signupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailSignUp;
@property (weak, nonatomic) IBOutlet UITextField *usernameSignUp;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUp;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordSignUp;
@property (weak, nonatomic) IBOutlet UILabel *invalidEntry;

@end

@implementation signupViewController
NSString *newPassword;
NSString *retypeNewPassword;

- (void)viewDidLoad {
    _invalidEntry.hidden = true;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signupBtnPressed:(id)sender {
    [self signUpUserToFirebase];
}

-(void)signUpUserToFirebase{
    [self removeSpaceFromPassword];
    [self validateInputs];
}

-(void)removeSpaceFromPassword{
    
    newPassword = [_passwordSignUp.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    retypeNewPassword = [_retypePasswordSignUp.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

-(void)validateInputs{
    
    if(![newPassword isEqualToString:retypeNewPassword]){
        _invalidEntry.hidden = false;
        _invalidEntry.text=@"Unmatched password";
    }
    
    else if([_usernameSignUp.text isEqualToString:@" "]|| [_usernameSignUp.text isEqualToString:@""]){
        _invalidEntry.hidden = false;
        _invalidEntry.text = @"Invalid username";
    }
    
    else {
        [[FIRAuth auth]
         createUserWithEmail:_emailSignUp.text
         password:newPassword
         completion:^(FIRUser *_Nullable user,
                      NSError *_Nullable error) {
             
             if(error.code == 17007){
                 _invalidEntry.hidden = false;
                 _invalidEntry.text = @"Email already in use";
             }
             else if(error.code == 17026){
                 _invalidEntry.hidden = false;
                 _invalidEntry.text = @"Invalid password";
             }
             else if(error){
                 _invalidEntry.hidden = false;
                 _invalidEntry.text=@"Invalid email or password";
             }
             else{
                 _invalidEntry.hidden=true;
                 [self createUserProfileOnFirebase];
             }
            
         }] ;
    }
}

-(void)createUserProfileOnFirebase{

    if ([FIRAuth auth].currentUser != nil) {
       FIRDatabaseReference *currentUserProfileRef = [[[[FIRDatabase database]reference]child:@"userprofile"]childByAutoId];

        
        UserProfile *newUserProfile = [[UserProfile alloc]initUserProfileWithEmail:_emailSignUp.text username:_usernameSignUp.text uid:[FIRAuth auth].currentUser.uid];
        newUserProfile.profileImageDownloadURL = @"https://firebasestorage.googleapis.com/v0/b/wire-e0cde.appspot.com/o/default_user.png?alt=media&token=d351d796-3f49-4f8f-8ca8-7d)1cd17f510";
        
        NSDictionary *newUserProfileDict = @{@"email": newUserProfile.email, @"username": newUserProfile.username, @"userId": newUserProfile.uid};
        
       // [currentUserProfileRef setValue:newUserProfileDict];
        [currentUserProfileRef updateChildValues: newUserProfileDict];
        [self performSegueWithIdentifier:@"signupSegue" sender:self];
        
        
        
       
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"signupSegue"])
    {
        FoodNetworkListTableViewController *vc = [segue destinationViewController];
        NSLog(@"%@", vc.description);
    }
}


@end
