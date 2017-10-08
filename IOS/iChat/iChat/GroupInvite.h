//
//  Invite.h
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface GroupInvite : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnInvite;
@property(nonatomic)NSDictionary *group;

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onInvite:(id)sender;
@end
