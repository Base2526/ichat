//
//  ContactsViewController.h
//  iChat
//
//  Created by Somkid on 25/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ContactsViewController : UIViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;
- (IBAction)onRefresh:(id)sender;
- (IBAction)onCreateGroup:(id)sender;
@end
