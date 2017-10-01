//
//  MyVIew.m
//  KeyBoardShowAndHidden
//
//  Created by 吉飞飞 on 16/1/31.
//  Copyright © 2016年 吉飞飞. All rights reserved.
//

#import "UIView+KeyBoardShowAndHidden.h"
@implementation UIView (showAndHidden)
/**
 *  键盘辅助视图显示
 */
- (void)showAccessoryViewAnimation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
}
/**
 *  键盘辅助视图隐藏
 */
- (void)hiddenAccessoryViewAnimation{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification  object:nil];
}

#pragma mark -- 键盘上的视图显示和隐藏
- (void)keyBoardWillShow:(NSNotification *)notification{
    /**
     *  键盘时间的各种详细信息
     */
    NSDictionary * dic = notification.userInfo;
    /**
     *  键盘弹出动画的时间。
     */
    NSTimeInterval time = [dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /**
     *  弹出键盘的大小
     */
    CGRect keyBoardBounds = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    /**
     *  在键盘弹出过程中的高度（动态变化时的）
     */
    CGFloat keyBoardShowHeight = keyBoardBounds.size.height;
    /**
     *  键盘弹出时的动画类型
     */
    NSInteger option = [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    /**
     *  辅助视图跟随键盘一起弹出的动画
     */
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -keyBoardShowHeight);
    } completion:nil];
}

- (void)keyBoardWillHidden:(NSNotification *)notification{
    /**
     *  键盘时间的各种详细信息
     */
    NSDictionary * dic = notification.userInfo;
    /**
     *  键盘隐藏动画的时间。
     */
    NSTimeInterval time = [dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /**
     *  键盘隐藏时的动画类型
     */
    NSInteger option = [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    /**
     *  辅助视图跟随键盘一起隐藏的动画
     */
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];

}


@end