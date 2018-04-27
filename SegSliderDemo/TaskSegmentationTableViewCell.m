//
//  TaskSegmentationTableViewCell.m
//  AgriPlanner
//
//  Created by zhangyz on 2018/4/2.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import "TaskSegmentationTableViewCell.h"
#import "Util.h"



#define BOUNDLAYER_WIDTH (2)

@implementation TaskSegmentationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    
    // editSegBtn初始化
    [_editSegBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editSegBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 6.0;
    
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UI刷新
/**
 设置Cell的UI
 
 @param data 子任务
 */
- (void) setCellByData:(SubTaskInfo *)data
{
    _subTask = data;
    
    [_editSegBtn setTitle:[NSString stringWithFormat:@"%d-%d",_subTask.minLine,_subTask.maxLine] forState:UIControlStateNormal];
    
    if (_subTask.isEdit)
    {
        [_editSegBtn setBackgroundColor:[UIColor yellowColor]];
    }
    else
    {
        [_editSegBtn setBackgroundColor:[UIColor grayColor]];
    }
    
    [self refreshCellByStatus];

}



/**
 刷新Cell-根据子任务状态
 */
- (void) refreshCellByStatus
{


}



@end








