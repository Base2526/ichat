//
//  MultiMembers.h
//  iChat
//
//  Created by Somkid on 6/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface MultiMembers : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic)NSDictionary *group;
@property (strong, nonatomic) FIRDatabaseReference *ref;
- (IBAction)onEdit:(id)sender;
@end
