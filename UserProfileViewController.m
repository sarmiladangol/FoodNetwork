//
//  UserProfileViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/25/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfile.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface UserProfileViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) FIRStorageReference *firebaseStorageRef;
@property (strong, nonatomic) NSString *currentUserProfileKey;
@property (strong, nonatomic) FIRStorage *firebaseStorage;
@property(strong, nonatomic) UserProfile *currentUser;

#pragma mark IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentUserProfilePhoto;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {

    //initializes Firebase Storage and creates reference to it.
    [self firebaseSetUp];
    //Sets up a listener for changes in the user's profile such as the profilePhotoDownloadURL.
    [self listenForChangesInUserProfile];
    //Initially gets the UserProfile associated with the currently logged in user.
    [self getCurrentUserProfileFromFirebase];
    
    [super viewDidLoad];
    
    //Trigger hamburger menu
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


#pragma mark Firebase Methods

//initializes Firebase Storage and creates reference to it.
-(void)firebaseSetUp {
    _firebaseStorage = [FIRStorage storage];
    _firebaseStorageRef = [_firebaseStorage referenceForURL:@"gs://inlaid-index-136923.appspot.com"];
}


//Gets the current user's UserProfile from Firebase.
-(void)getCurrentUserProfileFromFirebase {    FIRDatabaseReference *UserProfileRef = [[[FIRDatabase database]reference]child:@"userprofile"];
    FIRDatabaseQuery *currentUserProfileQuery = [[UserProfileRef queryOrderedByChild:@"userId"] queryEqualToValue:[FIRAuth auth].currentUser.uid];
    [currentUserProfileQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        _currentUserProfileKey = snapshot.key;
        _currentUser = [[UserProfile alloc]initUserProfileWithEmail:snapshot.value[@"email"] username:snapshot.value[@"username"] uid:snapshot.value[@"userId"]];
        _currentUser.profileImageDownloadURL = snapshot.value[@"profilePhotoDownloadURL"];
        _currentUser.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snapshot.value[@"profilePhotoDownloadURL"]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_currentUserProfilePhoto setImage:_currentUser.profileImage];
            [_usernameLabel setText:[NSString stringWithFormat:@"%@", _currentUser.username]];
            NSLog(@"USERNAME = %@", _currentUser.username);
            [_emailLabel setText:[NSString stringWithFormat:@"%@", _currentUser.email]];
            NSLog(@"EMAIL = %@", _currentUser.email);
        });
    }];
}

/*
 Listens for changes to the current user's UserProfile.
 This uses FIRDataEventTypeChildChange, which is similar to FIRDataEventTypeChildAdded
 except that it occurrs when a child node's value is changed in some way and not
 when a new child is added.
 */

-(void)listenForChangesInUserProfile {
    FIRDatabaseReference *UserProfileRef = [[[FIRDatabase database]reference]child:@"userprofile"];
    FIRDatabaseQuery *currentUserProfileChangedQuery = [[UserProfileRef queryOrderedByChild:@"userId"] queryEqualToValue:[FIRAuth auth].currentUser.uid];
    
    [currentUserProfileChangedQuery observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot) {
        _currentUser = [[UserProfile alloc]initUserProfileWithEmail:snapshot.value[@"email"] username:snapshot.value[@"username"] uid:snapshot.value[@"userId"]];
        _currentUser.profileImageDownloadURL = snapshot.value[@"profilePhotoDownloadURL"];
        _currentUser.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snapshot.value[@"profilePhotoDownloadURL"]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_currentUserProfilePhoto setImage:_currentUser.profileImage];
            [_usernameLabel setText:[NSString stringWithFormat:@"%@!", _currentUser.username]];
            NSLog(@"USERNAME LISTEN = %@", _currentUser.username);
        });
    }];
}

/*
 This accepts the NSData that is returned from the image picker and then saves it on Firebase Storage.
 Once it is stored in Firebase storage it gives us back a downloadURL.
 */
-(void)uploadPhotoToFirebase:(NSData *)imageData {
    
    //Create a uniqueID for the image and add it to the end of the images reference.
    NSString *uniqueID = [[NSUUID UUID]UUIDString];
    NSString *newImageReference = [NSString stringWithFormat:@"profilePhotos/%@.jpg", uniqueID];
  
    //imagesRef creates a reference for the images folder and then adds a child to that folder, which will be every time a photo is taken.
    FIRStorageReference *imagesRef = [_firebaseStorageRef child:newImageReference];
   
    //This uploads the photo's NSData onto Firebase Storage.
    FIRStorageUploadTask *uploadTask = [imagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.description);
        } else {
            _currentUser.profileImageDownloadURL = metadata.downloadURL.absoluteString;
            [self updateCurrentUserProfileImageDownloadURLOnFirebaseDatabase:_currentUser];
        }
    }];
    [uploadTask resume];
}

/*
 This accepts a UserProfile object to update (which will be our current user profile).
 When the UserProfile object is passed it will already have an updated URL from when the new photo
 is taken and the metaDataURL is sent back. It then updates the child node on Firebase.
 */
-(void)updateCurrentUserProfileImageDownloadURLOnFirebaseDatabase:(UserProfile *)userProfile {
    //NSLog(@"************ UPDATE CURRENT USER PROFILE IMAGE DOWNLOAD URL ON FIREBASE DATABASE ********** ");

    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    
    /*
     Need every value filled or it will just remove what we didn't put in the dictionary.
     For an example if the profileImageDownloadURL was the only thing we put in this dictionary
     and used this dictionary to update the child node then the email, userId and the username
     would be removed and only the profilePhotoDownloadURL would be in that child node.
     */
    NSDictionary *userProfileToUpdate = @{@"profilePhotoDownloadURL": userProfile.profileImageDownloadURL,
                                          @"email": userProfile.email,
                                          @"userId": userProfile.uid,
                                          @"username": userProfile.username};
    
    NSDictionary *childUpdates = @{[@"/userprofile/" stringByAppendingString:_currentUserProfileKey]: userProfileToUpdate};
    
    [firebaseRef updateChildValues:childUpdates];
    
}
#pragma mark Custom View Set Up

//Rounds the profile photo
-(void)viewWillLayoutSubviews {
    _currentUserProfilePhoto.layer.borderWidth = 4.0;
    _currentUserProfilePhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
    _currentUserProfilePhoto.layer.cornerRadius = 10.0f;
    _currentUserProfilePhoto.layer.masksToBounds = TRUE;
}


//Presents the camera when the profile photo is selected
- (IBAction)profilePhotoSelected:(id)sender {
    [self presentCamera];
}


#pragma mark Camera Methods.
//Presents the iPhone's camera and is called when the profile photo is selected.
-(void)presentCamera {
    _imagePicker = [[UIImagePickerController alloc] init];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:_imagePicker animated:true completion:nil];
}

/*
 Occurrs when the camera finishes taking the photo.
 It then uses the reduceImageSize func and uploadPhotoToFirebase func
 to reduce the image's size and then send it to Firebase.
 */

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1);
    UIImage *image = [UIImage imageWithData:imageData];
    NSData *resizedImgData =  UIImageJPEGRepresentation([self reduceImageSize:image], .80);
    [self uploadPhotoToFirebase:resizedImgData];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//Accepts a UIImage and reduces the size of it.
-(UIImage *)reduceImageSize:(UIImage *)image {
    CGSize newSize = CGSizeMake(image.size.width/10, image.size.height/10);
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    return smallImage;
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
