//
//  ZHBtnSelectView.h
//  ZHCustomBtn
//
//  Created by Apple on 16/3/16.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZHBtnSelectView;
@class ZHCustomBtn;
@protocol ZHBtnSelectViewDelegate <NSObject>

- (void)btnSelectView:(ZHBtnSelectView *)btnSelectView selectedBtn:(ZHCustomBtn *)btn;

@end

typedef NS_ENUM(NSInteger,BtnSelectType) {
    BtnSelectTypeSingleChoose = 0,
    BtnSelectTypeMultiChoose,
};



@interface ZHBtnSelectView : UIView
// title数组
@property (nonatomic,strong)NSArray *btnTitles;
// 列数
@property (nonatomic,assign)NSInteger column;
// 水平间距
@property (nonatomic,assign)CGFloat horizontalMargin;
// 竖直间距
@property (nonatomic,assign)CGFloat verticalMargin;

@property (nonatomic,weak)id<ZHBtnSelectViewDelegate> delegate;

// 选择的类型(单选多选)
@property (nonatomic,assign)BtnSelectType selectType;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles column:(NSInteger)column;

@end
