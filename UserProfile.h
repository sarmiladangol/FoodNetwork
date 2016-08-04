//
//  UserProfile.h
//  FoodNetwork
//
//  Created by Sarmila on 7/12/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserProfile : NSObject
@property (nonatomic,strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong)NSMutableArray *userProfileArray;
@property (strong, nonatomic) NSString *profileImageDownloadURL;
@property (strong, nonatomic) UIImage *profileImage;

-(instancetype)initUserProfileWithEmail:(NSString *)email username:(NSString *)username uid:(NSString *)uid;


@end
