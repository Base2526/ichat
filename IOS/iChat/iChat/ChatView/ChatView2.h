//
//  ChatView2.h
//  iChat
//
//  Created by Somkid on 29/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSMessagingCell.h"
 #import "AppDelegate.h"
@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ChatView2 : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
}
@property (weak, nonatomic) IBOutlet UIView *_viewBottom;

@property (weak, nonatomic) IBOutlet UITextField *txtMessage;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property(nonatomic)NSDictionary *friend;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemMembers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemInvite;

@property(nonatomic)NSString* isType;

- (IBAction)onSend:(id)sender;

@end
