//
//  ViewController.m
//  SegSliderDemo
//
//  Created by zhangyz on 2018/4/27.
//  Copyright © 2018年 zhangyz. All rights reserved.
//

#import "ViewController.h"

#define SLIDER_HEIGHT (35)                      // 滑杆滑动条高度

#define SLIDER_BACKVIEW_HEIGHT (75)             // 滑杆整体高度

#define SEG_TASK_BTNTAG (20180402)              // 子任务列表中-航迹线范围 编辑按钮

#define COLOR(R, G, B, A)               [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define ROUTE_SELECTING         COLOR(0xff, 0xf5, 0x53, 1.0)

#define ROUTE_SELECTED          COLOR(0xff, 0xf5, 0x53, 0.5)

#define STYLE_BLUE                    COLOR(0x33, 0x85, 0xff, 1)

// 字体
#define FONT(S)                     [UIFont systemFontOfSize:S]
#define BOLD_FONT(S)                [UIFont boldSystemFontOfSize:S]


#define SEGSLIDER_RANGEMAX                (110)          // 滑杆最大值

CGFloat DEVICE_WIDTH;                // 横屏屏幕宽度
CGFloat DEVICE_HEIGHT;               // 横屏屏幕高度

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    DEVICE_WIDTH = MIN(screenSize.width, screenSize.height);
    DEVICE_HEIGHT = MAX(screenSize.width, screenSize.height);
    
    // 数组初始化
    _segViewArray = [[NSMutableArray alloc] init];
    
    // 任务初始化
    _task = [[TaskInfo alloc] init];
    _task.subTaskList = [[NSMutableArray alloc] init];
    
    // 初始化分段选择滑杆
    [self refreshSegmentationSlider:SEGSLIDER_RANGEMAX];
    
    [self initButton];
    
    // 初始化任务选择菜单
    _taskChooseView = [[NSBundle mainBundle] loadNibNamed:@"TaskSegmentationTableView" owner:self options:nil].firstObject;
    
    _taskChooseView.tableView.delegate = self;
    _taskChooseView.tableView.dataSource = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    view.backgroundColor = [UIColor clearColor];
    _taskChooseView.tableView.tableHeaderView = view;
    [_taskChooseView setFrame:CGRectMake(0, 0, DEVICE_HEIGHT, DEVICE_WIDTH)];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 初始化画页上的按钮
 */
