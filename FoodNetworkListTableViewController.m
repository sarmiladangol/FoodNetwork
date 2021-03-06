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
@property (strong, nonatomic) NSMutableArray *temporaryRestaurantArray;
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
}

-(void)getRestaurantFromDatabase{
    NSLog(@"GET RESTAURANT FROM DATABASE");
    _restaurantArray = [[NSMutableArray alloc]init];
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    FIRDatabaseReference *restaurantsRef = [ref child:@"restaurants"];
    [restaurantsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot){
        
        Restaurant *newRestaurant = [[Restaurant alloc]init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            newRestaurant.uid = snapshot.key;
            if([child.key isEqualToString:@"restaurant_name"]){
                newRestaurant.restaurantName = child.value;
            }
            if ([child.key isEqualToString:@"location"]){
                NSArray *items = [child.value componentsSeparatedByString:@","];
                
                float latitude =[[items objectAtIndex:0] floatValue];
                float longitude =[[items objectAtIndex:1] floatValue];
                newRestaurant.location = CLLocationCoordinate2DMake(latitude, longitude);
            }
            
            if([child.key isEqualToString:@"restaurant_address"]){
                newRestaurant.restaurantAddress = child.value;
            }
            if([child.key isEqualToString:@"restaurant_phone"]){
                newRestaurant.restaurantPhoneNumber = child.value;
            }
            
            if([child.key isEqualToString:@"location"]){
                newRestaurant.restaurantLocation = child.value;
            }
            
            if ([child.key isEqualToString:@"restaurant_rating"]) {
                newRestaurant.restaurantRating = child.value;
            }
            
            if([child.key isEqualToString:@"restaurant_website"]){
                newRestaurant.restaurantWebsite = child.value;
            }
            if([child.key isEqualToString:@"restaurant_types"]){
                newRestaurant.restaurantTypes = child.value;
            }
        }
        
        [_restaurantArray addObject:newRestaurant];
        
        [self.restaurantTableView reloadData];
    }];
}


-(void)getCurrentInfo{
     NSLog(@"GET CURRENT INFO");
    _placesClient = [GMSPlacesClient sharedClient];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        else {NSLog(@"Error is nil");}
        
        if (placeLikelihoodList != nil) {
            
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            
            if (place != nil) {
                _currentLocation = place.coordinate;
            }
            else{
                _currentLocation = place.coordinate;            }
        }
        else{
            NSLog(@"**********************placeLikelihoodList is nil");
        }
    }];
}
- (IBAction)pickPlace:(id)sender {
     NSLog(@"PICK PLACE");
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
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
            // newRestaurant.restaurantName = place.name;
            
            
            // check if any PLACE key value is NULL
            if (place.name == nil) {
                newRestaurant.restaurantName = @"Name is not available";
            }
            else {
                newRestaurant.restaurantName = place.name;
            }
            
            if (place.phoneNumber == nil) {
                newRestaurant.restaurantPhoneNumber = @"Phone is not available";
            }
            else {
                newRestaurant.restaurantPhoneNumber = place.phoneNumber;
            }
            
            if (place.website == nil)
            {
                newRestaurant.restaurantWebsite = @"Website is not available";
            }
            else {
                //convert WEBSITE from NSURL to NSString in order to store in NSDICTIONARY
                urlToString = [place.website absoluteString];
                newRestaurant.restaurantWebsite = urlToString;
            }
            
            if (place.types == nil) {
                newRestaurant.restaurantTypes = @"Type is not available";
            }
            else{
            newRestaurant.restaurantTypes = place.types[1].description;
            }
            
            //newRestaurant.restaurantPhoneNumber = place.phoneNumber;
           // newRestaurant.restaurantTypes = place.types[1].description;
            NSString *newRating = [NSString stringWithFormat:@"%f", place.rating];
            if (newRating == nil) {
                newRestaurant.restaurantRating = @"Rating is not available";
                NSLog(@" NIL *** newRestaurant.restaurantRating %@", newRestaurant.restaurantRating);
            }
            else{
            //convert RATING from float to NSString in order to store in NSDICTIONARY
           // NSString *newRating = [NSString stringWithFormat:@"%f", place.rating];
            newRestaurant.restaurantRating = newRating;
                NSLog(@" NOT NIL *** newRestaurant.restaurantRating %@", newRestaurant.restaurantRating);
            }
            
           // newRestaurant.restaurantAddress = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            

            NSString *formattedAddress = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@", "];
            
            if (formattedAddress == nil) {
                newRestaurant.restaurantAddress = @"Address is not available";
                NSLog(@"NIL *** newRestaurant.restaurantAddress= %@",newRestaurant.restaurantAddress);
            }
            
            else{
                newRestaurant.restaurantAddress = formattedAddress;
                NSLog(@"NOT NIL *** newRestaurant.restaurantAddress= %@",newRestaurant.restaurantAddress);
            }
            
            NSString *locationStringToPass = [NSString stringWithFormat:@"%f, %f", newRestaurant.location.latitude, newRestaurant.location.longitude];
            
           
            
            newRestaurant.restaurantLatitude = [NSString stringWithFormat:@"%f", newRestaurant.location.latitude];
            newRestaurant.restaurantLongitude = [NSString stringWithFormat:@"%f", newRestaurant.location.longitude];
            
            
            NSDictionary *newRestaurantInfo = @{@"restaurant_name":newRestaurant.restaurantName, @"location":locationStringToPass, @"restaurant_phone":newRestaurant.restaurantPhoneNumber, @"restaurant_address":newRestaurant.restaurantAddress, @"restaurant_website":newRestaurant.restaurantWebsite,@"restaurant_rating":newRestaurant.restaurantRating, @"restaurant_types":newRestaurant.restaurantTypes};
             NSLog(@"NEW RESTAURANT DICTIONARY = %@",newRestaurant.description);
            
            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
            FIRDatabaseReference *restaurantRef = [ref child:@"restaurants"].childByAutoId;
            [restaurantRef setValue:newRestaurantInfo];
        }
    }];
}

