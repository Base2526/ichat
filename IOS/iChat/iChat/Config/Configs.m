//
//  Configs.m
//  lottery
//
//  Created by somkid simajarn on 8/14/2558 BE.
//  Copyright (c) 2558 bit. All rights reserved.
//

#import "Configs.h"
#import <sys/utsname.h>
#import "SAMKeychain.h"
#import "SVProgressHUD.h"
#import "AppConstant.h"

#import "AppDelegate.h"

//#define IDIOM
//#define IPAD     UIUserInterfaceIdiomPad

@implementation Configs
{
    
}

+ (Configs *)sharedInstance
{
    static Configs *sharedInstance;
    
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[Configs alloc] init];
        
        return sharedInstance;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        // sindex.php
        self.API_URL            = @"http://128.199.247.179";
        self.END_POINT          = @"/api";
        
        // v1.0 login by name
        self.USER_LOGIN         = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user/login"];

        self.USER_REGISTER      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user/register"];
        // user/request_new_password.json
        self.USER_REQUEST_NEW_PASSWORD = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user/request_new_password"];
        self.USER_LOGOUT        = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/basic_user_logout_1"];
        self.USER_FORGOT_PASSWORD = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user_forgot_password"];
        
        
        /*
        self.LIST_ARTICLE       = @"/service_heart/list_article.json?_format=json";
        self.ADD_ARTICLE        = @"/service_heart/add_article.json?_format=json";
        self.EDIT_ARTICLE       = @"/service_heart/edit_article.json?_format=json";
        self.DELETE_ARTICLE     = @"/service_heart/delete_article.json?_format=json";
        
        self.DEVICE_PUSH_NOTIFICATION   = @"/service_heart/device_push_notification.json?_format=json";
        
        self.FRIEND_RECOMMENDATION      = @"/service_heart/list_friend_recommendation";
        */
        
        self.FETCH_MY_PROFILE   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/basic_fetch_profile"];// @"/service_heart/klovers_fetch_profile";
        self.UPDATE_MY_PROFILE  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_my_profile"];
        /*
        self.FETCH_MY_APP   = @"/service_heart/klovers_fetch_my_app";
        self.UPDATE_MY_APP  = @"/service_heart/klovers_update_my_app";
        
        self.PUBLIC_RELATIONS  = @"/sati_endpoint/sati_public_relations"; //
        //
        self.PHOTO_GALLERY = @"/sati_endpoint/sati_photo_gallery";
        
        // firebase
        // self.API_URL_FIREBASE               = @"https://blazing-torch-6635.firebaseio.com/heart";
        self.API_URL_FIREBASE_USER_LOGIN    = @"user_login";
        self.API_URL_FIREBASE_USER_FRIEND   = @"user_friend";
        self.API_URL_FIREBASE_SEND_HEART    = @"send_heart";
         */
        
        self.USER_FRINEDS           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user_friends"];
        self.USER_FRINEDS_HEART     = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/user_friends_heart"];
        self.ADD_FRINEDS            = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/add_friend"];
        self.ADD_LIST_FRINEDS       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/list_friends"];
        self.SEND_HEART_TO_FRINEDS  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/send_heart_to_friends"];
        self.ACCEPT_FRIEND          = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/accept_friend"];
        self.NOT_ACCEPT_FRIEND      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/not_accept_friend"];
        
        self.RESULT_SEARCH_FRIEND   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/search_friend_by_id"];
        self.PEOPLE_YOU_MAY_KNOW    = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/people_you_may_know"];
        self.EDIT_DISPLAY_NAME      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_display_name"];
        self.EDIT_FRIEND_DISPLAY_NAME = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_friend_display_name"];
        self.UPDATE_PICTURE_PROFILE = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_picture_profile"];
        self.EDIT_PHONE             = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_phone_v1_0"];
        self.EDIT_MULTI_PHONE       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_multi_phone"];
        self.EDIT_MULTI_EMAIL       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_multi_email"];
        
        self.TURN_OFF_NOTIFICATION  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/turn_off_notifications"];
        self.HIDE_FRIEND            = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/hide_friend"];
        self.CANCEL_WAIT_TO_ACCEPT  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/cancel_wait_to_accept"];
        
        self.EDIT_STATUS_MESSAGE    = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/edit_status_message"];
        
        self.SET_MY_ID              = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/set_my_id"];
        self.DELETE_FRIEND          = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_friend"];
        self.SET_CLASS_FRIEND       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/set_class_friend"];
        self.ANNMOUSU               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu"];
        self.ANNMOUSU_REGISTER      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu_register"];
        self.ANNMOUSU_VERIFY        = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu_verify"];
        
        self.SHBY_CLASS             = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/shby_class"];
        
        self.UPDATE_NEW_PASSWORD    = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_new_password"];
        
        
        self.CREATE_MY_CARD         = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_my_card"];
        self.CREATE_MY_APPLICATION  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_my_application"];
        self.DELETE_MY_APPLICATION  = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_my_application"];
        self.UPDATE_MY_APPLICATION_PROFILE = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/update_my_application_profile"];
        self.AED_POST               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/AED_post"];
        self.DELETE_POST            = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/delete_post"];
        
        self.COMMENT_POST           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/comment_post"];
        
        self.APPLICATION_CATEGORY   = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/application_category"];
        self.TOKEN_NOTICATION       = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/token_notication"];
        
        self.GET_STORE              = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_store"];
        self.GET_APP_DETAIL         = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_app_detail"];
        
        self.GET_PROFILES           = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/get_profiles"];
        
        self.CREATE_GROUP_CHAT      = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/create_group_chat"];
        
    
        self.kBarHeight = 50.0f;
        
        self.navigationBarHeight = 30.0f;
        
        self.timeOut    = 100.0f;
        
        self.DBFileName = @"db.sql";
    }
    return self;
}