- (void) initButton
{
    _taskGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    _taskGroup.frame = CGRectMake(DEVICE_HEIGHT - 105 - 20, 10, 105, 44);
    _taskGroup.titleLabel.font = FONT(14);
    [_taskGroup setTitle:@"任务组" forState:UIControlStateNormal];
    [_taskGroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_taskGroup setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_taskGroup setBackgroundImage:[self imageWithColor:STYLE_BLUE] forState:UIControlStateNormal];
    [_taskGroup addTarget:self action:@selector(clickTaskGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_taskGroup];
    
    // 初始化加入任务组按钮
    _joinTaskGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _joinTaskGroupBtn.frame = CGRectMake(DEVICE_HEIGHT - 105 - 20, DEVICE_WIDTH - 37 - 8, 105, 37);
    _joinTaskGroupBtn.layer.masksToBounds = YES;
    _joinTaskGroupBtn.layer.cornerRadius = 4;
    _joinTaskGroupBtn.titleLabel.font = FONT(14);
    [_joinTaskGroupBtn setTitle:@"加入任务组" forState:UIControlStateNormal];
    [_joinTaskGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_joinTaskGroupBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_joinTaskGroupBtn setBackgroundImage:[self imageWithColor:STYLE_BLUE] forState:UIControlStateNormal];
    [_joinTaskGroupBtn addTarget:self action:@selector(clickJoinTaskGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_joinTaskGroupBtn];
    
    
    // 保存子任务
    _saveTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveTaskBtn.hidden = YES;
    _saveTaskBtn.frame = CGRectMake(DEVICE_HEIGHT - 105 - 20, DEVICE_WIDTH - 37 - 8, 105, 37);
    _saveTaskBtn.layer.masksToBounds = YES;
    _saveTaskBtn.layer.cornerRadius = 4;
    _saveTaskBtn.titleLabel.font = FONT(14);
    [_saveTaskBtn setTitle:@"保存子任务" forState:UIControlStateNormal];
    [_saveTaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveTaskBtn setBackgroundImage:[self imageWithColor:STYLE_BLUE] forState:UIControlStateNormal];
    [_saveTaskBtn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveTaskBtn];
    
    
    // 删除子任务
    _deleteTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteTaskBtn.hidden = YES;
    _deleteTaskBtn.frame = CGRectMake(DEVICE_HEIGHT - 105 - 20, _saveTaskBtn.frame.origin.y - 37 - 8, 105, 37);
    _deleteTaskBtn.layer.masksToBounds = YES;
    _deleteTaskBtn.layer.cornerRadius = 4;
    _deleteTaskBtn.titleLabel.font = FONT(14);
    [_deleteTaskBtn setTitle:@"删除子任务" forState:UIControlStateNormal];
    [_deleteTaskBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_deleteTaskBtn setBackgroundImage:[self imageWithColor:COLOR(0, 0, 0, 0.7f)] forState:UIControlStateNormal];
    [_deleteTaskBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteTaskBtn];
    
    
    // 取消编辑子任务
    _cancelEditTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelEditTaskBtn.hidden = YES;
    _cancelEditTaskBtn.frame = CGRectMake(DEVICE_HEIGHT - 105 - 20, _deleteTaskBtn.frame.origin.y - 37 - 8, 105, 37);
    _cancelEditTaskBtn.layer.masksToBounds = YES;
    _cancelEditTaskBtn.layer.cornerRadius = 4;
    _cancelEditTaskBtn.titleLabel.font = FONT(14);
    [_cancelEditTaskBtn setTitle:@"取消编辑" forState:UIControlStateNormal];
    [_cancelEditTaskBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_cancelEditTaskBtn setBackgroundImage:[self imageWithColor:COLOR(0, 0, 0, 0.7f)] forState:UIControlStateNormal];
    [_cancelEditTaskBtn addTarget:self action:@selector(clickCancelEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelEditTaskBtn];
    
    
}


#pragma mark - UI刷新
/**
 刷新滑杆
 
 @param lineCount 最大值
 */
- (void) refreshSegmentationSlider:(int)lineCount
{
    // 滑杆双向选择
    // 初始化
    if (!_segSlider)
    {
        _segSlider = [[SFDualWaySlider alloc] initWithFrame:CGRectMake(0, DEVICE_WIDTH - SLIDER_BACKVIEW_HEIGHT - 15, DEVICE_HEIGHT - 180, SLIDER_BACKVIEW_HEIGHT) minValue:1 maxValue:lineCount blockSpaceValue:0];
        
        // 横条高度和圆角
        _segSlider.progressHeight = SLIDER_HEIGHT;
        _segSlider.progressRadius = 4;
        
        _segSlider.frontValue = lineCount;//前段所代表的值 默认 最小到最大的一半
        _segSlider.frontScale = 1;//分段比例  （0～1） 默认0.5；
        
        // 设置横条颜色
        _segSlider.darkColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.3f];
        _segSlider.lightColor = ROUTE_SELECTING;
        
        // 滑块上方显示板颜色
        _segSlider.minIndicateView.backIndicateColor = [UIColor yellowColor];
        _segSlider.maxIndicateView.backIndicateColor = [UIColor yellowColor];
        
        // 计算单位长度
        float unitWidth = (_segSlider.frame.size.width - 2 * _segSlider.progressLeftSpace) / (lineCount);
        
        // 设置滑块透明
        _segSlider.blockImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(unitWidth, SLIDER_HEIGHT)];
        // 滑块上方显示板距离横条距离
        _segSlider.indicateViewOffset = 3;
        // 滑块上方显示板宽度
        _segSlider.indicateViewWidth = 35;
        // 滑块间距
        _segSlider.spaceInBlocks = 0;
        
        _segSlider.sliderValueChanged = ^(CGFloat minValue, CGFloat maxValue) {
            
            
        };
        
        // 点击滑杆灰色背景
        _segSlider.clickProgressView = ^(CGFloat x)
        {
            if (_selectTask)
            {
                return;
            }
            
            if ([_task.subTaskList count] == 0)
            {
                return;
            }
            
            // 计算单位长度
            float unitWidth = (_segSlider.frame.size.width - 2 * _segSlider.progressLeftSpace) / (lineCount);
            float positionX = x / unitWidth;
            
            
            SubTaskInfo *firstTaskInfo = [_task.subTaskList firstObject];
            SubTaskInfo *lastTaskInfo = [_task.subTaskList lastObject];
            // 最左侧
            if (positionX + 1 < firstTaskInfo.minLine)
            {
                // 当前已经是在最左侧
                if (_segSlider.currentMinValue < firstTaskInfo.minLine)
                {
                    return;
                }
                else
                {
                    _segSlider.currentMinValue = 1;                         // 一定要先设置Min值(内部实现限制)
                    _segSlider.currentMaxValue = firstTaskInfo.minLine - 1;
                    
                    [self setSegSliderCanEdit:YES];
                }
            }
            // 最右侧
            else if (positionX > lastTaskInfo.maxLine)
            {
                // 当前已经是在最右侧
                if (_segSlider.currentMaxValue > lastTaskInfo.maxLine)
                {
                    return;
                }
                else
                {
                    _segSlider.currentMaxValue = lineCount;                 // 一定要先设置Max值(内部实现限制)
                    _segSlider.currentMinValue = lastTaskInfo.maxLine + 1;
                    
                    [self setSegSliderCanEdit:YES];
                }
            }
            // 点击的中间
            else
            {
                // 防御
                if ([_task.subTaskList count] < 2)
                {
                    return;
                }
                
                if (_segSlider.minRange < x && x < (_segSlider.progressView.frame.size.width - _segSlider.maxRange))
                {
                    return;
                }
                
                for (int taskNum = 1; taskNum < [_task.subTaskList count]; taskNum++)
                {
                    SubTaskInfo *taskInfoA = [_task.subTaskList objectAtIndex:taskNum - 1];
                    SubTaskInfo *taskInfoB = [_task.subTaskList objectAtIndex:taskNum];
                    
                    // 判断一段
                    if (taskInfoA.maxLine < positionX && positionX + 1 < taskInfoB.minLine)
                    {
                        _segSlider.currentMaxValue = lineCount;
                        _segSlider.currentMinValue = 1;
                        _segSlider.currentMaxValue = taskInfoB.minLine - 1;
                        _segSlider.currentMinValue = taskInfoA.maxLine + 1;
                        [self setSegSliderCanEdit:YES];
                        break;
                    }
                }
            }
            
            // 区间范围
            [self setSliderScrollRange:lineCount];
            
            
            // 控制已选中区域显示
            [self setSelectedView:lineCount];
            
        };
        
        //设置标题，如果需要设置默认值 最好先写这个，否则设置默认值后不会第一时间触发
        _segSlider.getMinTitle = ^NSString *(CGFloat minValue)
        {
            
            if (floor(minValue) == 1.f) {
                return @"1";
            }else{
                return [NSString stringWithFormat:@"%.f",floor(minValue)];
            }
            
        };
        
        _segSlider.getMaxTitle = ^NSString *(CGFloat maxValue)
        {
            
            if (floor(maxValue) == lineCount) {
                return [NSString stringWithFormat:@"%d",lineCount];
            }else{
                return [NSString stringWithFormat:@"%.f",floor(maxValue)];
            }
        };
        
        //分段 表示前部分占比frontScale=80%  所在值范围为[currentMinValue,currentMaxValue]  即剩下的 20%滑动距离 值范围为[currentMaxValue，60]
        _segSlider.frontScale = 1;
        _segSlider.frontValue = lineCount;
        
        
        [self.view addSubview:_segSlider];
    }
    
    // 刷新
    
    // 计算单位长度
    float unitWidth = (_segSlider.frame.size.width - 2 * _segSlider.progressLeftSpace) / (lineCount);
    
    // 滑块最小值和最大值显示
    [_segSlider.minIndicateView setTitle:@"1"];
    [_segSlider.maxIndicateView setTitle:[NSString stringWithFormat:@"%d",lineCount]];
    
    
    // 设置显示位置
    [self setSliderShowPosition:lineCount];
    
    
    // 区间范围
    [self setSliderScrollRange:lineCount];
    
    
    // 控制已选中区域显示
    [self setSelectedView:lineCount];
    
    
}

/*
 设置显示位置
 */
- (void) setSliderShowPosition:(int)lineCount
{
    if (_task.subTaskList && [_task.subTaskList count] > 0)
    {
        // 有数据
    }
    else
    {
        // 无数据
        _segSlider.currentMaxValue = lineCount;
        _segSlider.currentMinValue = 1;
        [self setSegSliderCanEdit:YES];
        return;
    }
    
    
    
    // 编辑状态
    if (_selectTask)
    {
        _segSlider.currentMaxValue = lineCount;
        _segSlider.currentMinValue = 1;
        _segSlider.currentMinValue = _selectTask.minLine;
        _segSlider.currentMaxValue = _selectTask.maxLine;
        
        [self setSegSliderCanEdit:YES];
    }
    // 新建状态
    else
    {
        SubTaskInfo *firstTaskInfo = [_task.subTaskList firstObject];
        SubTaskInfo *lastTaskInfo = [_task.subTaskList lastObject];
        // 最左可选择
        if (firstTaskInfo.minLine > 1)
        {
            _segSlider.currentMinValue = 1;                         // 一定要先设置Min值(内部实现限制)
            _segSlider.currentMaxValue = firstTaskInfo.minLine - 1;
            
            [self setSegSliderCanEdit:YES];
        }
        // 最右可选择
        else if (lastTaskInfo.maxLine < lineCount)
        {
            _segSlider.currentMaxValue = lineCount;                 // 一定要先设置Max值(内部实现限制)
            _segSlider.currentMinValue = lastTaskInfo.maxLine + 1;
            
            [self setSegSliderCanEdit:YES];
        }
        else
        {
            _segSlider.currentMaxValue = lineCount;
            _segSlider.currentMinValue = lineCount;
            [self setSegSliderCanEdit:NO];
            
            
            if ([_task.subTaskList count] > 1)
            {
                for (int taskNum = 1; taskNum < [_task.subTaskList count]; taskNum++)
                {
                    SubTaskInfo *taskA = [_task.subTaskList objectAtIndex:taskNum - 1];
                    SubTaskInfo *taskB = [_task.subTaskList objectAtIndex:taskNum];
                    // 中间有空隙可选
                    if ((taskB.minLine - taskA.maxLine) > 1.5)
                    {
                        _segSlider.currentMaxValue = lineCount;
                        _segSlider.currentMinValue = 1;
                        _segSlider.currentMaxValue = taskB.minLine - 1;
                        _segSlider.currentMinValue = taskA.maxLine + 1;
                        [self setSegSliderCanEdit:YES];
                        break;
                    }
                }
            }
            
        }
        
    }
    
}


/*
 设置区间范围
 */
- (void) setSliderScrollRange:(int)lineCount
{
    // 计算单位长度
    float unitWidth = (_segSlider.frame.size.width - 2 * _segSlider.progressLeftSpace) / (lineCount);
    
    int minRange = _segSlider.currentMinValue;
    int maxRange = _segSlider.currentMaxValue;
    
    // 编辑状态
    if (_selectTask)
    {
        // 在最左侧
        if ([_task.subTaskList firstObject] == _selectTask)
        {
            minRange = 1;
        }
        else
        {
            int index = [_task.subTaskList indexOfObject:_selectTask];
            minRange = ((SubTaskInfo *)[_task.subTaskList objectAtIndex:index - 1]).maxLine + 1;
        }
        
        // 在最右侧
        if ([_task.subTaskList lastObject] == _selectTask)
        {
            maxRange = lineCount;
        }
        else
        {
            int index = [_task.subTaskList indexOfObject:_selectTask];
            maxRange = ((SubTaskInfo *)[_task.subTaskList objectAtIndex:index + 1]).minLine - 1;
        }
    }
    // 新建状态
    else
    {
        
    }
    
    _segSlider.minRange = (minRange - 1 + 0.01) * unitWidth;
    
    if (lineCount - maxRange - 1 + 0.01 > 0)
    {
        _segSlider.maxRange = (lineCount - maxRange - 1 + 0.01) * unitWidth;
    }
    else
    {
        _segSlider.maxRange = 0;
    }
    
}


/*
 控制已选中区域显示
 */
- (void) setSelectedView:(int)lineCount
{
    // 计算单位长度
    float unitWidth = (_segSlider.frame.size.width - 2 * _segSlider.progressLeftSpace) / (lineCount);
    
    
    for (UIView *obj in _segViewArray)
    {
        [obj removeFromSuperview];
    }
    [_segViewArray removeAllObjects];
    
    if (_task.subTaskList && [_task.subTaskList count] > 0)
    {
        for (int i = 0; i < [_task.subTaskList count]; i++)
        {
            SubTaskInfo *taskInfo = [_task.subTaskList objectAtIndex:i];
            if (taskInfo.isEdit)
            {
                
            }
            else
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake((taskInfo.minLine - 1) * unitWidth, 0, unitWidth * (taskInfo.maxLine - taskInfo.minLine + 1), SLIDER_HEIGHT)];
                [view setBackgroundColor:ROUTE_SELECTED];
                view.userInteractionEnabled = YES;
                [_segViewArray addObject:view];
                
                [_segSlider.progressView addSubview:view];
            }
        }
    }
    
}

