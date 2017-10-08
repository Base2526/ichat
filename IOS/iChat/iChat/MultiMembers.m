//
//  MultiMembers.m
//  iChat
//
//  Created by Somkid on 6/10/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "MultiMembers.h"

#import "AppDelegate.h"
#import "HJManagedImageV.h"
#import "MultiInvite.h"

@interface MultiMembers ()
{
    NSMutableDictionary *members;
    NSMutableDictionary *friendsProfile;
}

@property(nonatomic, getter=isEditing) BOOL editing;
@end

@implementation MultiMembers
@synthesize ref;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    members = [self.group objectForKey:@"members"];
    friendsProfile = [(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] ;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MultiInvite"]){
        MultiInvite *groupInvite = (MultiInvite*)segue.destinationViewController;
        groupInvite.typeChat = @"4";
        groupInvite.multi_members = self.group;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // NSMutableDictionary *favorites = [data objectForKey:@"favorite"];
    
    
    NSArray *keys = [members allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    id item = [members objectForKey:key];
    
    NSMutableDictionary *fprofile = [friendsProfile objectForKey:[item objectForKey:@"friend_id"]];
    
    HJManagedImageV *imageV = (HJManagedImageV *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    NSLog(@"");
    label.text = [fprofile objectForKey:@"name"];
    
    // NSMutableDictionary *profiles = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"profiles"];
    if ([fprofile objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[fprofile objectForKey:@"image_url"]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV ];
    }else{
        [imageV clear];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( editingStyle== UITableViewCellEditingStyleDelete) {
        NSArray *keys = [members allKeys];
        id key = [keys objectAtIndex:indexPath.row];
        
        NSString *child = [NSString stringWithFormat:@"toonchat/%@/multi_chat/%@/members/%@", [[Configs sharedInstance] getUIDU], [self.group objectForKey:@"multi_chat_id"], key];
        [[ref child:child] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {

            if (error == nil) {
                // [ref parent]
                //NSString* parent = ref.parent.key;

                // จะได้ Group id
                NSString* key = [ref key];

                NSLog(@"");

                [members removeObjectForKey:key];
                [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView setEditing:NO animated:YES];
            }
        }];
    }
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 0) {
    //        return UITableViewCellEditingStyleNone;
    //    }
    return UITableViewCellEditingStyleDelete;
}

- (IBAction)onEdit:(id)sender {
    if([self.tableView isEditing]){
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
}
@end


