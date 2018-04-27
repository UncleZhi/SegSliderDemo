//
//  TaskSegmentationTableView.h
//  AgriPlanner
//
//  Created by zhangyz on 2018/3/31.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSegmentationTableView : UIView<UIGestureRecognizerDelegate>
{
    
    IBOutlet UIView *_tapView;
}

@property (strong, nonatomic) IBOutlet UIView *backView;                // tableView黑色背景

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;             // tableView上方Title

@property (strong, nonatomic) IBOutlet UITableView *tableView;          // 列表

@property (strong, nonatomic) IBOutlet UIButton *upDataBtn;             // 上传到飞控

@property (strong, nonatomic) IBOutlet UIButton *beginWorkBtn;          // 开始作业


@end







