//
//  UIButton+CQlocation.m
//  aigc
//
//  Created by jerry on 2017/12/11.
//  Copyright © 2017年 changqin. All rights reserved.
//

#import "UIButton+CQlocation.h"
#import <objc/runtime.h>

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

@implementation UIButton (CQlocation)

/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 
 */

- (void)startCountDownWithTime:(NSInteger)timeLine
{
    NSString *subTitle = @"重新发送";
    UIColor *defultColor = UGUColorFromRGB_0x(0xfe5900);
    UIColor *runningColor = UGUColorFromRGB_0x(0xCCCCCC);
    UIColor *textColor = UGUColorFromRGB_0x(0xffffff);
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setTitle:subTitle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                self.layer.borderColor = [defultColor CGColor];
                [self setTitleColor:textColor forState:UIControlStateNormal];
                self.backgroundColor = defultColor;
                
            });
        } else {
            
            self.userInteractionEnabled = YES;
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1ds后重发", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setTitle:[NSString stringWithFormat:@"%@",timeStr] forState:UIControlStateNormal];
                self.layer.borderColor = [runningColor CGColor];
                [self setTitleColor:textColor forState:UIControlStateNormal];
                self.backgroundColor = runningColor;
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)setButtonShowType:(RSButtonType)type magin:(CGFloat)magin
{
    [self layoutIfNeeded];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    
    CGFloat space = titleFrame.origin.x - imageFrame.origin.x - imageFrame.size.width + magin;
    
    switch (type) {
        case RSButtonTypeRight:
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0,imageFrame.size.width - space, 0, -(imageFrame.size.width - space))];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x - imageFrame.origin.x), 0, imageFrame.origin.x - titleFrame.origin.x)];
        }
            break;
        case RSButtonTypeLeft:
        {
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,titleFrame.size.width + space, 0, -(titleFrame.size.width + space))];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x - imageFrame.origin.x), 0, titleFrame.origin.x - imageFrame.origin.x)];
        }
            break;
        case RSButtonTypeBottom:
        {
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleFrame.size.height + space, -(titleFrame.size.width))];
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(imageFrame.size.height + space, -(imageFrame.size.width), 0, 0)];
        }
            break;
        case RSButtonTypeTop:
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0,-(imageFrame.size.width), imageFrame.size.height + space, 0)];
            
            [self setImageEdgeInsets:UIEdgeInsetsMake(titleFrame.size.height + space,(titleFrame.size.width), 0, 0)];
        }
            break;
        default:
            break;
    }
    
}

- (void)cq_setButtonShowType:(RSButtonType)type magin:(CGFloat)magin{
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setButtonShowType:type magin:magin];
}

/**
 *  设置button添加边框及圆角
 */
- (void)setCornerRadiusAndBorderWidth
{
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [kTextColor_555 CGColor];
    self.layer.borderWidth = 0.5;
}

/**
 *  设置button添加边框及圆角
 */
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

/**
 *  富文本显示
 */
- (void)changeColorWithSubString:(NSString *)subString
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSRange redRangeTwo = NSMakeRange([[str string] rangeOfString:subString].location, [ [str string] rangeOfString:subString].length);
    //设置：对应字符的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:kMainColor range:redRangeTwo];
    [self setAttributedTitle:str forState:UIControlStateNormal];
}

- (NSTimeInterval )bsd_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setBsd_acceptEventInterval:(NSTimeInterval)bsd_acceptEventInterval{
    
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(bsd_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )bsd_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setBsd_acceptEventTime:(NSTimeInterval)bsd_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(bsd_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(cjr_sendAction:to:forEvent:));
    SEL mySEL = @selector(cjr_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    
    //----------------以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次
    
}

- (void)cjr_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.bsd_acceptEventTime < self.bsd_acceptEventInterval) {
        return;
    }
    if (self.bsd_acceptEventInterval > 0) {
        self.bsd_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    [self cjr_sendAction:action to:target forEvent:event];
}
- (void)setVTag:(BOOL)isBigV title:(NSString *)title maxWidth:(CGFloat)maxWidth
{
    if (!isValidStr(title)) {
        [self setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    NSString *name = isBigV ? [NSString stringWithFormat:@"%@ ", title] : title;
    CGFloat width = [name boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.width;
    if ((width + 10) > maxWidth && isBigV) {
        NSUInteger count = (NSUInteger)((maxWidth - 10) / self.titleLabel.font.pointSize) + 3;
        count = count > title.length ? title.length : count;
        name = [[name substringToIndex:count] stringByAppendingString:@"..."];
    }
    
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:name];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"大V-icon"];
    CGFloat height = self.frame.size.height - 3 < 12 ? self.frame.size.height - 3 : 12;
    height = height > 10 ? height: 10;
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, height, height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    if (isBigV) {
        [attri appendAttributedString:string]; //在文字后面添加图片
    }
    [self setAttributedTitle:attri forState:UIControlStateNormal];
}

@end
