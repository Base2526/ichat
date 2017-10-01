//
//  ManageGroup.h
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "GKImagePicker.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

@interface ManageGroup : UIViewController<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;

- (IBAction)onSave:(id)sender;
- (IBAction)onManageMembers:(id)sender;
- (IBAction)onInviteMember:(id)sender;
- (IBAction)onDeleteGroup:(id)sender;

@end