- (void) setSegSliderCanEdit:(BOOL)isCan
{
    _joinTaskGroupBtn.enabled = isCan;
    [_segSlider canEdit:isCan];
}


#pragma mark - 点击响应
/**
 展开任务组
 */
- (void) clickTaskGroup
{
    [self.view addSubview:_taskChooseView];
}


/**
 加入任务组
 */
- (void) clickJoinTaskGroup
{
    __block SubTaskInfo *taskInfo = [[SubTaskInfo alloc] init];
    
    taskInfo.minLine = _segSlider.currentMinValue;
    taskInfo.maxLine = _segSlider.currentMaxValue;

    
    [_task.subTaskList addObject:taskInfo];
    
    
    // 对_task.subTaskList的minLine值进行排序(冒泡-有更优的排序方式，但是由于数量级很小就用冒泡了)
    for (int i = [_task.subTaskList count] - 1; i > 0; i--)
    {
        for (int j = i - 1; j >= 0; j--)
        {
            SubTaskInfo *taskInfoA = [_task.subTaskList objectAtIndex:j];
            SubTaskInfo *taskInfoB = [_task.subTaskList objectAtIndex:i];
            if (taskInfoA.minLine > taskInfoB.minLine)
            {
                [_task.subTaskList exchangeObjectAtIndex:j withObjectAtIndex:i];
                break;
            }
        }
    }
    
    // 已加入任务组成功（刷新列表）
    [_taskChooseView.tableView reloadData];
    
    // 刷新滑杆
    [self refreshSegmentationSlider:SEGSLIDER_RANGEMAX];

}


