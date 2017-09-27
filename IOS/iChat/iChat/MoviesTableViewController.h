//
//  MoviesTableViewController.h
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "MessageRepo.h"

@interface MoviesTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onLogout:(id)sender;

@end
