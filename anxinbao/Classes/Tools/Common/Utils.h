//
//  Utils.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/3/30.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#endif /* Utils_h */
@interface Utils : NSObject
+ (UIImage*) createImageWithColor: (UIColor*) color;

+(UILabel *)addLabel:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withColor:(NSInteger)color withSize:(CGFloat)size;

+(UILabel *)addLabel:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withDefineColor:(UIColor *)color withSize:(CGFloat)size;

+(UILabel *)addLabelCenter:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withDefineColor:(UIColor *)color withSize:(CGFloat)size;

+(UILabel *)addLabelCenter:(NSString *)text For:(UIView *)parent withFrame:(CGRect)frame withColor:(NSInteger)color withSize:(CGFloat)size;

+(UIButton *)addButton:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withBg:(NSString*) image withDefineColor:(UIColor *)color withSize:(CGFloat)size;

+(UIButton *)addButton:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withImage:(NSString*) image withDefineColor:(UIColor *)color withSize:(CGFloat)size;

+(UIButton *)addButtonCenter:(NSString*)text For:(UIView*)parent withFrame:(CGRect)frame withImage:(NSString*) image withDefineColor:(UIColor *)color withSize:(CGFloat)size;

+(UIImageView*)addImage:(NSString*)name For:(UIView*)parent withFrame:(CGRect)frame;

+(NSString*)typeTitle:(NSString*)type;

+(UIView*)showPopup;
+(NSString *)convertDataToHexStr:(NSData *)data length:(int)length;
+(void)showPopup:(NSString*)title withText:(NSString*)text;
+(UIImage*)getResizingImage:(UIImage*)image;
+ (id)fetchSSIDInfo;
@end