/**
 编辑任务组
 */
- (IBAction)clickEditSeg:(id)sender
{
    // 确定响应的数据
    UIButton *editSegBtn = sender;
    int row = editSegBtn.tag - SEG_TASK_BTNTAG;
    SubTaskInfo *taskInfo = [_task.subTaskList objectAtIndex:row];
    
    // 已经选中，再点不响应
    if (taskInfo.isEdit)
    {
        return;
    }
    
    
    // 将对应数据（isEdit）设置为编辑状态
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
    for (int taskNum = 0; taskNum < [_task.subTaskList count]; taskNum++)
    {
        SubTaskInfo *task = [_task.subTaskList objectAtIndex:taskNum];
        if (task.isEdit)
        {
            // 将原子任务的编辑状态取消
            task.isEdit = NO;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:taskNum inSection:0];
            [indexPathArray addObject:indexPath];
        }
    }
    // 设置新的子任务编辑状态
    [self setEditStatus:taskInfo];
    
    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:row inSection:0];
    [indexPathArray addObject:indexPathNew];
    
    [_taskChooseView.tableView beginUpdates];
    [_taskChooseView.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [_taskChooseView.tableView endUpdates];
    
}


/**
 取消编辑
 */
- (void) clickCancelEdit
{
    [self setEditStatus:nil];
    // 刷新列表
    [_taskChooseView.tableView reloadData];
}


