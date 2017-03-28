
git https://github.com/objectiv/HRLaunchAdverView.git
# HRLaunchAdverView
一个广告的控件

/**
HR_初始化一个广告控件

@param superView 承载广告的视图
@param imageStr 图片源 支持URL、本地图片
@param clickAction 操作回调
*/
- (instancetype)initWithSuperView:(UIView *)superView imageStr:(NSString *)imageStr clickAction:(ClickActionBlcok)clickAction;


/**
HR_手动清除缓存
*/
- (BOOL)hr_removeLocalFile;




## 使用

<pre><code>HRLaunchAdverView *adver = [[HRLaunchAdverView alloc] initWithSuperView:self.window
imageStr:@"http://pic.ffpic.com/files/2013/0805/sj0822rrw05_s.jpg"
clickAction:^(NSInteger idx) {
switch (idx) {
case 1:
{
// 点击了广告
}
break;
case 2:
{
// 点击了跳过
}
break;
case 3:
{
// 自动跳过
}
break;

default:
break;
}
}];
[adver launch];</code></pre>
..
