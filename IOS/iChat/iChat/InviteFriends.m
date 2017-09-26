//
//  InviteFriends.m
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "InviteFriends.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"

@interface InviteFriends ()

@property (nonatomic, strong) NSMutableDictionary *selectedIndex;
@property (nonatomic, strong) NSMutableDictionary *friends;
@end

@implementation InviteFriends
@synthesize ref, friends, selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    friends = [NSMutableDictionary dictionary];
    selectedIndex = [NSMutableDictionary dictionary];
    
    ref = [[FIRDatabase database] reference];
    
    friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
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


#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Select Friend";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    HJManagedImageV *imageV =(HJManagedImageV *)[cell viewWithTag:100];
    UILabel *lblName =(UILabel *)[cell viewWithTag:101];
    
    // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
    NSArray *keys = [friends allKeys];
    NSString* key = [keys objectAtIndex:indexPath.row];
    NSMutableDictionary* item = [friends objectForKey:key];
    
    NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:key];
    
    lblName.text = [NSString stringWithFormat:@"%@-%@", [f objectForKey:@"name"], key] ;
    
    if ([item objectForKey:@"change_friends_name"]) {
        lblName.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"change_friends_name"], key];
    }
    
    if ([f objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[f objectForKey:@"image_url"]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{}
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    // cell.textLabel.text = _dataArray[indexPath.row][@"text"];
    if (selectedIndex[indexPath] != nil) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (selectedIndex[indexPath] == nil) {
        // NSMutableDictionary *friends = [[[Configs sharedInstance] loadData:_DATA] objectForKey:@"friends"];
        NSArray *keys = [friends allKeys];
        
        [selectedIndex setObject:[keys objectAtIndex:indexPath.row] forKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [selectedIndex removeObjectForKey:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    self.title =[NSString stringWithFormat:@"Choose friends(%d)", [selectedIndex count]];
}

- (IBAction)onOK:(id)sender {
    
    NSMutableDictionary* members =[NSMutableDictionary dictionary];
    
    for (NSString* key in selectedIndex) {
        id value = [selectedIndex objectForKey:key];
        // do stuff
        [members setObject:@{@"status":@"pedding"} forKey:value];
    }
    
    NSMutableDictionary *new_group = @{
                                       @"create" : [FIRServerValue timestamp],
                                       @"is_owner": @true,
                                       @"members": members,
                                       @"owner_id" : [[Configs sharedInstance] getUIDU]
                                       };
    
    NSString *create_group = [NSString stringWithFormat:@"toonchat/%@/multi_chat/", [[Configs sharedInstance] getUIDU]];
    [[[ref child:create_group] childByAutoId] setValue:new_group withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
