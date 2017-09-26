//
//  MyProfile.h
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "GKImagePicker.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "TopAlignedLabel.h"

@interface MyProfile : UIViewController<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
//@property (weak, nonatomic) IBOutlet UITextField *txtFEmail;
@property (weak, nonatomic) IBOutlet TopAlignedLabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFStatus;

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (IBAction)onSave:(id)sender;
@end
