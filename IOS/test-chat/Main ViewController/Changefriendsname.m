//
//  Changefriendsname.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "Changefriendsname.h"


@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;
#import "Configs.h"

@interface Changefriendsname ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation Changefriendsname
@synthesize friend_id, txtName, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"Friend id > %@", friend_id];
    
    ref = [[FIRDatabase database] reference];
    
    NSLog(@"friend_id = %@", friend_id);
        
    NSDictionary *friend = [[[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"] objectForKey:friend_id];
    
    txtName.text = @"";
    if ([friend objectForKey:@"change_friends_name"] != nil) {
        txtName.text = [friend objectForKey:@"change_friends_name"];
    }
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

- (IBAction)onSave:(id)sender {
    NSString *text_name = [txtName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (![text_name isEqualToString:@""] && [text_name length] > 0) {
        NSLog(@">> %@", text_name);

        __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/friends/", [[Configs sharedInstance] getUIDU]];
        
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@%@/change_friends_name/", child, friend_id]: text_name};
        [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error == nil) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
@end
