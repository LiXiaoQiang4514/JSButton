//
//  UIButton+CQlocation.h
//  aigc
//
//  Created by jerry on 2017/12/11.
//  Copyright © 2017年 changqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - button文字所在位置

typedef NS_ENUM(NSInteger, RSButtonType) {
    RSButtonTypeRight = 0,
    RSButtonTypeLeft,
    RSButtonTypeBottom,
    RSButtonTypeTop
};
@interface UIButton (CQlocation)
/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 */

- (void)startCountDownWithTime:(NSInteger)timeLine;
/**
 *  设置button中title的位置
 *
 *  @param type title位置类型
 
 */
- (void)setButtonShowType:(RSButtonType)type magin:(CGFloat)magin;
- (void)cq_setButtonShowType:(RSButtonType)type magin:(CGFloat)magin;
/**
 *  设置button添加边框及圆角
 */
- (void)setCornerRadiusAndBorderWidth;
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)width;
/**
 *  富文本显示
 */
- (void)changeColorWithSubString:(NSString *)subString;
/**
 *  文字后添加大V标签
 */
- (void)setVTag:(BOOL)isBigV title:(NSString *)title maxWidth:(CGFloat)maxWidth;

@property (nonatomic, assign) NSTimeInterval bsd_acceptEventInterval; // 重复点击的间隔

@end