/*
 เช็กว่า user login หรือไม่
 */
-(BOOL)isLogin{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (![self getUIDU]){
        return false;
    }
    return true;
}

/*
 ดึง UID User
 */
-(NSString *)getUIDU{
    return [[self loadData:_USER] objectForKey:@"user"][@"uid"];
}


-(NSString *)getUniqueDeviceIdentifierAsString
{
    
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SAMKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SAMKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
    }
    
    return strApplicationUUID;
}

-(BOOL) NSStringIsValidEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)NSStringIsValidPhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}

- (void)registerForRemoteNotifications
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}

-(NSString *)pathCacheArchiver:(NSString *)fname
{
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,   NSUserDomainMask, YES);
//    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
//    NSString *documentsResourcesPath = [documentPath  stringByAppendingPathComponent:@"MyAppCache"];
//    
//    NSString *fullPath = [documentsResourcesPath stringByAppendingPathComponent:@"file-heart.data"];
    
    NSString *documentdictionary;
    NSArray *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdictionary = [Path objectAtIndex:0];
    documentdictionary = [documentdictionary stringByAppendingPathComponent:@"Cache/"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentdictionary]){
        [[NSFileManager defaultManager] createDirectoryAtPath:documentdictionary withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *fullPath = [documentdictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", fname]];
    
    return fullPath;
}

-(BOOL)saveData:(NSString *)filename :(NSMutableDictionary *)data
{
    if (![NSKeyedArchiver archiveRootObject:data toFile:[self pathCacheArchiver:filename]])
    {
        return NO;
    }else{
        
        /* save เพิ่ม share ไปที่ Extension
         _DATA
         
         Try this:
         
         You can use NSKeyedArchiver to write out your dictionary to an NSData, which you can store among the preferences.
         
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.selectedOptionPositions];
         [[NSUserDefaults standardUserDefaults] setObject:data forKey:PREF_OPTIONS_KEY];
         
         For retrieving data:
         NSData *dictionaryData = [defaults objectForKey:PREF_OPTIONS_KEY];
         NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        */
        
        if ([filename isEqualToString:_DATA] || [filename isEqualToString:_USER]) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // do your task here
                
                if([filename isEqualToString:_DATA]){
                    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
                    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:@"data"];
                    [userDefaults synchronize];
                }else if([filename isEqualToString:_USER]){
                    NSUserDefaults *userDefaults =[[NSUserDefaults alloc] initWithSuiteName:@"group.heart.idna"];
                    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:@"user"];
                    [userDefaults synchronize];
                }

            });
        }
        
        return TRUE;
    }
}

