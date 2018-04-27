//
//  TaskSegmentationTableView.m
//  AgriPlanner
//
//  Created by zhangyz on 2018/3/31.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import "TaskSegmentationTableView.h"

@implementation TaskSegmentationTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 增加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    tap.delegate = self;
    [_tapView addGestureRecognizer:tap];
    
    // 上传到飞控-按钮-初始化
    _upDataBtn.layer.masksToBounds = YES;
    _upDataBtn.layer.cornerRadius = 4.0;
    
    _beginWorkBtn.layer.masksToBounds = YES;
    _beginWorkBtn.layer.cornerRadius = 4.0;
    
}

/*
 点击背景-隐藏任务组列表
 */
-(void) tapClicked:(UITapGestureRecognizer*) recognizer
{
    [self removeFromSuperview];
}



@end
