//
//  ManageGroup.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ManageGroup.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "UpdateProfileGroupThread.h"
#import "GroupMembers.h"
#import "GroupInvite.h"
#import "UserDataUIAlertView.h"

@interface ManageGroup ()

@end

@implementation ManageGroup
@synthesize imageV, ref;
@synthesize imagePicker;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ref = [[FIRDatabase database] reference];
    
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    if ([self.group objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel]; // API_URL
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [self.group objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{
        [imageV clear];
    }
    
    self.txtGroupName.text = [self.group objectForKey:@"name"];
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
    NSLog(@">%d", [(UIGestureRecognizer *)gestureRecognizer view].tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
            
        case 1:
        {
            NSLog(@"");
            self.imagePicker = [[GKImagePicker alloc] init];
            self.imagePicker.cropSize = CGSizeMake(280, 280);
            self.imagePicker.delegate = self;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            } else {
                [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
//    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
//    UpdateProfileGroupThread *uThread = [[UpdateProfileGroupThread alloc] init];
//    [uThread setCompletionHandler:^(NSString *data) {
//
//        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
//
//        [[Configs sharedInstance] SVProgressHUD_Dismiss];
//
//        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//
////            [imageV clear];
////            [imageV showLoadingWheel];
////            [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
////            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
////
////            [self updateURI:jsonDict[@"url"]];
//        }
//        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
//    }];
//
//    [uThread setErrorHandler:^(NSString *error) {
//        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
//    }];
//    [uThread start:[self.group objectForKey:@"group_id"] :image];
    
    [self.imageV setImage:image];
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //    img = image;
    //
    //    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
    //        [self.popoverController dismissPopoverAnimated:YES];
    //    } else {
    //        [picker dismissViewControllerAnimated:YES completion:nil];
    //    }
    //    [self reloadData:nil];
    
    NSLog(@"");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [self.imageV setImage:chosenImage];
    
   
    
    //
    //    img = chosenImage;
    //    // [self hideImagePicker];
    //
    //    [self reloadData:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onSave:(id)sender {
    // UpdateMyProfileThread

    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Update"];
    UpdateProfileGroupThread *uThread = [[UpdateProfileGroupThread alloc] init];
    [uThread setCompletionHandler:^(NSString *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            //            [imageV clear];
            //            [imageV showLoadingWheel];
            //            [imageV setUrl:[NSURL URLWithString:jsonDict[@"url"]]];
            //            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
            //
            //            [self updateURI:jsonDict[@"url"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
    }];
    
    [uThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [uThread start:[self.group objectForKey:@"group_id"] :self.txtGroupName.text : [imageV image]];
}

- (IBAction)onManageMembers:(id)sender {
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupMembers *members = [storybrd instantiateViewControllerWithIdentifier:@"GroupMembers"];
    members.group = self.group;
    
    [self.navigationController pushViewController:members animated:YES];
}

- (IBAction)onInviteMember:(id)sender {
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupInvite *invite = [storybrd instantiateViewControllerWithIdentifier:@"GroupInvite"];
    invite.group = self.group;
    
    [self.navigationController pushViewController:invite animated:YES];
}

- (IBAction)onDeleteGroup:(id)sender {
    
    UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:@"Are you sure delete group?"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:@"Delete", nil];
    
    alert.userData = @"";
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                // Close
                NSLog(@"Close");
            }
                break;
                
            case 1:{
                // Close
                NSLog(@"Delete");
                
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/", [[Configs sharedInstance] getUIDU], [self.group objectForKey:@"group_id"]];
                [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    
                    if (error == nil) {
                        // [ref parent]
                        //NSString* parent = ref.parent.key;
                        
                        // จะได้ Group id
                        NSString* key = [ref key];
                        
                        NSLog(@"");
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
                break;
        }
    }
}

-(void)updateURI:(NSString *)uri{
    
    NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    [profiles setValue:uri forKey:@"image_url"];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:[[Configs sharedInstance] loadData:_DATA]];
    [newDict removeObjectForKey:@"profiles"];
    
    [newDict setObject:profiles forKey:@"profiles"];
    
    [[Configs sharedInstance] saveData:_DATA :newDict];
}

@end
