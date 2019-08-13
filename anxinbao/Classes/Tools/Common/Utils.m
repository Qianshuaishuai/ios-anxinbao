//
//  Utils.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/3/30.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utils.h"
#import "HelpHeaderFile.h"
#import "DetailViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation Utils
+ (UIImage*) createImageWithColor: (UIColor*) color

{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

+(CGRect)transFrame:(CGRect)frame{
    /*frame.origin.x*=UIScaleRatio;
    frame.origin.y*=UIScaleRatio;
    frame.size.width*=UIScaleRatio;
    frame.size.height*=UIScaleRatio;*/
    return frame;
}

+(UIImage*)getResizingImage:(UIImage*)image{
    
    CGFloat top = 0; // 顶端点（若拉伸 这个点会一直重复复制）
    
    CGFloat bottom = 0 ; // 底端点
    
    CGFloat left = 10; // 左端点
    
    CGFloat right = 25; // 右端点
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

+(UILabel *)addLabel:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withDefineColor:(UIColor*)color withSize:(CGFloat)size{
    
    UILabel* label=[[UILabel alloc] initWithFrame:[Utils transFrame:frame]];
    label.textColor=color;
    label.font=[UIFont systemFontOfSize:size];//*UIScaleRatio
    label.text=text;
    label.numberOfLines=0;
    [parent addSubview:label];
    return label;
}

+(UIButton *)addButton:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withImage:(NSString*) image withDefineColor:(UIColor *)color withSize:(CGFloat)size{
    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=[Utils transFrame:frame];
    if(image!=nil){
        [b setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [b setTitle:text forState:UIControlStateNormal];
    b.titleLabel.font=[UIFont systemFontOfSize:size];//*UIScaleRatio
    [b setTitleColor:color forState:UIControlStateNormal];
    [parent addSubview:b];
    return b;
}

+(UIButton *)addButton:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withBg:(NSString*) image withDefineColor:(UIColor *)color withSize:(CGFloat)size{
    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=[Utils transFrame:frame];
    if(image!=nil){
        [b setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [b setTitle:text forState:UIControlStateNormal];
    b.titleLabel.font=[UIFont systemFontOfSize:size];//*UIScaleRatio
    [b setTitleColor:color forState:UIControlStateNormal];
    [parent addSubview:b];
    return b;
}

+(UIButton *)addButtonCenter:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withImage:(NSString*) image withDefineColor:(UIColor *)color withSize:(CGFloat)size{
    UIButton* btn=[Utils addButton:text For:parent withFrame:frame withImage:image withDefineColor:color withSize:size];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    return btn;
}

+(UILabel *)addLabel:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withColor:(NSInteger)color withSize:(CGFloat)size{
    UIColor *color1=UIColorFromRGB(color);
    return [Utils addLabel:text For:parent withFrame:frame withDefineColor:color1 withSize:size];
}

+(UILabel *)addLabelCenter:(NSString *)text For:(UIView *)parent withFrame:(CGRect)frame withDefineColor:(UIColor *)color withSize:(CGFloat)size{
    UILabel* label=[Utils addLabel:text For:parent withFrame:frame withDefineColor:color withSize:size];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

+(UILabel *)addLabelCenter:(NSString *)text For:(UIView *)parent withFrame:(CGRect)frame withColor:(NSInteger)color withSize:(CGFloat)size{
    UIColor *color1=UIColorFromRGB(color);
    UILabel* label=[Utils addLabelCenter:text For:parent withFrame:frame withDefineColor:color1 withSize:size];
    return label;
}

+(UIImageView*)addImage:(NSString*)name For:(UIView*)parent withFrame:(CGRect)frame{
    UIImageView* img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    img.frame=[Utils transFrame:frame];
    [parent addSubview:img];
    return img;
}

#define popup_width 317

+(void)closePopup{
    UIWindow *window = [UIApplication sharedApplication].windows[0];//[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    UIView* v = [window viewWithTag:20];
    [v removeFromSuperview];
}
+ (NSString *)convertDataToHexStr:(NSData *)data length:(int)length
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:length];//[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%X", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

+(UIView*)showPopup{
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    v.backgroundColor=RGBACOLOR(0, 0, 0, 0.5);
    ///[self.view addSubview:v];
    UIWindow *window = [UIApplication sharedApplication].windows[0];//[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    window.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);//UIColor clearColor];
    window.windowLevel = UIWindowLevelNormal;
    window.alpha = 1.f;
    window.hidden = NO;
    v.tag=20;
    [window addSubview:v];
    CGFloat y=(MainScreenHeight-156.5)/2-30;
    CGFloat x=(MainScreenWidth-popup_width)/2;
    UIView* popup=[[UIView alloc] initWithFrame:CGRectMake(x, y, popup_width, 156)];
    popup.layer.cornerRadius=5;
    popup.backgroundColor=UIColorFromRGB(0xe7ebeb);
    [v addSubview:popup];
    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.tag=12;
    b.frame=CGRectMake(x+popup_width-41, y-20-41, 41, 41);
    [b setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b];
    return popup;
}

+(NSString*)typeTitle:(NSString*)type{
    if([type isEqualToString:@"urine"]){
        return ASLocalizedString(@"尿量报警");
    }else if([type isEqualToString:@"inactivity"]){
        return ASLocalizedString(@"静止报警");
    }else if([type isEqualToString:@"fall"]){
        return ASLocalizedString(@"跌倒报警");
    }else{
        return ASLocalizedString(@"紧急报警");
    }
}

+(void)showPopup:(NSString*)title withText:(NSString*)text{
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    v.backgroundColor=RGBACOLOR(0, 0, 0, 0.5);
    ///[self.view addSubview:v];
    UIWindow *window = [UIApplication sharedApplication].windows[0];//[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    window.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);//UIColor clearColor];
    window.windowLevel = UIWindowLevelNormal;
    window.alpha = 1.f;
    window.hidden = NO;
    v.tag=20;
    [window addSubview:v];
    CGFloat y=(MainScreenHeight-156.5)/2-30;
    CGFloat x=(MainScreenWidth-popup_width)/2;
    UIView* popup=[[UIView alloc] initWithFrame:CGRectMake(x, y, popup_width, 156)];
    popup.layer.cornerRadius=5;
    popup.backgroundColor=UIColorFromRGB(0xe7ebeb);
    [v addSubview:popup];
    
    [Utils addLabelCenter:title For:popup withFrame:CGRectMake(0, 20, popup_width, 20) withColor:0x222222 withSize:20];
    [Utils addLabelCenter:text For:popup withFrame:CGRectMake(0, 60, popup_width, 15) withColor:0x555555 withSize:15];
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, popup.frame.size.height-50, popup.frame.size.width, 1)];
    line.backgroundColor=UIColorFromRGB(0xd8d8d8);
    [popup addSubview:line];
    UIButton* ok=[UIButton buttonWithType:UIButtonTypeCustom];
    ok.frame=CGRectMake(0, popup.frame.size.height-50+15, popup_width, 20);
    [ok setTitle:ASLocalizedString(@"查看详情")forState:UIControlStateNormal];
    ok.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [ok setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:ok];
    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake(x+popup_width-41, y-20-41, 41, 41);
    [b setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b];
    //objc_setAssociatedObject(b, @"myBtn", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [ok addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    //[window makeKeyAndVisible];
    //window set
    //创建
    //弹出
    //[self presentViewController:alertController animated:YES completion:nil];
    //window s
}

+(void)confirm{
    
}

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}
@end
