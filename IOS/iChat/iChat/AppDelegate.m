//
//  AppDelegate.m
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import "AppDelegate.h"


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

//@import Firebase;
//@import FirebaseMessaging;

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate , FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@interface AppDelegate (){
    NSMutableArray *childObservers, *childObserver_Friends;
}

@end

@implementation AppDelegate
@synthesize ref, friendsProfile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // Cache
    NSString *documentdictionary;
    NSArray *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdictionary = [Path objectAtIndex:0];
    documentdictionary = [documentdictionary stringByAppendingPathComponent:@"D8_cache/"];
    self.obj_Manager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:500];
    
    HJMOFileCache *fileCache = [[HJMOFileCache alloc] initWithRootPath:documentdictionary];
    self.obj_Manager.fileCache=fileCache;
    
    fileCache.fileCountLimit=10000;
    fileCache.fileAgeLimit=60*60*24*7;
    [fileCache trimCacheUsingBackgroundThread];
    // Cache
    
    
    // Firebase
    // Firebase Config
    // [FIRApp configure];
    
    
    // [FIRApp configure];
    
    
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            
            // [[FIRMessaging messaging] setRemoteMessageDelegate:self];
            
            //[FIRMessaging messaging].delegate = self;
            
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    [FIRApp configure];
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    ref = [[FIRDatabase database] reference];
    // Firebase Config
    // Firebase
    
    
    // Observers
    childObservers = [[NSMutableArray alloc] init];
    
    
    // สร้าง friendsProfile
    friendsProfile = [[NSMutableDictionary alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if([[Configs sharedInstance] isLogin]){
        __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/profiles/", [[Configs sharedInstance] getUIDU]];
        
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            
            BOOL flag = true;
            for(FIRDataSnapshot* snap in snapshot.children){
                if ([snap.key isEqualToString:@"online"]) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                    [ref updateChildValues:childUpdates];
                    
                    flag = false;
                    break;
                }
            }
            
            /*
             กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
             */
            if (flag) {
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/online/", child]: @"0"};
                [ref updateChildValues:childUpdates];
            }
        }];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/*
 App ถูกเปิด
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFcm];
    
    if([[Configs sharedInstance] isLogin]){
        __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/profiles/", [[Configs sharedInstance] getUIDU]];
        
        [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            FIRDatabaseReference *childRef = [ref child:child];
            [childObservers addObject:childRef];
            
            // NSLog(@"%@", snapshot.key);
            // NSLog(@"%@", snapshot.children);
            // NSLog(@"%@", snapshot.value);
            BOOL flag = true;
            for(FIRDataSnapshot* snap in snapshot.children){
                // NSLog(@">%@", snapshot.key);
                // NSLog(@">%@", snap.key);
                // NSLog(@">%@", snap.value);
                if ([snap.key isEqualToString:@"online"]) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                    [ref updateChildValues:childUpdates];
                    
                    flag = false;

                    break;
                }
            }
            
            /*
             กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
             */
            if (flag) {
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/online/", child]: @"1"};
                [ref updateChildValues:childUpdates];
            }
        }];
    }
}

