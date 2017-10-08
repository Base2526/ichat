//
//  ManageMultiChat.m
//  iChat
//
//  Created by Somkid on 8/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ManageMultiChat.h"
#import "MultiInvite.h"
#import "MultiMembers.h"
#import "UserDataUIAlertView.h"
#import "Configs.h"

@interface ManageMultiChat ()

@end

@implementation ManageMultiChat
@synthesize friend, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
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

- (IBAction)onManageMember:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MultiMembers *members = [storybrd instantiateViewControllerWithIdentifier:@"MultiMembers"];
    members.group = self.friend;
    
    [self.navigationController pushViewController:members animated:YES];
}

- (IBAction)onInviteMember:(id)sender {
    
    // Invite friend(สร้าง Multi-Chat)
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MultiInvite *muti = [storybrd instantiateViewControllerWithIdentifier:@"MultiInvite"];
    
    muti.typeChat = self.typeChat;
    muti.friend_id = [friend objectForKey:@"friend_id"];
    [self.navigationController pushViewController:muti animated:YES];
}

- (IBAction)onDeleteMultiChat:(id)sender {
    
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
                // [3]    (null)    @"multi_chat_id" : @"1654"
                NSString *child = [NSString stringWithFormat:@"toonchat/%@/multi_chat/%@/", [[Configs sharedInstance] getUIDU], [self.friend objectForKey:@"multi_chat_id"]];
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
@end
