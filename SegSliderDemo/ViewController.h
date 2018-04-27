//
//  ViewController.h
//  SegSliderDemo
//
//  Created by zhangyz on 2018/4/27.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDualWaySlider.h"
#import "TaskModel.h"
#import "TaskSegmentationTableView.h"
#import "TaskSegmentationTableViewCell.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    SFDualWaySlider *_segSlider;        // 滑杆
    
    TaskInfo *_task;
    
    SubTaskInfo *_selectTask;           // 选中的子任务，编辑
    
    UIButton *_taskGroup;       // 任务组按钮
    
    UIButton *_joinTaskGroupBtn;   // 加入任务组按钮
    
    UIButton *_cancelEditTaskBtn;  // 取消编辑子任务
    
    UIButton *_saveTaskBtn;        // 保存子任务
    
    UIButton *_deleteTaskBtn;      // 删除子任务
    
    NSMutableArray *_segViewArray;      // 加载到滑杆的透明View
    
    TaskSegmentationTableView *_taskChooseView;
}

@end

