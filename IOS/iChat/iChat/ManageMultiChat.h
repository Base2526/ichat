//
//  ManageMultiChat.h
//  iChat
//
//  Created by Somkid on 8/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ManageMultiChat : UIViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property(nonatomic)NSDictionary *friend;
@property(nonatomic)NSString* typeChat;
@property (weak, nonatomic) IBOutlet UIButton *btn_ManageMember;

- (IBAction)onManageMember:(id)sender;
- (IBAction)onInviteMember:(id)sender;
- (IBAction)onDeleteMultiChat:(id)sender;
@end
