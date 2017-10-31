//
//  ContactsViewController.m
//  iChat
//
//  Created by Somkid on 25/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.

#import "ContactsViewController.h"
#import "ViewControllerCell.h"
#import "ViewControllerCellHeader.h"
#import "ProfileTableViewCell.h"
#import "FriendTableViewCell.h"
#import "GroupTableViewCell.h"
#import "CreateGroup.h"
#include <stdlib.h>
#import "Configs.h"
#import "AppConstant.h"
#import "AnNmousUThread.h"
#import "AppDelegate.h"
#import "UserDataUILongPressGestureRecognizer.h"
#import "UserDataUIAlertView.h"

#import "MyProfile.h"
#import "Changefriendsname.h"
#import "ManageGroup.h"

#define __count 5

@interface ContactsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrSelectedSectionIndex;
    BOOL isMultipleExpansionAllowed;
    NSMutableDictionary *all_data;
}
@end

@implementation ContactsViewController
@synthesize ref;

#pragma mark - View Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];
    all_data = [[NSMutableDictionary alloc] init];
    
    /*
     // 0 : Profile
     // 1 : Groups
     // 2 : Favorites
     // 3 : Friends
    */
    // [all_data setObject:@[@"profile-Red"] forKey:@"profile"];
    // [all_data setObject:@[@"groups-Red", @"groups-Yellow"] forKey:@"groups"];
    // [all_data setObject:@[@"favorites-Red", @"favorites-Yellow"] forKey:@"favorites"];
    // [all_data setObject:@[@"friends-Red", @"friends-Yellow", @"friends-Yellow", @"friends-Yellow"] forKey:@"friends"];
    
    //Set isMultipleExpansionAllowed = true is multiple expanded sections to be allowed at a time. Default is NO.
    isMultipleExpansionAllowed = YES;
    
    arrSelectedSectionIndex = [[NSMutableArray alloc] init];
    
    // if (!isMultipleExpansionAllowed) {
    //    [arrSelectedSectionIndex addObject:[NSNumber numberWithInt:count+2]];
    // }
    
    for (int i=0; i< __count; i++) {
        // เป็นการจะให้ section ได้ open โดยเราจะต้อง add section index
        [arrSelectedSectionIndex addObject:[NSNumber numberWithInt:i]];
    }
    
    [tblView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileTableViewCell"];
    [tblView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    [tblView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupTableViewCell"];

    // NSDictionary *_data =  [[Configs sharedInstance] loadData:_DATA];
    // NSLog(@"");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"MoviesTableViewController_reloadData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"MoviesTableViewController_reloadDataUpdateFriendProfile"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    if (![[Configs sharedInstance] isLogin]){
        
        [tblView setHidden:YES];
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        
        AnNmousUThread * nThread = [[AnNmousUThread alloc] init];
        [nThread setCompletionHandler:^(NSString * data) {
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                NSMutableDictionary *idata  = jsonDict[@"data"];
                
                if (![idata isKindOfClass:[NSDictionary class]]) {
                    [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[NSString stringWithFormat:@"%@", idata]];
                }else{
                    
                    if ([idata count] > 0) {
                        // http://stackoverflow.com/questions/19206762/equivalent-to-shared-preferences-in-ios
                        // NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                        
                        // NSLog(@"%@", [idata objectForKey:@"user"][@"uid"]);
                        
                        // const NSInteger currentLevel = ...;
                        // [preferences setInteger:currentLevel forKey:currentLevelKey];
                        // [preferences setObject:[idata objectForKey:@"user"][@"uid"] forKey:_UID];
                        // [preferences setObject:[idata objectForKey:@"sessid"] forKey:_SESSION_ID];
                        // [preferences setObject:[idata objectForKey:@"session_name"] forKey:_SESSION_NAME];
                        
                        // NSUserDefaults save NSMutableDictionary
                        // http://stackoverflow.com/questions/471830/why-nsuserdefaults-failed-to-save-nsmutabledictionary-in-iphone-sdk
                        // [preferences setObject:[NSKeyedArchiver archivedDataWithRootObject: idata] forKey:_USER];
                        
                        
                        /*
                         เป็นข้อมูลที่ได้จาก server ซื่งเป้นข้อมูล user login
                         */
                        [[Configs sharedInstance] saveData:_USER :idata];
                        //if ([preferences synchronize])
                        // {
                        //                        NSDictionary *dict =  @{@"function" : @"reset"};
                        //
                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageTabBar" object:nil userInfo:dict];
                        //                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        // [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
                        
                        
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(synchronizeData:)
                                                                     name:@"synchronizeData"
                                                                   object:nil];
                        
                        /*
                         เป้นการดึงข้อมูลทั้งหมดของ user ที่อยู่ใน firebase
                         */
                        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait Synchronize data"];
                        [[Configs sharedInstance] synchronizeData];
                        
                    }else{
                        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Login Error"];
                    }
                }
            }else{
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:[jsonDict valueForKey:@"message"]];
            }
        }];
        [nThread setErrorHandler:^(NSString * data) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:data];
        }];
        [nThread start];
    }else{
        NSMutableDictionary *f = [[Configs sharedInstance] loadData:_PROFILE_FRIENDS];
        for (NSString* key in f) {
            [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] setObject:[f objectForKey:key] forKey:key];
        }
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] observeEventType];
        
        [self reloadData:nil];
        
        // [tblView reloadData];
    }
}