-(NSMutableDictionary *)loadData:(NSString *)filename
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathCacheArchiver:filename]]) {
        return nil;
    }else{
        NSData *data = [NSData dataWithContentsOfFile:[self pathCacheArchiver:filename]];
        return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)removeData:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:[self pathCacheArchiver:filename] error:&error];
    if (success) {
        NSLog(@"> removeData %@", filename);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

/*
 ดึง Bundle identifier
 Ex. heart.idna
 */
-(NSString *)getBundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

/*
 ดึง Version Application
 Ex. 1.0
 */
-(NSString *)getVersionApplication
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/*
 จะ Sync ข้อมูลใหม่ทุกครั่งที่ login
 */
-(void)synchronizeData
{
    
    NSMutableArray *childObservers = [[NSMutableArray alloc] init];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    
    NSString *child = [NSString stringWithFormat:@"toonchat/%@/", [[Configs sharedInstance] getUIDU]];
    
    [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot.value);
        
        [self saveData:_DATA :snapshot.value];
        
        NSLog(@"%@", [self loadData:_DATA]);
        
        [childObservers addObject:[ref child:child]];
        
        // ดึงข้อมูล profile friends all
        NSMutableDictionary *friends = [[self loadData:_DATA] objectForKey:@"friends"];
        
        __block int count = 0;
        for (NSString* key in friends) {
            
            NSString *fchild = [NSString stringWithFormat:@"toonchat/%@/profiles", key];
            [[ref child:fchild] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                
                NSString* parent = snapshot.ref.parent.key;
                NSLog(@"%@, %@, %@", parent, snapshot.key, snapshot.value);
                
                count++;

                [childObservers addObject:[ref child:fchild]];
                
                [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] setObject:snapshot.value forKey:parent];
                
                /*
                 จะออกก็ต่อเมือดึงข้อมูลเสด ถึงคนสุดท้ายเท่านั้น
                 */
                if (friends.count == count) {
                    for (FIRDatabaseReference *ref in childObservers) {
                        [ref removeAllObservers];
                    }
                    
                    
                    [[Configs sharedInstance] saveData:_PROFILE_FRIENDS :[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile]];
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronizeData" object:self userInfo:@{}];
                }
            }];
        }
    }];
}

//-(void)synchronizeLogout{
//    for (FIRDatabaseReference *ref in childObservers) {
//        [ref removeAllObservers];
//    }
//}

/*
 ดึงค่าความสูงของ Tabbar //const CGFloat kBarHeight = 50;
 */


/*
 [[SVProgressHUD appearance] setHudBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]];
 //[[SVProgressHUD appearance] setHudForegroundColor:[UIColor yellowColor]];
 [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:16]];
 [self showImage:[[self sharedView] hudSuccessImage] status:string];
 
 -(void)SVProgressHUD_ShowWithStatus:(NSString *)message;
 -(void)SVProgressHUD_ShowErrorWithStatus:(NSString *)message;
 */

//-(void)showSuccessWithStatus:(NSString *)string {
//
//}

/*
 Custom SVProgressHUD
 refer : http://stackoverflow.com/questions/16932624/change-bg-color-of-svprogesshud-in-objective-c
 */
-(void)SVProgressHUD_ShowWithStatus:(NSString *)message{
    /*
    // [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor yellowColor]];
    [[SVProgressHUD appearance] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:16]];
    [SVProgressHUD showSuccessWithStatus:message];
    */
    /*
    [[SVProgressHUD appearance] setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]];
    //[[SVProgressHUD appearance] setHudForegroundColor:[UIColor yellowColor]];
    [[SVProgressHUD appearance] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:16]];
    // [self showImage:[[self sharedView] hudSuccessImage] status:string];
     */

    
    [SVProgressHUD showWithStatus:message];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

-(void)SVProgressHUD_ShowSuccessWithStatus:(NSString *)message{
    [SVProgressHUD showSuccessWithStatus:message];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)SVProgressHUD_ShowErrorWithStatus:(NSString *)message{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", message]];
    
    // Delay execution of my block for 2 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

-(void)SVProgressHUD_Dismiss{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

/*
 FIRDatabaseReference *ref = [[FIRDatabase database] reference];
 
 NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
 
 __block NSString *child = [NSString stringWithFormat:@"heart-id/user-login/%@/", [preferences objectForKey:_UID], [[Configs sharedInstance] getUniqueDeviceIdentifierAsString]];
 
 [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
 
 NSLog(@"%@", snapshot.value);

}];

 */




@end
