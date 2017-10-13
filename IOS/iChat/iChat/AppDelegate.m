//
//  AppDelegate.m
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import "AppDelegate.h"
#import "MessageRepo.h"


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

        if ([snapshot.key isEqualToString:@"profiles"] || [snapshot.key isEqualToString:@"friends"]) {
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
        }else if([snapshot.key isEqualToString:@"invite_group"]){
            
            NSDictionary *invite_group = snapshot.value;
            
            for (NSString* id_invite_group in invite_group) {
                NSDictionary* value = [invite_group objectForKey:id_invite_group];
                NSString*owner_id = [value objectForKey:@"owner_id"];
                
                
                __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@", owner_id, id_invite_group];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    
                    [childObserver_Friends addObject:[ref child:child]];
                    
                    NSLog(@"%@", snapshot.key);
                    NSLog(@"%@", snapshot.value);
                    NSLog(@"");
                
                    if (![snapshot.value isEqual:[NSNull null]]){
                        NSMutableDictionary *value = snapshot.value;
                        NSMutableDictionary *members = [[value objectForKey:@"members"] mutableCopy];
                        
                        NSMutableDictionary *newMembers = [[NSMutableDictionary alloc] init];
                        for (NSString* key in members) {
                            id _val = [members objectForKey:key];
                            // do stuff
                            
                            if([[_val objectForKey:@"status"] isEqualToString:@"pedding"]){
                                
                            }else{
                                [newMembers setObject:_val forKey:key];
                            }
                        }
                        
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        [newDict addEntriesFromDictionary:value];
                        [newDict removeObjectForKey:@"members"];
                        
                        [newDict setObject:newMembers forKey:@"members"];
                        
                        NSLog(@"");
                        // เป็นการเก้บข้อมูล ชื่อกลุ่ม, image_url ของกลุ่มที่ invite มาเราจะเก็บแบบชั่วคราวเท่านั้น
                        [[Configs sharedInstance] saveData:snapshot.key :snapshot.value];
                    }
                }];
                
                // do stuff
                NSLog(@"");
            }
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
        }else if([snapshot.key isEqualToString:@"groups"]){
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            for (NSString* _id in snapshot.value) {
                NSDictionary* item = [snapshot.value objectForKey:_id];
                
                NSString *chat_id = [item objectForKey:@"chat_id"];
                
                NSString *multi_chat_message = [NSString stringWithFormat:@"toonchat_message/%@/", chat_id];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
            }
        }else if([snapshot.key isEqualToString:@"multi_chat"]){
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
            [newDict removeObjectForKey:snapshot.key];
            
            [newDict setObject:snapshot.value forKey:snapshot.key];
            
            [[Configs sharedInstance] saveData:_DATA :newDict];
            
            for (NSString* _id in snapshot.value) {
                NSDictionary* item = [snapshot.value objectForKey:_id];
                
                NSString *chat_id = [item objectForKey:@"chat_id"];
                
                NSString *multi_chat_message = [NSString stringWithFormat:@"toonchat_message/%@/", chat_id];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
                
                [[ref child:multi_chat_message] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                }];
            }
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
    
    NSMutableDictionary *DATA = [[Configs sharedInstance] loadData:_DATA];
    NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    for (NSString* key in friends) {
        NSDictionary *item = [friends objectForKey:key];
        NSString *child = [NSString stringWithFormat:@"toonchat/%@/", key];
        
        //  กรณี friend_id มีการ change data เช่น online, offline
        [[ref child:child] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            // จะได้ %@ => จาก toonchat/%@/ เราจะรู้เป็น friend_id
            NSString* parent = snapshot.ref.parent.key;
            
            // update profile friend
            [[self friendsProfile] setObject:snapshot.value forKey:parent];
            
            [childObserver_Friends addObject:[ref child:child]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesTableViewController_reloadDataUpdateFriendProfile" object:self userInfo:@{}];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_detectOnline" object:self userInfo:@{}];
        }];
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
//        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
//
//            [childObserver_Friends addObject:[ref child:child_cmessage]];
//        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            /*
             @property (nonatomic, strong) NSString *chat_id;
             @property (nonatomic, strong) NSString *object_id;
             @property (nonatomic, strong) NSString *text;
             @property (nonatomic, strong) NSString *type;
             
             @property (nonatomic, strong) NSString *sender_id;
             @property (nonatomic, strong) NSString *receive_id;
             
             @property (nonatomic, strong) NSString *status;
             @property (nonatomic, strong) NSString *create;
             @property (nonatomic, strong) NSString *update;
             */
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
                
                NSLog(@"");
                /*
                
                */
                
                /*
                 "chat_id" = r1ibtvtq9LJpOzoOkmpy;
                 create = 1506680186063;
                 "object_id" = "-KvC7lffIPOBZ574Y8yQ";
                 "receive_id" = 1028;
                 "sender_id" = 1023;
                 status = send;
                 text = Err;
                 type = private;
                 update = 1506680186063;
                 */
                
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
                /*
                 ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                 */
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
    
    NSMutableDictionary *groups = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"groups"];
    for (NSString* key in groups) {
        NSDictionary *item = [groups objectForKey:key];
        
        NSLog(@"");
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        //        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        //
        //            [childObserver_Friends addObject:[ref child:child_cmessage]];
        //        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            /*
             @property (nonatomic, strong) NSString *chat_id;
             @property (nonatomic, strong) NSString *object_id;
             @property (nonatomic, strong) NSString *text;
             @property (nonatomic, strong) NSString *type;
             
             @property (nonatomic, strong) NSString *sender_id;
             @property (nonatomic, strong) NSString *receive_id;
             
             @property (nonatomic, strong) NSString *status;
             @property (nonatomic, strong) NSString *create;
             @property (nonatomic, strong) NSString *update;
             */
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
                
                NSLog(@"");
                /*
                 
                 */
                
                /*
                 "chat_id" = r1ibtvtq9LJpOzoOkmpy;
                 create = 1506680186063;
                 "object_id" = "-KvC7lffIPOBZ574Y8yQ";
                 "receive_id" = 1028;
                 "sender_id" = 1023;
                 status = send;
                 text = Err;
                 type = private;
                 update = 1506680186063;
                 */
                
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
                /*
                 ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                 */
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
    
    NSMutableDictionary *multi_chat = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"multi_chat"];
    for (NSString* key in multi_chat) {
        NSDictionary *item = [multi_chat objectForKey:key];
        
        NSLog(@"");
        
        // toonchat_message
        NSString *child_cmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [item objectForKey:@"chat_id"]];
        //        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        //
        //            [childObserver_Friends addObject:[ref child:child_cmessage]];
        //        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
        }];
        
        [[ref child:child_cmessage] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
            
            /*
             @property (nonatomic, strong) NSString *chat_id;
             @property (nonatomic, strong) NSString *object_id;
             @property (nonatomic, strong) NSString *text;
             @property (nonatomic, strong) NSString *type;
             
             @property (nonatomic, strong) NSString *sender_id;
             @property (nonatomic, strong) NSString *receive_id;
             
             @property (nonatomic, strong) NSString *status;
             @property (nonatomic, strong) NSString *create;
             @property (nonatomic, strong) NSString *update;
             */
            MessageRepo* meRepo = [[MessageRepo alloc] init];
            if(![meRepo check:snapshot.key]){
                NSDictionary *value = snapshot.value;
                
                NSLog(@"");
                /*
                 
                 */
                
                /*
                 "chat_id" = r1ibtvtq9LJpOzoOkmpy;
                 create = 1506680186063;
                 "object_id" = "-KvC7lffIPOBZ574Y8yQ";
                 "receive_id" = 1028;
                 "sender_id" = 1023;
                 status = send;
                 text = Err;
                 type = private;
                 update = 1506680186063;
                 */
                
                Message* m  = [[Message alloc] init];
                m.chat_id   = snapshot.ref.parent.key;
                m.object_id = snapshot.key;
                
                m.text      = [value objectForKey:@"text"];
                m.type      = [value objectForKey:@"type"];
                m.sender_id = [value objectForKey:@"sender_id"];
                m.receive_id = [value objectForKey:@"receive_id"];
                m.status    = [value objectForKey:@"status"];
                m.create    = [value objectForKey:@"create"];
                m.update    = [value objectForKey:@"update"];
                
                [meRepo insert:m];
                
                NSDictionary* userInfo = @{@"message":m};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatView_reloadData" object:self userInfo:userInfo];
            }
            
            [childObserver_Friends addObject:[ref child:child_cmessage]];
            
            // NSString *_child = [NSString stringWithFormat:@"%@%@/", child_cmessage, snapshot.key];
            [[[ref child:child_cmessage] child:snapshot.key] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"%@, %@, %@",snapshot.ref.parent.key,snapshot.key, snapshot.value);
                
                /*
                 ติดไว้ก่อนเราต้อง removeObaserver ออกด้วยโดยมีเงือ่น ? ตอนนี้ลบออกให้หมดก่อน
                 */
                [childObserver_Friends addObject:[ref child:child_cmessage]];
                
                // [ref removeAllObservers];
                
                // [ref removeObserverWithHandle:snapshot];
            }];
            
        }];
    }
}

@end