/**
 保存编辑
 */
- (void) clickSave
{
    
    _selectTask.maxLine = _segSlider.currentMaxValue;
    _selectTask.minLine = _segSlider.currentMinValue;
    
    
    
    // 对_task.subTaskList的minLine值进行排序(冒泡-有更优的排序方式，但是由于数量级很小就用冒泡了)
    for (int i = [_task.subTaskList count] - 1; i > 0; i--)
    {
        for (int j = i - 1; j >= 0; j--)
        {
            SubTaskInfo *taskInfoA = [_task.subTaskList objectAtIndex:j];
            SubTaskInfo *taskInfoB = [_task.subTaskList objectAtIndex:i];
            if (taskInfoA.minLine > taskInfoB.minLine)
            {
                [_task.subTaskList exchangeObjectAtIndex:j withObjectAtIndex:i];
                break;
            }
        }
    }
    
    [self setEditStatus:nil];
    
    // 刷新列表
    [_taskChooseView.tableView reloadData];
    

}




/**
 删除子任务
 */
- (void) clickDelete
{
    [_task.subTaskList removeObject:_selectTask];
    
    [self setEditStatus:nil];
    
    // 刷新列表
    [_taskChooseView.tableView reloadData];
    
}

#pragma mark - 状态处理
/**
 设置当前子任务状态
 
 @param task 子任务--为nil表示为新建状态
 */
