//
//  DropDown.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/24.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropDownDelegate <NSObject>

-(void)selectItem:(int)index;

@end

@interface DropDown : UIView

- (instancetype)initWithFrame:(CGRect)frame withStringArray:(NSArray *)stringArray;
@property (weak, nonatomic) id<DropDownDelegate> delegate;
-(void)selectIndex:(int)i;
@end
