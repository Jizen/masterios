//
//  ZHBtnSelectView.m
//  ZHCustomBtn
//
//  Created by Apple on 16/3/16.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import "ZHBtnSelectView.h"
#import "ZHCustomBtn.h"

#define ZHBTN_PADDING 10

@interface ZHBtnSelectView ()
@property (nonatomic,assign)CGFloat maxHeight;
@end

@implementation ZHBtnSelectView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles column:(NSInteger)column {
    if (self = [super initWithFrame:frame]) {
        self.btnTitles = titles;
        self.column = column;
        [self setupContent:titles column:column];
    }
    return self;
}

- (void)setupContent:(NSArray *)titles column:(NSInteger)column {
    CGFloat btnW = (self.frame.size.width - ZHBTN_PADDING * 2 - (column - 1) * self.horizontalMargin) / column;
    // 按钮高度可以自己定义
    CGFloat btnH = 30;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    for (int i = 0; i < titles.count; i++) {

        NSInteger col = i % column; // 按钮坐在列
        NSInteger row  = i / column; // 按钮所在行
        btnX = ZHBTN_PADDING + btnW  * col;
        btnY = ZHBTN_PADDING + btnH  * row;
        
        // 指定自定义按钮frame
        // 创建自定义按钮
        ZHCustomBtn *btn = [[ZHCustomBtn alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.titleLabel.text = titles[i];
        btn.btnOnClick = ^(ZHCustomBtn *btn) {
            if ([self.delegate respondsToSelector:@selector(btnSelectView:selectedBtn:)]) {
                [self.delegate btnSelectView:self selectedBtn:btn];
            }
        };
        if (i == titles.count - 1) {
            self.maxHeight = CGRectGetMaxY(btn.frame) + ZHBTN_PADDING;
            self.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.maxHeight);
        }
        btn.btnSelected = NO;
        [self addSubview:btn];
    }
}

- (void)setHorizontalMargin:(CGFloat)horizontalMargin {
    _horizontalMargin = horizontalMargin;
    
    // 修改水平间距时 需要重新计算按钮的宽度
    CGFloat btnW = (self.frame.size.width - ZHBTN_PADDING * 2 - (self.column - 1) * self.horizontalMargin) / self.column;
    
    for (int i = 0; i<self.btnTitles.count; i++) {
        NSInteger col = i % self.column; // 按钮坐在列
        ZHCustomBtn *btn = self.subviews[i];
        btn.frame = CGRectMake(ZHBTN_PADDING + (btn.frame.size.width + horizontalMargin) * col,
                               btn.frame.origin.y,
                               btnW,
                               btn.frame.size.height);
    }
}

- (void)setVerticalMargin:(CGFloat)verticalMargin {
    _verticalMargin = verticalMargin;

    for (int i = 0; i<self.btnTitles.count; i++) {
        NSInteger row = i / self.column; // 按钮坐在行
        ZHCustomBtn *btn = self.subviews[i];
        btn.frame = CGRectMake(btn.frame.origin.x,ZHBTN_PADDING + (btn.frame.size.height + verticalMargin) * row, btn.frame.size.width, btn.frame.size.height);
        
        if (i == self.btnTitles.count - 1) {
            self.maxHeight = CGRectGetMaxY(btn.frame) + ZHBTN_PADDING;
            self.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.maxHeight);
        }
    }
}

@end
