//
//  Changefriendsname.h
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Changefriendsname : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property(nonatomic)NSString *friend_id;

- (IBAction)onSave:(id)sender;
@end
