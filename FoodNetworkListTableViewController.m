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
}

- (void)viewDidLoad {
    [self getRestaurantFromDatabase];
    [super viewDidLoad];
    [self getCurrentInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getRestaurantFromDatabase{
    NSLog(@"**********GET RESTAURANT FROM DATABASE ********************");
    _restaurantArray = [[NSMutableArray alloc]init];
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    FIRDatabaseReference *restaurantsRef = [ref child:@"restaurants"];
    [restaurantsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapchat){
        Restaurant *newRestaurant = [[Restaurant alloc]init];
        for (FIRDataSnapshot *child in snapchat.children) {
            newRestaurant.uid = snapchat.key;
            if([child.key isEqualToString:@"restaurant_name"]){
                newRestaurant.restaurantName = child.value;
            }
            if ([child.key isEqualToString:@"location"]){
                NSArray *items = [child.value componentsSeparatedByString:@","];
                float latitude =[[items objectAtIndex:0] floatValue];
                float longitude =[[items objectAtIndex:1] floatValue];
                newRestaurant.location = CLLocationCoordinate2DMake(latitude, longitude);
            }
            
        }
        [_restaurantArray addObject:newRestaurant];
        [self.restaurantTableView reloadData];
    }];
}

-(void)getCurrentInfo{
    NSLog(@"***************_placesClient=%@", _placesClient.description);
    _placesClient = [GMSPlacesClient sharedClient];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
      //  NSLog(@"test");
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        else {NSLog(@"Error is nil");}
        
       // self.nameLabel.text = @"No current place";
        //NSLog(@"namelabel=%@",self.nameLabel.text);
        //self.addressLabel.text = @"";
        //NSLog(@"addresslabel=%@",self.addressLabel.text);
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            
            if (place != nil) {
            }
            else{
                NSLog(@"Place is nil");
                _currentLocation = place.coordinate;
            }
        }
        else{
            NSLog(@"placeLikelihoodList is nil");
        }
    }];
}
- (IBAction)pickPlace:(id)sender {

       CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
   // CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.3649315,-83.0751159);
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
            Restaurant *newRestaurant = [[Restaurant alloc]init];
            newRestaurant.restaurantName = place.name;
            newRestaurant.restaurantAddress = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            newRestaurant.restaurantPhoneNumber = place.phoneNumber;
            newRestaurant.restaurantWebsite = place.website;
            urlToString = place.website.absoluteString;
            
            NSLog(@"\n NEW RESTAURANT NAME=%@\n NEW RESTAURANT PHONE NUMBER= %@\n NEW RESTAURANT WEBSITE= %@\n", newRestaurant.restaurantName, newRestaurant.restaurantPhoneNumber, newRestaurant.restaurantWebsite);
            NSLog(@"NEW RETAURANT ADDRESS=%@",newRestaurant.restaurantAddress);
            
            NSString *newAdd = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@", "];
            
            NSString *locationStringToPass = [NSString stringWithFormat:@"%f, %f", newRestaurant.location.latitude, newRestaurant.location.longitude];
            NSDictionary *newRestaurantInfo = @{@"restaurant_name":newRestaurant.restaurantName, @"location":locationStringToPass, @"restaurant_phone":newRestaurant.restaurantPhoneNumber, @"restaurant_address":newAdd, @"restraurant_website":urlToString};
            
            NSLog(@"DICTIONARY=%@", newRestaurantInfo.description);
            
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    
    Restaurant *restaurantInCell = [_restaurantArray objectAtIndex:indexPath.row];
    cell.textLabel.text = restaurantInCell.restaurantName;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FoodNetworkDetailsViewController *vc = [segue destinationViewController];
    NSIndexPath *selectedIndex = [self.restaurantTableView indexPathForSelectedRow];
    vc.currentRestaurant = [_restaurantArray objectAtIndex:selectedIndex.row];
}


@end
