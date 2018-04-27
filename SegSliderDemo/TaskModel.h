//
//  TaskModel.h
//  SegSliderDemo
//
//  Created by zhangyz on 2018/4/27.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TaskInfo : NSObject

@property(strong, nonatomic) NSMutableArray *subTaskList;       // 子任务（SubTaskInfo *）


@end



@interface SubTaskInfo : NSObject

@property(assign, nonatomic) int minLine;           // 区间小值 第几条线

@property(assign, nonatomic) int maxLine;           // 区间大值 第几条线

@property(assign, nonatomic) BOOL isEdit;           // YES:这个子任务在编辑状态

@end
