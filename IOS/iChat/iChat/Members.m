//
//  Members.m
//  iChat
//
//  Created by Somkid on 30/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Members.h"
#import "AppDelegate.h"
#import "HJManagedImageV.h"

@interface Members ()
{
    NSDictionary *members;
    NSMutableDictionary *friendsProfile;
}
@end

@implementation Members

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    members = [self.group objectForKey:@"members"];
    
    // NSMutableDictionary *f = [(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile];
    
    
    friendsProfile = [(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] ;
    NSLog(@"");
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
    
    
    NSMutableDictionary *fprofile = [friendsProfile objectForKey:key];
    
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
    }else{}
    
    
    return cell;
}

@end
