//
//  MoviesTableViewController.m
//  CustomizingTableViewCell


#import "MoviesTableViewController.h"
#import "MoviesTableViewCell.h"
#import "Movie.h"
#import "ChatView.h"
#import "Changefriendsname.h"
#import "MyProfile.h"
#import "UserDataUILongPressGestureRecognizer.h"
#import "AnNmousUThread.h"
#import "Configs.h"
#import "UserDataUIAlertView.h"
#import "AppDelegate.h"
#import "ProfileTableViewCell.h"
#import "FriendTableViewCell.h"

@interface MoviesTableViewController (){
    NSMutableDictionary *data;
}
@property (nonatomic,strong) NSMutableDictionary *all_data;
@end

@implementation MoviesTableViewController
// @synthesize marrMovies;

@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Contacts-%@", [[Configs sharedInstance] getUIDU]];
    
    ref = [[FIRDatabase database] reference];
    
    
    
    data = [[NSMutableDictionary alloc] init];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"MoviesTableViewController_reloadData"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    if (![[Configs sharedInstance] isLogin]){
        
        [self.tableView setHidden:YES];
        
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
        
        [self reloadData:nil];
    }
}

// กลับจากการ ดึงข้อมูลของ user
-(void)synchronizeData:(NSNotification *) notification{
    [[Configs sharedInstance] SVProgressHUD_Dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"synchronizeData" object:nil];
    
    [self reloadData:nil];
    
    [self.tableView setHidden:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
    NSMutableDictionary *all_data = [[Configs sharedInstance] loadData:_DATA];
    NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    
    // #1 profile
    [data setValue:nil forKey:@"profile"];
    if ([all_data objectForKey:@"profiles"]) {
        [data setValue:[all_data objectForKey:@"profiles"] forKey:@"profile"];
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
    [data setValue:favorites forKey:@"favorite"];
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
    
    [data setValue:friends forKey:@"friends"];
    // #3 friends
    
    // #4 groups
    NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
    if ([all_data objectForKey:@"groups"]) {
        [data setValue:[all_data objectForKey:@"groups"] forKey:@"groups"];
    }
    [data setValue:groups forKey:@"groups"];
    // #4 groups
    
    // #5 multi_chat
    NSMutableDictionary *multi_chat = [[NSMutableDictionary alloc] init];
    if ([all_data objectForKey:@"multi_chat"]) {
        [data setValue:[all_data objectForKey:@"multi_chat"] forKey:@"multi_chat"];
    }
    [data setValue:multi_chat forKey:@"multi_chat"];
    // #5 multi_chat
    
    // #6 invite_group
    NSMutableDictionary *invite_group = [[NSMutableDictionary alloc] init];
    if ([all_data objectForKey:@"invite_group"]) {
        [data setValue:[all_data objectForKey:@"invite_group"] forKey:@"invite_group"];
    }
    [data setValue:invite_group forKey:@"invite_group"];
    // #6 invite_group
    
    // #7 invite_multi_chat
    NSMutableDictionary *invite_multi_chat = [[NSMutableDictionary alloc] init];
    if ([all_data objectForKey:@"invite_multi_chat"]) {
        [data setValue:[all_data objectForKey:@"invite_multi_chat"] forKey:@"invite_multi_chat"];
    }
    [data setValue:invite_multi_chat forKey:@"invite_multi_chat"];
    // #7 invite_multi_chat
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] observeEventType];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    /*
    if (section == 0) {
        return @"Profile";
    }
    NSMutableArray *friends = [data valueForKey:@"friends"];
    return [NSString stringWithFormat:@"Friends (%lu) + Group + Multi", (unsigned long)[friends count]];
    */
    
    switch (section) {
        case 0:{
            return @"Profile";
        }
        case 1:{
            NSMutableDictionary *favorites = [data objectForKey:@"favorite"];
            return [NSString stringWithFormat:@"Favorite %d", [favorites count]];
        }
        case 2:{
            NSMutableDictionary *friends = [data objectForKey:@"friends"];
            return [NSString stringWithFormat:@"Friends %d", [friends count]];
        }
        case 3:{
            NSMutableDictionary *groups = [data objectForKey:@"groups"];
            return [NSString stringWithFormat:@"Groups %d", [groups count]];
        }
        case 4:{
            NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
            return [NSString stringWithFormat:@"Multi Chat %d", [multi_chat count]];
        }
        case 5:{
            NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
            return [NSString stringWithFormat:@"Invite Group %d", [invite_group count]];
        }
        case 6:{
            NSMutableDictionary *invite_multi_chat = [data objectForKey:@"invite_multi_chat"];
            return [NSString stringWithFormat:@"Invite Multi Chat %d", [invite_multi_chat count]];
        }
        default:
            break;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 100;
//    }else {
//        return 180.0f;
//    }
    
    switch (indexPath.section) {
        case 0:{
            return 100.0f;
        }
        case 1:{
            // @"Favorite"
            NSMutableDictionary *favorites = [data objectForKey:@"favorite"];
            if ([favorites count] == 0) {
               return 0;
            }else{
               return 180.0f;
            }
        }
        case 2:{
            // @"Friends";
            NSMutableDictionary *friends = [data objectForKey:@"friends"];
            if ([friends count] == 0) {
                return 0;
            }else{
                return 180.0f;
            }
        }
        case 3:{
            // @"Groups";
            NSMutableDictionary *groups = [data objectForKey:@"groups"];
            if ([groups count] == 0) {
                return 0;
            }else{
                return 180.0f;
            }
        }
        case 4:{
            // @"Multi Chat";
            NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
            if ([multi_chat count] == 0) {
                return 0;
            }else{
                return 180.0f;
            }
        }
        case 5:{
            // @"Invite Group";
            NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
            if ([invite_group count] == 0) {
                return 0;
            }else{
                return 180.0f;
            }
        }
        case 6:{
            // @"Invite Multi Chat";
            NSMutableDictionary *invite_multi_chat = [data objectForKey:@"invite_multi_chat"];
            if ([invite_multi_chat count] == 0) {
                return 0;
            }else{
                return 180.0f;
            }
        }
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*
    if (section == 0) {
        return 1;
    }else {
        NSMutableArray *friends = [data valueForKey:@"friends"];
        return [friends count];
    }
    */
    switch (section) {
        case 0:{
            return 1;
        }
        case 1:{
            // @"Favorite"
            NSMutableDictionary *favorites = [data objectForKey:@"favorite"];
            if ([favorites count] == 0) {
                return 0;
            }else{
                return [favorites count];
            }
        }
        case 2:{
            // @"Friends";
            NSMutableDictionary *friends = [data objectForKey:@"friends"];
            if ([friends count] == 0) {
                return 0;
            }else{
                return [friends count];
            }
        }
        case 3:{
            // @"Groups";
            NSMutableDictionary *groups = [data objectForKey:@"groups"];
            if ([groups count] == 0) {
                return 0;
            }else{
                return [groups count];
            }
        }
        case 4:{
            // @"Multi Chat";
            NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
            if ([multi_chat count] == 0) {
                return 0;
            }else{
                return [multi_chat count];
            }
        }
        case 5:{
            // @"Invite Group";
            NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
            if ([invite_group count] == 0) {
                return 0;
            }else{
                return [invite_group count];
            }
        }
        case 6:{
            // @"Invite Multi Chat";
            NSMutableDictionary *invite_multi_chat = [data objectForKey:@"invite_multi_chat"];
            if ([invite_multi_chat count] == 0) {
                return 0;
            }else{
                return [invite_multi_chat count];
            }
        }
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        ProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        }
        
        NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
        if ([profiles objectForKey:@"image_url"]) {
            [cell.imgPerson clear];
            [cell.imgPerson showLoadingWheel];
            [cell.imgPerson setUrl:[NSURL URLWithString:[profiles objectForKey:@"image_url"]]];
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

        FriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
        }
        
        switch (indexPath.section) {
            case 1:{
                // @"Favorite"
                NSMutableDictionary *favorites = [data objectForKey:@"favorite"];
                
                // NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:[item objectForKey:@"friend_id"]];
                NSArray *keys = [favorites allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [favorites objectForKey:key];
                
            
                NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
                
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
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                break;
            }
            case 2:{
                // @"Friends";
                NSMutableDictionary *friends = [data objectForKey:@"friends"];
                
                NSArray *keys = [friends allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id item = [friends objectForKey:key];
                
                NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
                
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
                
                // UserDataUILongPressGestureRecognizer
                UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
                
                lpgr.userData = indexPath;
                // lpgr.minimumPressDuration = 1.0; //seconds
                [cell addGestureRecognizer:lpgr];
                break;
            }
            case 3:{
                // @"Groups";
                NSMutableDictionary *groups = [data objectForKey:@"groups"];
                
                
                NSLog(@"");
                break;
            }
            case 4:{
                // @"Multi Chat";
                NSMutableDictionary *multi_chat = [data objectForKey:@"multi_chat"];
                
                NSLog(@"");
                break;
            }
            case 5:{
                // @"Invite Group";
                NSMutableDictionary *invite_group = [data objectForKey:@"invite_group"];
                
                NSLog(@"");
                break;
            }
            case 6:{
                // @"Invite Multi Chat";
                NSMutableDictionary *invite_multi_chat = [data objectForKey:@"invite_multi_chat"];
                
                NSLog(@"");
                break;
            }
            default:
                break;
        }
        
        /*
        NSMutableArray *friends = [data valueForKey:@"friends"];
        NSMutableDictionary *item = [friends objectAtIndex:indexPath.row];
    
        NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:[item objectForKey:@"friend_id"]];
        
        cell.lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], [item objectForKey:@"friend_id"]] ;
        
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
        
        // UserDataUILongPressGestureRecognizer
        UserDataUILongPressGestureRecognizer *lpgr = [[UserDataUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        // NSLog(@"not access tag >%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
        
        
        
        lpgr.userData = indexPath;
        // lpgr.minimumPressDuration = 1.0; //seconds
        [cell addGestureRecognizer:lpgr];
        
        */
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if (indexPath.section == 0) {
        MyProfile* profile = [storybrd instantiateViewControllerWithIdentifier:@"MyProfile"];
        [self.navigationController pushViewController:profile animated:YES];
    }else{
        
        NSMutableArray *friends = [data valueForKey:@"friends"];
        
        ChatView *chatView = [storybrd instantiateViewControllerWithIdentifier:@"ChatView"];        
        chatView.friend =[friends objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:chatView animated:YES];
    }
}

-(void)handleLongPress:(UserDataUILongPressGestureRecognizer *)longPress{

    NSIndexPath * section = longPress.userData;
    
    if (section.section == 0) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
        UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Favorite", @"Change friend's name", @"Hide", @"Block", nil];
        
        alert.userData = section;
        alert.tag = 1;
        [alert show];
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
                    case 1:
                        idata = [data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [data valueForKey:@"friends"];
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
                        idata = [data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [data valueForKey:@"friends"];
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
                        idata = [data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [data valueForKey:@"friends"];
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
                        idata = [data objectForKey:@"favorite"];
                        break;
                    case 2:
                        idata = [data valueForKey:@"friends"];
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
        
    }
}

- (IBAction)onLogout:(id)sender {
    [[Configs sharedInstance] removeData:_USER];
    
    [self viewWillAppear:false];

}
@end