- (void) setEditStatus:(SubTaskInfo *)task
{
    // 编辑状态
    if (task)
    {
        task.isEdit = YES;
    }
    // 非编辑状态
    else
    {
        if (_selectTask)
        {
            _selectTask.isEdit = NO;
        }
    }
    
    _selectTask = task;
    
    // 刷新滑杆
    [self refreshSegmentationSlider:SEGSLIDER_RANGEMAX];
    
    
    // 按钮
    if (_selectTask)
    {
        _joinTaskGroupBtn.hidden = YES;   // 加入任务组按钮
        
        _deleteTaskBtn.hidden = NO;
        _cancelEditTaskBtn.hidden = NO;  // 取消编辑子任务
        _saveTaskBtn.hidden = NO;        // 保存子任务
    }
    else
    {
        _joinTaskGroupBtn.hidden = NO;   // 加入任务组按钮
        
        _deleteTaskBtn.hidden = YES;
        _cancelEditTaskBtn.hidden = YES;  // 取消编辑子任务
        _saveTaskBtn.hidden = YES;        // 保存子任务
    }
    
}


#pragma mark - 功能方法
- (UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*) imageWithColor:(UIColor*)color size:(CGSize) size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_task.subTaskList count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskSegmentationTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskSegmentationTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.editSegBtn.tag = SEG_TASK_BTNTAG + indexPath.row;
    [cell.editSegBtn addTarget:self action:@selector(clickEditSeg:) forControlEvents:UIControlEventTouchUpInside];
    
    
    SubTaskInfo *data = [_task.subTaskList objectAtIndex:indexPath.row];
    [cell setCellByData:data];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
