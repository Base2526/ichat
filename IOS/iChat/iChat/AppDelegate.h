//
//  AppDelegate.h
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;



#import "HJObjManager.h"
#import "Configs.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) HJObjManager *obj_Manager;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@property (strong, nonatomic) NSMutableDictionary *friendsProfile;
/*
 การ Observe Event friends ทั้งหมด
 */
- (void)observeEventType;

@end

