//  --- 积累是必不可少的 ---
//
//  HRLaunchAdverView.h
//  AdvertisingDemo
//
//  Created by 王凯 on 2017/3/28.
//  Copyright © 2017年 王凯. All rights reserved.
//
//  起得早BUG少 - UIView
//  --------------------



#import <UIKit/UIKit.h>


typedef void (^ClickActionBlcok)(NSInteger idx);

@interface HRLaunchAdverView : UIView


/** Description:倒计时总时长,默认6秒 */
@property (assign, nonatomic) NSInteger adTime;

/** Description:点击操作 */
@property (copy, nonatomic) ClickActionBlcok clickAction;



/**
 HR_初始化一个广告控件

 @param superView 承载广告的视图
 @param imageStr 图片源 支持URL、本地图片
 @param clickAction 操作回调
 */
- (instancetype)initWithSuperView:(UIView *)superView
                         imageStr:(NSString *)imageStr
                      clickAction:(ClickActionBlcok)clickAction;


/**
 HR_手动清除缓存
 */
- (BOOL)hr_removeLocalFile;

@end