/*
 App โดน quit ออกจาก Task
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    for (FIRDatabaseReference *ref in childObservers) {
        [ref removeAllObservers];
    }
}

// Firebase
// [START receive_message]
// To receive notifications for iOS 9 and below.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    //    NSDictionary *response = [[NSDictionary alloc] initWithObjectsAndKeys:@"test1", @"title", @"test1", @"body", nil];
    //    DebugLog(@"message id to respond?: %@, response: %@", userInfo[@"message_id"], response);
    //    [self connectToFcm];
    //
    //    [[FIRMessaging messaging] sendMessage:response to:@"----@gcm.googleapis.com." withMessageID:userInfo[@"message_id"]  timeToLive: 108];
}
// [END receive_message]


// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    if (refreshedToken != nil) {
        if ([[Configs sharedInstance] isLogin]) {
            
//            TokenThread *tokenThread = [[TokenThread alloc] init];
//            [tokenThread setCompletionHandler:^(NSString *data) {
//                NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
//                
//                if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                }else{
//                }
//            }];
//            
//            [tokenThread setErrorHandler:^(NSString *error) {
//            }];
//            [tokenThread start:refreshedToken];
            
            __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/profiles/", [[Configs sharedInstance] getUIDU]];
            
            [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                FIRDatabaseReference *childRef = [ref child:child];
                [childObservers addObject:childRef];
                
                // NSLog(@"%@", snapshot.key);
                // NSLog(@"%@", snapshot.children);
                // NSLog(@"%@", snapshot.value);
                BOOL flag = true;
                for(FIRDataSnapshot* snap in snapshot.children){
                    // NSLog(@">%@", snapshot.key);
                    // NSLog(@">%@", snap.key);
                    // NSLog(@">%@", snap.value);
                    if ([snap.key isEqualToString:@"token"]) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: refreshedToken};
                        [ref updateChildValues:childUpdates];
                        
                        flag = false;
                        
                        break;
                    }
                }
                
                /*
                 กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                 */
                if (flag) {
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/token/", child]: refreshedToken};
                    [ref updateChildValues:childUpdates];
                }
            }];
        }
    }
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)observeEventType /* : (NSArray *)values*/{
    
    if (childObserver_Friends != nil) {
        for (FIRDatabaseReference *ref in childObserver_Friends) {
            [ref removeAllObservers];
        }
    }
    
    // Observers
    childObserver_Friends = [[NSMutableArray alloc] init];
    
    
    NSString *child = [NSString stringWithFormat:@"toonchat/%@/", [[Configs sharedInstance] getUIDU]];
    /*
     กรณี friend_id มีการ change data เช่น online, offline
     */
    [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@, %@", snapshot.key, snapshot.value);
//        NSLog(@"");
        /*
         จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
         */
//        NSString* parent = snapshot.ref.parent.key;
//        
//        // update profile friend
//        [[self friendsProfile] setObject:snapshot.value forKey:parent];
//        
//        [childObserver_Friends addObject:[ref child:child]];

        if ([snapshot.key isEqualToString:@"profiles"] || [snapshot.key isEqualToString:@"friends"] || [snapshot.key isEqualToString:@"groups"] || [snapshot.key isEqualToString:@"multi_chat"] || [snapshot.key isEqualToString:@"invite_multi_chat"] || [snapshot.key isEqualToString:@"invite_group"]) {
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesTableViewController_reloadData" object:self userInfo:@{}];
    }];
    
    /*
     เป็นการ add observeEvent ให้กับเพือนทุกคน แล้วถ้ามีการ change data เช่น online, offline
     */
    /*
    for (NSMutableDictionary *item in values) {
        NSLog(@"friend id :%@", [item objectForKey:@"friend_id"]);
        
        NSString *child = [NSString stringWithFormat:@"toonchat/%@/", [item objectForKey:@"friend_id"]];
        
        //  กรณี friend_id มีการ change data เช่น online, offline
        [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
            NSString* parent = snapshot.ref.parent.key;
            
            // update profile friend
            [[self friendsProfile] setObject:snapshot.value forKey:parent];
            
            [childObserver_Friends addObject:[ref child:child]];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesTableViewController_reloadData" object:self userInfo:@{}];
        }];
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
        }];
        
    }
    */
    
    NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    for (NSString* key in friends) {
        NSDictionary *item = [friends objectForKey:key];
        NSString *child = [NSString stringWithFormat:@"toonchat/%@/", key];
        
        //  กรณี friend_id มีการ change data เช่น online, offline
        [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
            NSString* parent = snapshot.ref.parent.key;
            
            // update profile friend
            [[self friendsProfile] setObject:snapshot.value forKey:parent];
            
            [childObserver_Friends addObject:[ref child:child]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesTableViewController_reloadData" object:self userInfo:@{}];
        }];
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@", snapshot.key, snapshot.value);
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
        }];
    }
}

@end
