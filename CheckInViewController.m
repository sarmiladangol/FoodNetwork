//
//  CheckInViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/27/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "CheckInViewController.h"
#import "Restaurant.h"
#import "History.h"
#import "FoodNetworkDetailsViewController.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface CheckInViewController ()
@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _checkinNameLabel.text = _checkinRestaurant.restaurantName;
    _checkinAddressLabel.text = _checkinRestaurant.restaurantAddress;
    _checkinWebsiteLabel.text = _checkinRestaurant.restaurantWebsite;
    _checkinPhoneLabel.text = _checkinRestaurant.restaurantPhoneNumber;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveBtnPressed:(id)sender {
    [self createHistoryOfCheckedInRestaurantOnFirebase];
}

-(void)createHistoryOfCheckedInRestaurantOnFirebase {
    if ([FIRAuth auth].currentUser != nil) {
        
        FIRDatabaseReference *checkinRestauranRef = [[[[FIRDatabase database]reference]child:@"history"]childByAutoId];

        History *newHistory = [[History alloc]init];
        newHistory.checkinRestaurantName = _checkinRestaurant.restaurantName;
        newHistory.checkinRestaurantAddress = _checkinRestaurant.restaurantAddress;
        newHistory.checkinRestaurantPhone =_checkinRestaurant.restaurantPhoneNumber;
        newHistory.checkinRestaurantWebsite = _checkinRestaurant.restaurantWebsite;
        
        NSDictionary *newCheckinRestaurantDict = @{@"checkedIn_restaurant_name": newHistory.checkinRestaurantName, @"checkedIn_restaurant_address":newHistory.checkinRestaurantAddress, @"checkedIn_restaurant_phone":newHistory.checkinRestaurantPhone, @"checkedIn_restaurant_website":newHistory.checkinRestaurantWebsite};
       
        [checkinRestauranRef setValue:newCheckinRestaurantDict];
    }
}

@end
