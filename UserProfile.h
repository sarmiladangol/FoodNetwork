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
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong)NSMutableArray *userProfileArray;

-(instancetype)initUserProfileWithEmail:(NSString *)email password:(NSString *)password uid:(NSString *)uid;


@end
