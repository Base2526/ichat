//
//  MyVIew.h
//  KeyBoardShowAndHidden
//
//  Created by 吉飞飞 on 16/1/31.
//  Copyright © 2016年 吉飞飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (showAndHidden)
/**
 *  键盘辅助视图显示动画
 */
- (void)showAccessoryViewAnimation;
/**
 *  键盘辅助视图隐藏动画
 */
- (void)hiddenAccessoryViewAnimation;
@end