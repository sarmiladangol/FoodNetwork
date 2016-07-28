//
//  FoodNetworkListTableViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/14/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "FoodNetworkListTableViewController.h"
#import "FoodNetworkDetailsViewController.h"
@import GoogleMaps;
@import Firebase;
@import FirebaseDatabase;

@interface FoodNetworkListTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (strong, nonatomic) NSMutableArray *searchRestaurantArray;
@property (weak, nonatomic) IBOutlet UITextField *searchRestaurantTextField;

@end

@implementation FoodNetworkListTableViewController{
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
    NSString *urlToString;
    NSString *currentLongitude;
    NSString *currentLatitude;
}

- (void)viewDidLoad {
    [self getRestaurantFromDatabase];
    [super viewDidLoad];
    [self getCurrentInfo];
    
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
    // Dispose of any resources that can be recreated.
}

-(void)getRestaurantFromDatabase{
    _restaurantArray = [[NSMutableArray alloc]init];
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    FIRDatabaseReference *restaurantsRef = [ref child:@"restaurants"];
    [restaurantsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot){
        
        Restaurant *newRestaurant = [[Restaurant alloc]init];
       // NSLog(@"snapchotDescription=%@", snapshot.description);
        
        for (FIRDataSnapshot *child in snapshot.children) {
            newRestaurant.uid = snapshot.key;
            if([child.key isEqualToString:@"restaurant_name"]){
                newRestaurant.restaurantName = child.value;
               // NSLog(@"!!!!!!!!!!!!!!!!!!!!NAME= %@", newRestaurant.restaurantName);
            }
            if ([child.key isEqualToString:@"location"]){
                NSArray *items = [child.value componentsSeparatedByString:@","];
                
              //  NSLog(@"!!!!!!!!!!!!!!!!ITEMS = %@", items.description);
                float latitude =[[items objectAtIndex:0] floatValue];
                float longitude =[[items objectAtIndex:1] floatValue];
                newRestaurant.location = CLLocationCoordinate2DMake(latitude, longitude);
                //NSLog(@"!!!!!!!!!!!!!!!!RESTAURANT LCATION=%@", newRestaurant.location);
            }
            
            if([child.key isEqualToString:@"restaurant_address"]){
                newRestaurant.restaurantAddress = child.value;
               // NSLog(@"ADDRESS !!!!=%@",newRestaurant.restaurantAddress);
            }
            if([child.key isEqualToString:@"restaurant_phone"]){
                newRestaurant.restaurantPhoneNumber = child.value;
               // NSLog(@"PH !!!=%@", child.value);
            }
            
            if([child.key isEqualToString:@"location"]){
                newRestaurant.restaurantLocation = child.value;
               // NSLog(@"LOCATION !!!!!!!!!!!= %@", child.value);
               // NSLog(@"Location !!!=%@", child.description);
            }
            
            if ([child.key isEqualToString:@"restaurant_rating"]) {
                newRestaurant.restaurantRating = child.value;
                //NSLog(@"RATING $$$$= %@", child.value);
            }
            
            if([child.key isEqualToString:@"restaurant_website"]){
                newRestaurant.restaurantWebsite = child.value;
              //  NSLog(@"WEBSITE $$$$$$!!!=%@", child.value);
            }
            if([child.key isEqualToString:@"restaurant_types"]){
                newRestaurant.restaurantTypes = child.value;
            }
        }
        
        [_restaurantArray addObject:newRestaurant];
        //NSLog(@"!!!COUNT= %lu", (unsigned long)_restaurantArray.count);
        //NSLog(@"!!!!!!!!!RESTAURANT ARRAY = %@", [[_restaurantArray objectAtIndex:0] restaurantName]);
        
        [self.restaurantTableView reloadData];
    }];
}

-(void)getCurrentInfo{
    _placesClient = [GMSPlacesClient sharedClient];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
    
     //   NSLog(@"********PLACESCLIENT*********%@", _placesClient.description);
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        else {NSLog(@"Error is nil");}
        
        if (placeLikelihoodList != nil) {
            
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            
            if (place != nil) {
                _currentLocation = place.coordinate;
               //NSLog(@"_currentLocation=%f %f", _currentLocation.longitude, _currentLocation.latitude);
            }
            else{
                _currentLocation = place.coordinate;
             //   NSLog(@"_currentLocation=%f %f", _currentLocation.longitude, _currentLocation.latitude);
            }
        }
        else{
            NSLog(@"**********************placeLikelihoodList is nil");
        }
    }];
}
- (IBAction)pickPlace:(id)sender {

       CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
//   CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.3649315,-83.0751159);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"PLACE DESCRIPTION=%@", place.description);
            Restaurant *newRestaurant = [[Restaurant alloc]init];
            newRestaurant.location = place.coordinate;
            newRestaurant.restaurantName = place.name;
            newRestaurant.restaurantAddress = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            newRestaurant.restaurantPhoneNumber = place.phoneNumber;
            newRestaurant.restaurantTypes = place.types[1].description;
            
            //convert RATING from float to NSString in order to store in NSDICTIONARY
            NSString *newRating = [NSString stringWithFormat:@"%f", place.rating];
            newRestaurant.restaurantRating = newRating;
            
            
            //convert WEBSITE from NSURL to NSString in order to store in NSDICTIONARY
            urlToString = [place.website absoluteString];
            newRestaurant.restaurantWebsite = urlToString;
            
            
            NSString *formattedAddress = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@", "];
            
            NSString *locationStringToPass = [NSString stringWithFormat:@"%f, %f", newRestaurant.location.latitude, newRestaurant.location.longitude];

            newRestaurant.restaurantLatitude = [NSString stringWithFormat:@"%f", newRestaurant.location.latitude];
             newRestaurant.restaurantLongitude = [NSString stringWithFormat:@"%f", newRestaurant.location.longitude];
            
//            currentLatitude = [NSString stringWithFormat:@"%f", newRestaurant.location.latitude];
//            NSLog(@"CURRENT LATITUDE ======= @%@", currentLatitude);
            
            
            
            NSDictionary *newRestaurantInfo = @{@"restaurant_name":newRestaurant.restaurantName, @"location":locationStringToPass, @"restaurant_phone":newRestaurant.restaurantPhoneNumber, @"restaurant_address":formattedAddress, @"restaurant_website":newRestaurant.restaurantWebsite,@"restaurant_rating":newRestaurant.restaurantRating, @"restaurant_types":newRestaurant.restaurantTypes};
            
           // NSLog(@"DICTIONARY=%@", newRestaurantInfo.description);
            
            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
            FIRDatabaseReference *restaurantRef = [ref child:@"restaurants"].childByAutoId;
            [restaurantRef setValue:newRestaurantInfo];
        }
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [_restaurantArray count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // [self.restaurantTableView setContentInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.restaurantTableView.contentInset = UIEdgeInsetsMake(0, -15, 0, -30);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    
    Restaurant *restaurantInCell = [_restaurantArray objectAtIndex:indexPath.row];
    tableView.rowHeight = 60;
    
    cell.textLabel.text = restaurantInCell.restaurantName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", restaurantInCell.restaurantAddress];
    cell.detailTextLabel.numberOfLines = 2;
    cell.imageView.image = [UIImage imageNamed:@"r1.jpg"];
    [cell layoutIfNeeded];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FoodNetworkDetailsViewController *vc = [segue destinationViewController];
    NSIndexPath *selectedIndex = [self.restaurantTableView indexPathForSelectedRow];
    vc.currentRestaurant = [_restaurantArray objectAtIndex:selectedIndex.row];
}


@end
