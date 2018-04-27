//
//  TaskSegmentationTableViewCell.h
//  AgriPlanner
//
//  Created by zhangyz on 2018/4/2.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@interface TaskSegmentationTableViewCell : UITableViewCell
{
    
    IBOutlet UIView *_backView;                             // Cell小背景
    
    SubTaskInfo *_subTask;                                  // Cell对应的子任务

}

@property (strong, nonatomic) IBOutlet UIButton *editSegBtn;    // 编辑按钮

/**
 设置Cell的UI

 @param data 子任务
 */
- (void) setCellByData:(SubTaskInfo *)data;


@end