// กลับจากการ ดึงข้อมูลของ user
-(void)synchronizeData:(NSNotification *) notification{
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] observeEventType];
    
    [self reloadData:nil];
    // [tblView reloadData];
    
    [tblView setHidden:NO];
}

/*
 Type DATA
 -profiles           : profile ของผู้ใช้งาน
 -favorite friends   : friends ที่เราชื่นชอบ
 -friends            : เพื่อนทั้งหมด
 -groups             : กลุ่ม Chat
 -multi_chat         : คุยแบบไม่สร้างกลุ่ม
 -invite_groups       : กรณีมี เพื่อนเชิญเราเข้ากลุ่มสนทนา
 -invite_multi_chat  : กรณีมี เพื่อนเชิญเราเข้าสนทนา
 
 -recents            :  เก็บข้อมูลล่าสุดที่เราคุย กับเพือน กลุ่ม หรือ multi chat
 
 */
-(void)reloadData:(NSNotification *) notification{
    
    [all_data removeAllObjects];
    
    NSMutableDictionary *data = [[Configs sharedInstance] loadData:_DATA];
    NSMutableDictionary *friends = [data objectForKey:@"friends"];
    
    // #1 profile
    NSMutableDictionary *dic_profile= [[NSMutableDictionary alloc] init];
    [all_data setValue:nil forKey:@"profiles"];
    if ([data objectForKey:@"profiles"]) {
        [all_data setValue:[data objectForKey:@"profiles"]  forKey:@"profiles"];
    }
    // #1 profile
    
    // #2 favorite
    NSMutableDictionary *favorites = [[NSMutableDictionary alloc] init];
    for (NSString* key in friends) {
        NSMutableDictionary* value = [friends objectForKey:key];
        if ([value objectForKey:@"favorite"]) {
            NSString* is_favorite = [value objectForKey:@"favorite"];
            if ([is_favorite isEqualToString:@"1"]) {
                [favorites setObject:value forKey:key];
            }
        }
    }
    [all_data setValue:favorites forKey:@"favorite"];
    // #2 favorite
    
    // #3 friends
    /*
     NSMutableArray *_f = [[NSMutableArray alloc] init];
     for (NSString* key in friends) {
     
     NSMutableDictionary *item =[friends objectForKey:key];
     [item setObject:key forKey:@"friend_id"];
     [item setObject:@"friend" forKey:@"type"];
     
     [_f addObject:item];
     }
     
     [data setValue:_f forKey:@"friends"];
     */
    
    [all_data setValue:friends forKey:@"friends"];
    // #3 friends
    
    // #4 groups
    NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
    [all_data setValue:groups forKey:@"groups"];
    if ([data objectForKey:@"groups"]) {
        [all_data setValue:[data objectForKey:@"groups"] forKey:@"groups"];
    }
    
    // #4 groups
    
    // #5 multi_chat
    /*
    NSMutableDictionary *multi_chat = [[NSMutableDictionary alloc] init];
    [all_data setValue:multi_chat forKey:@"multi_chat"];
    if ([data objectForKey:@"multi_chat"]) {
        [all_data setValue:[data objectForKey:@"multi_chat"] forKey:@"multi_chat"];
    }
    */
    
    // #5 multi_chat
    
    // #6 invite_group
    /*
    NSMutableDictionary *invite_group = [[NSMutableDictionary alloc] init];
    [all_data setValue:invite_group forKey:@"invite_group"];
    if ([data objectForKey:@"invite_group"]) {
        [all_data setValue:[data objectForKey:@"invite_group"] forKey:@"invite_group"];
    }
    */
    
    // #6 invite_group
    
    // #7 invite_multi_chat
    /*
    NSMutableDictionary *invite_multi_chat = [[NSMutableDictionary alloc] init];
    [all_data setValue:invite_multi_chat forKey:@"invite_multi_chat"];
    if ([data objectForKey:@"invite_multi_chat"]) {
        [all_data setValue:[data objectForKey:@"invite_multi_chat"] forKey:@"invite_multi_chat"];
    }
    */
    
    // #7 invite_multi_chat
    
    
    //    if (notification != nil) {
    //        if ([notification.name isEqualToString:@"MoviesTableViewController_reloadDataUpdateFriendProfile"]) {
    //
    //        }
    //    }else{
    //        [(AppDelegate *)[[UIApplication sharedApplication] delegate] observeEventType];
    //    }
    
    // [tblView reloadData];
    
    /*
     Updating data for UITableView in background breaks animations
     https://stackoverflow.com/questions/10831313/updating-data-for-uitableview-in-background-breaks-animations
     */
    [tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - TableView methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return all_data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
        /* กรณีที่เรา click open section แล้วจะ return จำนวน item */
        switch (section) {
                // profile
            case 0:{
                return 1;
            }
                // groups
            case 1:{
                NSMutableArray *groups = [all_data valueForKey:@"groups"];
                return  [groups count];
                
            }
                // favorites
            case 2:{
                NSMutableArray *favorite = [all_data valueForKey:@"favorite"];
                return  [favorite count];
            }
                // friends
            case 3:{
                NSMutableArray *friends = [all_data valueForKey:@"friends"];
                return  [friends count];
            }
                default:
                return 0;
        }
    }else{
        /* กรณีที่เรา click close section แล้วจะ return 0 */
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
//    if (cell ==nil){
//        [tblView registerClass:[ViewControllerCell class] forCellReuseIdentifier:@"ViewControllerCell"];
//        cell = [tblView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
//    }
//
//    switch (indexPath.section) {
//        case 0:{
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//            break;
//
//        default:{
//            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        }
//            break;
//    }
//
//    cell.lblName.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
//    cell.backgroundColor = indexPath.row%2==0?[UIColor lightTextColor]:[[UIColor lightTextColor] colorWithAlphaComponent:0.5f];
//    return cell;
    
    // NSDictionary *data = [[Configs sharedInstance] loadData:_DATA];
    if (indexPath.section == 0) {
        
        ProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *profiles = [all_data objectForKey:@"profiles"];
        if ([profiles objectForKey:@"image_url"]) {
            [cell.imgPerson clear];
            [cell.imgPerson showLoadingWheel];
            [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
        }else{}
        
        cell.lblName.text = [profiles objectForKey:@"name"];
        
        if ([profiles objectForKey:@"status_message"]) {
            cell.lblStatusmessage.text = [profiles objectForKey:@"status_message"];
        }else{
            cell.lblStatusmessage.text = @"";
        }
        
        UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
        
        
        lpgr.userData = indexPath;
        // lpgr.minimumPressDuration = 1.0; //seconds
        [cell addGestureRecognizer:lpgr];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return cell;
    }else{
        
        /*
        FriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
        */
        FriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        // if (!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        // }
        
        switch (indexPath.section) {
            case 1:{
                // @"Groups";
                // GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
                
                
                NSMutableDictionary *groups = [all_data objectForKey:@"groups"];
                
                NSArray *keys = [groups allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [groups objectForKey:key];
                
                
                // imgPerson
                
                // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
                if ([item objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [item objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"name"], key] ;
                // cell.lblMember.text = [NSString stringWithFormat:@"%@", [(NSDictionary *)[item objectForKey:@"members"] count] ] ;
                NSDictionary * member= [item objectForKey:@"members"];
                
                cell.lblChangeFriendsName.text = [NSString stringWithFormat:@"%d people", [member count] ] ;
                cell.lblType.text = @"";
                cell.lblIsFavorites.text = @"";
                cell.lblIsHide.text = @"";
                cell.lblIsBlock.text = @"";
                cell.lblOnline.text = @"";
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                
                // return cell;
                break;
            }
            case 2:{
                // @"Favorite"
                NSMutableDictionary *favorite = [all_data objectForKey:@"favorite"];
                
                // NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:[item objectForKey:@"friend_id"]];
                NSArray *keys = [favorite allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [favorite objectForKey:key];
                
                
                NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], key] ;
                
                cell.lblChangeFriendsName.text = @"";
                if ([item objectForKey:@"change_friends_name"]) {
                    cell.lblChangeFriendsName.text = [item objectForKey:@"change_friends_name"];
                }
                
                cell.lblType.text = [item objectForKey:@"type"];
                
                cell.lblIsFavorites.text = @"NO";
                if ([item objectForKey:@"favorite"]) {
                    
                    if ([[item objectForKey:@"favorite"] isEqualToString:@"1"]) {
                        cell.lblIsFavorites.text = @"YES";
                    }
                }
                
                cell.lblIsHide.text = @"NO";
                if ([item objectForKey:@"hide"]) {
                    
                    if ([[item objectForKey:@"hide"] isEqualToString:@"1"]) {
                        cell.lblIsHide.text = @"YES";
                    }
                }
                
                cell.lblIsBlock.text = @"NO";
                if ([item objectForKey:@"block"]) {
                    if ([[item objectForKey:@"block"] isEqualToString:@"1"]) {
                        cell.lblIsBlock.text = @"YES";
                    }
                }
                
                cell.lblOnline.text = @"NO";
                if([f objectForKey:@"online"]){
                    if ([[f objectForKey:@"online"] isEqualToString:@"1"]) {
                        cell.lblOnline.text = @"YES";
                    }
                }
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                break;
            }
            case 3:{
                
                // @"Friends";
                NSMutableDictionary *friends = [all_data objectForKey:@"friends"];
                
                NSArray *keys = [friends allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [friends objectForKey:key];
                
                NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
                
                if ([f objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], key] ;
                
                cell.lblChangeFriendsName.text = @"";
                if ([item objectForKey:@"change_friends_name"]) {
                    cell.lblChangeFriendsName.text = [item objectForKey:@"change_friends_name"];
                }
                
                cell.lblType.text = [item objectForKey:@"type"];
                
                cell.lblIsFavorites.text = @"NO";
                if ([item objectForKey:@"favorite"]) {
                    
                    if ([[item objectForKey:@"favorite"] isEqualToString:@"1"]) {
                        cell.lblIsFavorites.text = @"YES";
                    }
                }
                
                cell.lblIsHide.text = @"NO";
                if ([item objectForKey:@"hide"]) {
                    
                    if ([[item objectForKey:@"hide"] isEqualToString:@"1"]) {
                        cell.lblIsHide.text = @"YES";
                    }
                }
                
                cell.lblIsBlock.text = @"NO";
                if ([item objectForKey:@"block"]) {
                    if ([[item objectForKey:@"block"] isEqualToString:@"1"]) {
                        cell.lblIsBlock.text = @"YES";
                    }
                }
                
                // cell.lblOnline.text = @"NO";
                cell.lblOnline.text = @"NO";
                if([f objectForKey:@"online"]){
                    if ([[f objectForKey:@"online"] isEqualToString:@"1"]) {
                        cell.lblOnline.text = @"YES";
                    }
                }
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                break;
            }
                /*
            case 3:{
                // @"Groups";
                // GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
                
                
                NSMutableDictionary *groups = [data objectForKey:@"groups"];
                
                NSArray *keys = [groups allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [groups objectForKey:key];
                
                
                // imgPerson
                
                // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
                if ([item objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [item objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"name"], key] ;
                // cell.lblMember.text = [NSString stringWithFormat:@"%@", [(NSDictionary *)[item objectForKey:@"members"] count] ] ;
                NSDictionary * member= [item objectForKey:@"members"];
                
                cell.lblChangeFriendsName.text = [NSString stringWithFormat:@"%d people", [member count] ] ;
                cell.lblType.text = @"";
                cell.lblIsFavorites.text = @"";
                cell.lblIsHide.text = @"";
                cell.lblIsBlock.text = @"";
                cell.lblOnline.text = @"";
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                
                // return cell;
                break;
            }
            case 4:{
                // @"Multi Chat";
                NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
                
                NSArray *keys = [multi_chat allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [multi_chat objectForKey:key];
                
                if ([item objectForKey:@"image_url"]) {
                    [cell.imgPerson clear];
                    [cell.imgPerson showLoadingWheel]; // API_URL
                    [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [item objectForKey:@"image_url"]]]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                }else{
                    [cell.imgPerson clear];
                }
                
                cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"chat_id"], key] ;
                // cell.lblMember.text = [NSString stringWithFormat:@"%@", [(NSDictionary *)[item objectForKey:@"members"] count] ] ;
                NSDictionary * member= [item objectForKey:@"members"];
                
                cell.lblChangeFriendsName.text = [NSString stringWithFormat:@"%d people", [member count] ] ;
                cell.lblType.text = @"";
                cell.lblIsFavorites.text = @"";
                cell.lblIsHide.text = @"";
                cell.lblIsBlock.text = @"";
                cell.lblOnline.text = @"";
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                
                break;
            }
            case 5:{
                
                // @"Invite Group";
                NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
                
                NSArray *keys = [invite_group allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                //                id item = [invite_group objectForKey:key];
                
                
                id item = [[Configs sharedInstance] loadData:key];
                
                if (item != [NSNull null]) {
                    
                    if ([item objectForKey:@"image_url"]) {
                        [cell.imgPerson clear];
                        [cell.imgPerson showLoadingWheel]; // API_URL
                        [cell.imgPerson setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [item objectForKey:@"image_url"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imgPerson ];
                    }else{
                        [cell.imgPerson clear];
                    }
                    
                    cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"name"], key] ;
                    
                    NSDictionary * member= [item objectForKey:@"members"];
                    
                    cell.lblChangeFriendsName.text = [NSString stringWithFormat:@"%d people", [member count] ] ;
                    cell.lblType.text = @"";
                    cell.lblIsFavorites.text = @"";
                    cell.lblIsHide.text = @"";
                    cell.lblIsBlock.text = @"";
                    cell.lblOnline.text = @"";
                    
                    // UserDataUILongPressGestureRecognizer
                    UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                    // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                    
                    lpgr.userData = indexPath;
                    // lpgr.minimumPressDuration = 1.0; //seconds
                    [cell addGestureRecognizer:lpgr];
                    
                    NSLog(@"");
                }
                
                break;
            }
                */
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44.0f;
    }else if(section == 1){
        NSMutableArray *groups = [all_data valueForKey:@"groups"];
        if([groups count] == 0){
            return 0;
        }
    }else if(section == 2){
        NSMutableArray *favorite = [all_data valueForKey:@"favorite"];
        if([favorite count] == 0){
            return 0;
        }
    }else if(section == 3){
        NSMutableArray *friends = [all_data valueForKey:@"friends"];
        if([friends count] == 0){
            return 0;
        }
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 100.0f;
        default:
            return 180.0f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ViewControllerCellHeader *headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
    if (headerView ==nil){
        [tblView registerClass:[ViewControllerCellHeader class] forCellReuseIdentifier:@"ViewControllerCellHeader"];
        headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
    }
    
    switch (section) {
            // 0 : Profile
        case 0:{
            headerView.lbTitle.text = @"Profile";
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
            
            [[headerView btnShowHide] setHidden:YES];
            
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
        }
            break;
            
            // 1 : Groups
            // 2 : Favorites
            // 3 : Friends
        case 1:{
            
            NSMutableArray *groups = [all_data valueForKey:@"groups"];
            
            headerView.lbTitle.text = [NSString stringWithFormat:@"Groups %ld", [groups count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
        }
            break;
        case 2:{
            
            NSMutableArray *favorite = [all_data valueForKey:@"favorite"];
            headerView.lbTitle.text = [NSString stringWithFormat:@"Favorites %ld", [favorite count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
        }
            break;
            
        case 3:{
            NSMutableArray *friends = [all_data valueForKey:@"friends"];
            headerView.lbTitle.text = [NSString stringWithFormat:@"Friends %ld", [friends count]];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
        }
            break;
        default:{
            headerView.lbTitle.text = [NSString stringWithFormat:@"Section %ld", (long)section];
            if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]]){
                headerView.btnShowHide.selected = YES;
            }
            [[headerView btnShowHide] setTag:section];
            [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
        }
            break;
    }
    return headerView.contentView;
}

-(IBAction)btnTapShowHideSection:(UIButton*)sender{
    if (!sender.selected){
        if (!isMultipleExpansionAllowed) {
            [arrSelectedSectionIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:sender.tag]];
        }else {
            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        sender.selected = YES;
    }else{
        sender.selected = NO;
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
        {
            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
    }
    if (!isMultipleExpansionAllowed) {
        [tblView reloadData];
    }else {
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnBlock = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Block");
    }];
    btnBlock.backgroundColor = [UIColor redColor];
    UITableViewRowAction *btnHide = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Hide" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Hide");
    }];
    btnHide.backgroundColor = [UIColor grayColor];
    return @[btnBlock, btnHide];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return NO;
        }
        default:
            return YES;
    }
}

-(void)handleLongPress:(UserDataUILongPressGestureRecognizer *)longPress{
    
    NSIndexPath * section = longPress.userData;
    
    if (section.section == 0) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded = %d", section.section);
        
        UserDataUIAlertView *alert =nil;
        switch (section.section) {
            case 1:{
                // Group
                //Do Whatever You want on End of Gesture
                alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Manage group", @"Delete Group", nil];
                
                alert.userData = section;
                alert.tag = 2;
                [alert show];
                break;
            }
            case 2:
            case 3:{
                
                // Favorite & Friends
                
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (section.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                NSArray *keys = [idata allKeys];
                id key = [keys objectAtIndex:section.row];
                NSDictionary* item = [idata objectForKey:key];
                
                NSString*isFav = @"0";
                if ([item objectForKey:@"favorite"]) {
                    isFav = [item valueForKey:@"favorite"];
                }
                // [2]    (null)    @"favorite" : @"1"
                
                //Do Whatever You want on End of Gesture
                alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:[NSString stringWithFormat:@"Favorite : %@", isFav], @"Change friend's name", @"Hide", @"Block", nil];
                
                alert.userData = section;
                alert.tag = 1;
                [alert show];
                
                break;
            }
                
            case 4:{
                // Multi Chat
                NSLog(@"");
                
                alert = [[UserDataUIAlertView alloc] initWithTitle:@"Multi Chat"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Manage Multi Chat", @"Delete Multi Chat", nil];
                
                alert.userData = section;
                alert.tag = 4;
                [alert show];
            }
                break;
                
            case 5:{
                // Invite Group
                alert = [[UserDataUIAlertView alloc] initWithTitle:@"Invite Group"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Reject", @"Join", nil];
                
                alert.userData = section;
                alert.tag = 5;
                [alert show];
                NSLog(@"");
            }
                break;
            case 6:{
                // @"Invite Multi Chat";
                alert = [[UserDataUIAlertView alloc] initWithTitle:@"Invite Multi Chat"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Close"
                                                 otherButtonTitles:@"Reject", @"Join", nil];
                
                alert.userData = section;
                alert.tag = 6;
                [alert show];
                NSLog(@"");
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section == 0) {
        MyProfile* profile = [storybrd instantiateViewControllerWithIdentifier:@"MyProfile"];
        [self.navigationController pushViewController:profile animated:YES];
    }
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                // Favorite
                
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 2:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 3:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                
                // NSMutableDictionary *item = [friends objectAtIndex:indexPath.row];
                
                NSArray *keys = [idata allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [idata objectForKey:key];
                
                NSLog(@"Hide : section = %ld, row = %ld, friend id : %@", (long)indexPath.section, (long)indexPath.row, key);
                
                __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/friends/%@/", [[Configs sharedInstance] getUIDU], key];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"favorite"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                            }
                            
                            flag = false;
                            
                            break;
                        }
                    }
                    
                    /*
                     กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                     */
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/favorite/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                    }
                }];
            }
                break;
                
            case 2:{
                // Change friend's name
                
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 1:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                NSArray *keys = [idata allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [idata objectForKey:key];
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                Changefriendsname *changeFN = [storybrd instantiateViewControllerWithIdentifier:@"Changefriendsname"];
                
                changeFN.friend_id = key;//[item objectForKey:@"friend_id"];
                [self.navigationController pushViewController:changeFN animated:YES];
            }
                break;
                
            case 3:{
                // Hide
                
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 1:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                NSArray *keys = [idata allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [idata objectForKey:key];
                
                NSLog(@"Hide : section = %ld, row = %ld, friend id : %@", (long)indexPath.section, (long)indexPath.row, key);
                
                __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/friends/%@/", [[Configs sharedInstance] getUIDU], key];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"hide"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                            }
                            
                            flag = false;
                            
                            break;
                        }
                    }
                    
                    /*
                     กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                     */
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/hide/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                    }
                }];
                
            }
                break;
                
            case 4:{
                // Block
                
                NSMutableDictionary *idata = [[NSMutableDictionary alloc] init];
                switch (indexPath.section) {
                    case 1:
                        idata = [all_data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [all_data valueForKey:@"friends"];
                        break;
                        
                    default:
                        break;
                }
                
                NSArray *keys = [idata allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [idata objectForKey:key];
                
                NSLog(@"Block : section = %ld, row = %ld, friend id : %@", (long)indexPath.section, (long)indexPath.row, key);
                
                __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/friends/%@/", [[Configs sharedInstance] getUIDU], key];
                
                [[ref child:child] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    // NSLog(@"%@", snapshot.key);
                    // NSLog(@"%@", snapshot.children);
                    // NSLog(@"%@", snapshot.value);
                    BOOL flag = true;
                    for(FIRDataSnapshot* snap in snapshot.children){
                        // NSLog(@">%@", snapshot.key);
                        // NSLog(@">%@", snap.key);
                        // NSLog(@">%@", snap.value);
                        if ([snap.key isEqualToString:@"block"]) {
                            
                            if ([snap.value isEqualToString:@"1"]) {
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"0"};
                                [ref updateChildValues:childUpdates];
                            }else{
                                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", child, snap.key]: @"1"};
                                [ref updateChildValues:childUpdates];
                            }
                            
                            flag = false;
                            
                            break;
                        }
                    }
                    
                    /*
                     กรณีไม่มี key online  ใน firebase จะเกิดกรณี user version เก่า
                     */
                    if (flag) {
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/block/", child]: @"1"};
                        [ref updateChildValues:childUpdates];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    }else if (alertView.tag == 2) {
        
        NSIndexPath * indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                
                NSMutableDictionary *group = [all_data valueForKey:@"groups"];
                
                NSArray *keys = [group allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                NSMutableDictionary*  item = [group objectForKey:key];
                [item setValue:key forKey:@"group_id"];
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ManageGroup *manageGroup = [storybrd instantiateViewControllerWithIdentifier:@"ManageGroup"];
                manageGroup.group =item;//[friends objectAtIndex:indexPath.row];
                
                [self.navigationController pushViewController:manageGroup animated:YES];
            }
                break;
            case 2:{
                
                NSMutableDictionary *friends = [all_data valueForKey:@"groups"];
                
                NSArray *keys = [friends allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                NSMutableDictionary*  item = [friends objectForKey:key];
                [item setValue:key forKey:@"group_id"];
                
                UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"Delete group"
                                                                                message:@"Are you sure delete group?"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Close"
                                                                      otherButtonTitles:@"Delete", nil];
                
                alert.userData = item;
                alert.tag = 3;
                [alert show];
            }
                break;
        }
    }else if(alertView.tag == 3){
        NSMutableDictionary *item = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/", [[Configs sharedInstance] getUIDU], [item objectForKey:@"group_id"]];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // [ref parent]
                        //NSString* parent = ref.parent.key;
                        
                        // จะได้ Group id
                        NSString* key = [ref key];
                        
                        NSLog(@"");
                    }
                }];
            }
                break;
        }
    }else if(alertView.tag == 4){
        // Multi Chat
        NSIndexPath *indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                // Manage Multi Chat
                
                /*
                NSMutableDictionary *groups = [data valueForKey:@"multi_chat"];
                
                NSArray *keys = [groups allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                NSMutableDictionary*  item = [groups objectForKey:key];
                [item setValue:key forKey:@"multi_chat_id"];
                
                // ChatView2 *chatView2 = [storybrd instantiateViewControllerWithIdentifier:@"ChatView2"];
                // chatView2.friend =item;//[friends objectAtIndex:indexPath.row];
                // chatView2.typeChat =@"4";
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ManageMultiChat *manageMultiChat = [storybrd instantiateViewControllerWithIdentifier:@"ManageMultiChat"];
                manageMultiChat.friend =item;
                manageMultiChat.typeChat =@"4";
                
                [self.navigationController pushViewController:manageMultiChat animated:YES];
                */
            }
                break;
            case 2:{
                
                /*
                NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
                NSArray *keys = [multi_chat allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [multi_chat objectForKey:key];
                
                NSLog(@"Delete Multi Chat");
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/multi_chat/%@/", [[Configs sharedInstance] getUIDU], key];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // [ref parent]
                        //NSString* parent = ref.parent.key;
                        
                        // จะได้ Group id
                        NSString* key = [ref key];
                        
                        NSLog(@"");
                    }
                }];
                */
            }
                break;
        }
    }else if(alertView.tag == 5){
        // Invite Group
        
        // @"Reject", @"Join"
        NSLog(@"");
        
        NSIndexPath *indexPath = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                NSLog(@"Reject");
                //                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/", [[Configs sharedInstance] getUIDU], [item objectForKey:@"group_id"]];
                //                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                //
                //                    if (error == nil) {
                //                        // [ref parent]
                //                        //NSString* parent = ref.parent.key;
                //
                //                        // จะได้ Group id
                //                        NSString* key = [ref key];
                //
                //                        NSLog(@"");
                //                    }
                //                }];
            }
                break;
            case 2:{
                NSLog(@"Join");
                
                /*
                 step การ Join
                 1. ต้องดึงรายละเอียดของกลุ่มมาก่อนเพือนำไปส้รางเป็นกลุ่มของตัวเองโดย owner_id ={ผู้สร้าง}
                 2. เอาข้อมูลที่ได้จากข้อ 1 ไปสร้างเป้น group
                 
                 3. วิ่งไป update toonchat/{owner_id}/group/{group_id}/members/{nod_id}/{status='access'}
                 4. ลบ invite_group by group_id ออก
                 */
                
                /*
                NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
                
                NSArray *keys = [invite_group allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id _item = [invite_group objectForKey:key];
                
                id item = [[Configs sharedInstance] loadData:key];
                
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@", [[Configs sharedInstance] getUIDU] , key];
                
                // #1, #2
                //                [[ref child:child] setValue:item withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                //                    NSLog(@"");
                //                    if (error == nil) {
                //
                //                    }
                //                }];
                [[ref  child:child] setValue:item];
                
                // #3
                __block NSString *iv_child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/members/%@/", [item objectForKey:@"owner_id"] , key, [_item objectForKey:@"node_id"]];
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/%@/", iv_child, @"status"]: @"access"};
                // [ref updateChildValues:childUpdates];
                
                [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error == nil) {
                        NSString *rm_child = [NSString stringWithFormat:@"toonchat/%@/invite_group/%@/", [[Configs sharedInstance] getUIDU] , key];
                        [[ref child:rm_child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                            NSLog(@"");
                        }];
                    }
                }];
                */
                
                // #4
                
                NSLog(@"");
            }
                break;
        }
    }else if(alertView.tag == 6){
        // @"Invite Multi Chat";
        
        // @"Reject", @"Join"
        NSLog(@"");
        
        NSMutableDictionary *item = alertView.userData;
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
            case 1:{
                NSLog(@"Reject");
                //                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/", [[Configs sharedInstance] getUIDU], [item objectForKey:@"group_id"]];
                //                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                //
                //                    if (error == nil) {
                //                        // [ref parent]
                //                        //NSString* parent = ref.parent.key;
                //
                //                        // จะได้ Group id
                //                        NSString* key = [ref key];
                //
                //                        NSLog(@"");
                //                    }
                //                }];
            }
                break;
            case 2:{
                NSLog(@"Join");
            }
                break;
        }
    }
}

- (IBAction)onRefresh:(id)sender {
    [self reloadData:nil];
}

- (IBAction)onCreateGroup:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateGroup* createGroup = [storybrd instantiateViewControllerWithIdentifier:@"CreateGroup"];
    [self.navigationController pushViewController:createGroup animated:YES];
}
@end
