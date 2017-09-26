//
//  InviteFriends.h
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface InviteFriends : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onOK:(id)sender;
@end
