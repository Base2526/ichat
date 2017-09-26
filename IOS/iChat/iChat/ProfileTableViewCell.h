//
//  ProfileTableViewCell.h
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/23/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HJManagedImageV *imgPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusmessage;
@end
