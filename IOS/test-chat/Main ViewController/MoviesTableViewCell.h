//
//  MoviesTableViewCell.h
//  CustomizingTableViewCell
//
//  Created by abc on 28/01/15.
//  Copyright (c) 2015 com.ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface MoviesTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//@property (weak, nonatomic) IBOutlet UILabel *lblYear;
//@property (weak, nonatomic) IBOutlet UIImageView *imgPoster;


@property (weak, nonatomic) IBOutlet HJManagedImageV *imgPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeFriendsName;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblIsFavorites;
@property (weak, nonatomic) IBOutlet UILabel *lblIsHide;
@property (weak, nonatomic) IBOutlet UILabel *lblIsBlock;

@property (weak, nonatomic) IBOutlet UILabel *lblOnline;

@end
