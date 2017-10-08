//
//  MutiInvite.h
//  iChat
//
//  Created by Somkid on 5/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface MutiInvite : UIViewController
//
//@end

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MultiInvite : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnInvite;
 @property(nonatomic)NSDictionary *multi_members;

@property(nonatomic)NSString *friend_id;

@property(nonatomic)NSString* typeChat;

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onOK:(id)sender;
@end

