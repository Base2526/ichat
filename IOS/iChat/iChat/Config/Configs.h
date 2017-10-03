//
//  Configs.h
//  Configs
//
//  Created by somkid simajarn on 9/10/2558 BE.
//  Copyright (c) 2558 bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AppConstant.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

//#import <CoreLocation/CoreLocation.h>

@interface Configs : NSObject

+ (Configs *)sharedInstance;

@property(nonatomic) NSString* API_URL , *END_POINT;

@property(nonatomic)NSString* USER_LOGIN;
@property(nonatomic)NSString* USER_REGISTER;
@property(nonatomic)NSString* USER_REQUEST_NEW_PASSWORD; // request_new_password
@property(nonatomic)NSString* USER_LOGOUT;
@property(nonatomic)NSString* USER_FORGOT_PASSWORD;

@property(nonatomic)NSString* FETCH_MY_PROFILE;
@property(nonatomic)NSString* UPDATE_MY_PROFILE;

@property(nonatomic)NSString* USER_FRINEDS;
@property(nonatomic)NSString* USER_FRINEDS_HEART;
@property(nonatomic)NSString* ADD_FRINEDS;
@property(nonatomic)NSString* ADD_LIST_FRINEDS;
@property(nonatomic)NSString* SEND_HEART_TO_FRINEDS;
@property(nonatomic)NSString* ACCEPT_FRIEND;
@property(nonatomic)NSString* NOT_ACCEPT_FRIEND;
@property(nonatomic)NSString* RESULT_SEARCH_FRIEND;

@property(nonatomic)NSString* PEOPLE_YOU_MAY_KNOW;
@property(nonatomic)NSString* EDIT_DISPLAY_NAME;
@property(nonatomic)NSString* EDIT_FRIEND_DISPLAY_NAME;

@property(nonatomic)NSString* UPDATE_PICTURE_PROFILE;

@property(nonatomic)NSString* CREATE_GROUP_CHAT;

@property(nonatomic)NSString* EDIT_PHONE;
@property(nonatomic)NSString* EDIT_MULTI_PHONE;
@property(nonatomic)NSString* EDIT_MULTI_EMAIL;

@property(nonatomic)NSString* TURN_OFF_NOTIFICATION;
@property(nonatomic)NSString* HIDE_FRIEND;
@property(nonatomic)NSString* CANCEL_WAIT_TO_ACCEPT;
@property(nonatomic)NSString* EDIT_STATUS_MESSAGE;

@property(nonatomic)NSString* SET_MY_ID;

@property(nonatomic)NSString* DELETE_FRIEND;
@property(nonatomic)NSString* SET_CLASS_FRIEND;
@property(nonatomic)NSString* ANNMOUSU;
@property(nonatomic)NSString* ANNMOUSU_REGISTER;
@property(nonatomic)NSString* ANNMOUSU_VERIFY;

@property(nonatomic)NSString* CREATE_MY_CARD;
@property(nonatomic)NSString* CREATE_MY_APPLICATION;
@property(nonatomic)NSString* DELETE_MY_APPLICATION;
@property(nonatomic)NSString* UPDATE_MY_APPLICATION_PROFILE; // UpdateMyAppProfileThread
@property(nonatomic)NSString* AED_POST;
@property(nonatomic)NSString* EDIT_POST;
@property(nonatomic)NSString* DELETE_POST;

@property(nonatomic)NSString* COMMENT_POST;

@property(nonatomic)NSString* APPLICATION_CATEGORY;

@property(nonatomic)NSString* TOKEN_NOTICATION;

@property(nonatomic)NSString* GET_STORE;
@property(nonatomic)NSString* GET_APP_DETAIL;

@property(nonatomic)NSString* GET_PROFILES;


// Send Heart by Class
@property(nonatomic)NSString* SHBY_CLASS;

// Update New Password
@property(nonatomic)NSString* UPDATE_NEW_PASSWORD;


@property(nonatomic) CGFloat kBarHeight;

// ความสูงของ navigationBar
@property(nonatomic) CGFloat navigationBarHeight;


// เวลาที่เรายอมให้ connect service
@property(nonatomic) CGFloat timeOut;


// ชือของ DB
@property(nonatomic) NSString *DBFileName;


// Global Function
-(NSString *)getUniqueDeviceIdentifierAsString;

-(BOOL) NSStringIsValidEmail:(NSString *)email;
-(BOOL)NSStringIsValidPhone:(NSString *)phoneNumber;

-(NSString *)pathCacheArchiver:(NSString *)fname;

- (void)registerForRemoteNotifications;

/*
 filename : ชื่อไฟล์
 data  : ข้อมูลที่เราต้องการบันทึก
 */
-(BOOL)saveData:(NSString *)filename :(NSMutableDictionary *)data;

/*
 filename : ชื่อไฟล์
 */
-(NSMutableDictionary *)loadData:(NSString *)filename;

-(void)removeData:(NSString *)filename;

/*
 ดึง Bundle identifier
 Ex. heart.idna
 */
-(NSString *)getBundleIdentifier;

/*
 ดึง Version Application
 Ex. 1.0
 */
-(NSString *)getVersionApplication;

/*
  เช็กว่า user login หรือไม่
 */
-(BOOL)isLogin;

/*
 ดึง UID User
 */
-(NSString *)getUIDU;

/*
 จะ Sync ข้อมูลใหม่ทุกครั่งที่ login
*/
-(void)synchronizeData;

/*
เป็นการ Clear observeEventType ของ Firebase
 */
-(void)synchronizeLogout;




// Cumstom SVProgressHUD
-(void)SVProgressHUD_ShowWithStatus:(NSString *)message;
-(void)SVProgressHUD_ShowSuccessWithStatus:(NSString *)message;
-(void)SVProgressHUD_ShowErrorWithStatus:(NSString *)message;
-(void)SVProgressHUD_Dismiss;




@end


/*

@interface Configs : NSObject

+ (Configs *)sharedInstance;

@property(nonatomic) NSString* API_URL , *END_POINT;

@property(nonatomic)NSString* USER_LOGIN;
@property(nonatomic)NSString* USER_REGISTER;
@property(nonatomic)NSString* USER_REQUEST_NEW_PASSWORD; // request_new_password
@property(nonatomic)NSString* USER_LOGOUT;

@property(nonatomic)NSString* FETCH_MY_PROFILE;
@property(nonatomic)NSString* UPDATE_MY_PROFILE;

@property(nonatomic)NSString* USER_FRINEDS;
@property(nonatomic)NSString* USER_FRINEDS_HEART;
@property(nonatomic)NSString* ADD_FRINEDS;
@property(nonatomic)NSString* ADD_LIST_FRINEDS;
@property(nonatomic)NSString* SEND_HEART_TO_FRINEDS;
@property(nonatomic)NSString* ACCEPT_FRIEND;
@property(nonatomic)NSString* NOT_ACCEPT_FRIEND;
@property(nonatomic)NSString* RESULT_SEARCH_FRIEND;

@property(nonatomic)NSString* PEOPLE_YOU_MAY_KNOW;
@property(nonatomic)NSString* EDIT_DISPLAY_NAME;

@property(nonatomic)NSString* UPDATE_PICTURE_PROFILE;


// Global Function
-(NSString *)getUniqueDeviceIdentifierAsString;

-(BOOL) NSStringIsValidEmail:(NSString *)email;

@end
*/