- (IBAction)searchRestaurantButton:(UIButton *)sender {
    [self searchRestaurants];
    [self.restaurantTableView reloadData];
}


- (NSString*) sanitizeString:(NSString *)output {
    // Create set of accepted characters
    NSMutableCharacterSet *acceptedCharacters = [[NSMutableCharacterSet alloc] init];
    [acceptedCharacters formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    [acceptedCharacters formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [acceptedCharacters addCharactersInString:@" _-.!"];
    
    // Remove characters not in the set
    output = [[output componentsSeparatedByCharactersInSet:[acceptedCharacters invertedSet]] componentsJoinedByString:@""];
    output = [output lowercaseString];
    return output;
}


- (void)searchRestaurants {
    
    NSString *searchRestaurantText;
    _searchRestaurantArray = [[NSMutableArray alloc]init];
    
    searchRestaurantText =[_searchRestaurantTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    searchRestaurantText = [self sanitizeString:searchRestaurantText];
    
    for (Restaurant *restaurant in _restaurantArray) {
        if ([[[self sanitizeString:restaurant.restaurantName] stringByReplacingOccurrencesOfString:@" " withString:@""] containsString:searchRestaurantText]) {
            [_searchRestaurantArray addObject:restaurant];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //If not even a single restaurant is added in a List then _restaurantArray will be empty and its count is zero. So, no data is available to display in table view cell
    
    NSInteger numOfSections = 0;
    if ([_restaurantArray count] > 0)
    {
        self.restaurantTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = 1;
        self.restaurantTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.restaurantTableView.bounds.size.width, self.restaurantTableView.bounds.size.height)];
        noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor brownColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        noDataLabel.textColor = [UIColor brownColor];
        self.restaurantTableView.backgroundView = noDataLabel;
        self.restaurantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchRestaurantArray count] == 0) {
        return [_restaurantArray count];
    } else {
        return [_searchRestaurantArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.restaurantTableView.contentInset = UIEdgeInsetsMake(0, -15, 0, -30);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"r1.jpg"];
    
    if ([_searchRestaurantArray count] == 0) {
        Restaurant *restaurantInCell = [_restaurantArray objectAtIndex:indexPath.row];
        tableView.rowHeight = 60;
    
        cell.textLabel.text = restaurantInCell.restaurantName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", restaurantInCell.restaurantAddress];
        cell.detailTextLabel.numberOfLines = 2;
    }
    else{
        Restaurant *restaurantInCell = [_searchRestaurantArray objectAtIndex:indexPath.row];
        cell.textLabel.text = restaurantInCell.restaurantName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", restaurantInCell.restaurantAddress];
    }
    
    [cell layoutIfNeeded];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FoodNetworkDetailsViewController *vc = [segue destinationViewController];
    NSIndexPath *selectedIndex = [self.restaurantTableView indexPathForSelectedRow];
    if ([_searchRestaurantArray count] == 0) {
     vc.currentRestaurant = [_restaurantArray objectAtIndex:selectedIndex.row];
    }
    else{
    vc.currentRestaurant = [_searchRestaurantArray objectAtIndex:selectedIndex.row];
    }
}


@end
