//  --- 积累是必不可少的 ---
//
//  HRLaunchAdverView.m
//  AdvertisingDemo
//
//  Created by 王凯 on 2017/3/28.
//  Copyright © 2017年 王凯. All rights reserved.
//
//  起得早BUG少 - UIView
//  --------------------

#import "HRLaunchAdverView.h"
#import "UIImageView+WebCache.h"


static NSString *const LOCAL_IMG_URL = @"LOCAL_IMG_URL";

@interface HRLaunchAdverView () {
    // 是否为本地图片
    BOOL _isLocalImg;
    // 缓存后的图片
    UIImage *_localImg;
    // 倒计时timer
    NSTimer *_countDownTimer;
    // 操作类型 1：点击了广告
    // 操作类型 2：跳过
    // 操作类型 3：自动跳过
    NSInteger _idx;
}


/** Description:广告图片 */
@property (nonatomic, strong) UIImageView *adImgView;

/** Description:跳过按钮 可自定义 */
@property (nonatomic, strong) UIButton *skipBtn;

/** Description:本地图片名字 */
@property (nonatomic, strong) NSString *localAdImgName;

/** Description:网络图片URL */
@property (nonatomic, strong) NSString *imgUrl;

/** Description:承载视图 */
@property (nonatomic, strong) UIView *superView;

@end

@implementation HRLaunchAdverView



- (instancetype)initWithSuperView:(UIView *)superView
                         imageStr:(NSString *)imageStr
                      clickAction:(ClickActionBlcok)clickAction {
    self = [super init];
    if(self) {
        
        if([imageStr hasPrefix:@"http"] || [imageStr hasPrefix:@"HTTP"]) {
            _imgUrl = imageStr;
            _isLocalImg = NO;
        }else{
            _localAdImgName = imageStr;
            _isLocalImg = YES;
        }
        _clickAction = clickAction;
        _superView = superView;
        [self configSelf];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)adImgView {
    if(!_adImgView) {
        _adImgView = [[UIImageView alloc] init];
        [_adImgView setFrame:hr_screen_bounds()];
        [_adImgView setUserInteractionEnabled:YES];
    }
    return _adImgView;
}

- (UIButton *)skipBtn {
    if(!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setFrame:hr_skipBtn_frame()];
        [_skipBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_skipBtn setBackgroundColor:[UIColor grayColor]];
        [_skipBtn addTarget:self action:@selector(touchSkipAction:) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.cornerRadius = 15;
    }
    return _skipBtn;
}
// 配置数据
- (void)configData {
    _adTime = 5;
    [self onTimier];
    [self addGestureForAdImgView];
}
// 配置
- (void)configSelf {
    [self setBackgroundColor:[UIColor redColor]];
    [self setFrame:hr_screen_bounds()];
    [self setUserInteractionEnabled:YES];
    [self configData];
    [self configUI];
}

// 配置UI
- (void)configUI {
    [self.skipBtn setTitle:@"5s | 跳过" forState:UIControlStateNormal];
    [self addSubview:self.adImgView];
    [self addSubview:self.skipBtn];
    [self.superView addSubview:self];
    // 配置图片
    [self configImg];
    
}
// 配置图片
- (void)configImg {
    
    __weak typeof(self)weakSelf = self;
    if(_isLocalImg) {
        [self.adImgView setImage:[UIImage imageNamed:_localAdImgName]];
    }else{
        // 加载的图片是否为上一次图片 YES:直接加载本地文件，反之重复第一次
        if([_imgUrl isEqualToString:self.localImgUrl]) {
            [self.adImgView setImage:[UIImage imageWithData:[self readLocalImg]]];
        }else{
            [self.adImgView sd_setImageWithURL:[self imageStrToUrl:_imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                // 清除上一次缓存的内容
                [weakSelf hr_removeLocalFile];
                _localImg = image;
                [weakSelf.adImgView setImage:image];
                // 图片加载完成 - 缓存到本地
                BOOL result = [weakSelf writeFile];
                if(result) {
                    // 如果写入成功 - 将当前URL存入本地
                    [weakSelf saveUrl];
                }
            }];
        }
    }
}

// 转换URL
- (NSURL *)imageStrToUrl:(NSString *)str {
    return [NSURL URLWithString:str];
}

// Document 路径
- (NSString *)findDocumentpath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *value = paths.lastObject;
    return value;
}
// 本地图片路径
- (NSString *)localFilePath {
    return [NSString stringWithFormat:@"%@_image.data", [self findDocumentpath]];
    
}
// 把文件写入本地
- (BOOL)writeFile {
    return [UIImagePNGRepresentation(_localImg) writeToFile:[self localFilePath] atomically:YES];
}
// 读取本地文件
- (NSData *)readLocalImg {
    return [NSData dataWithContentsOfFile:[self localFilePath]];
}
// 获取上一次加载的URL
- (NSString *)localImgUrl {
    return [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_IMG_URL];
}
- (void)saveUrl {
    [[NSUserDefaults standardUserDefaults] setObject:_imgUrl forKey:LOCAL_IMG_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 删除本地文件
- (BOOL)hr_removeLocalFile {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOCAL_IMG_URL];
    return [[NSFileManager defaultManager] removeItemAtPath:[self localFilePath] error:nil];
}

// 给图片添加手势
- (void)addGestureForAdImgView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
    [self.adImgView addGestureRecognizer:tap];
}
// 手势事件
- (void)touchTap:(UITapGestureRecognizer *)tap {
    _idx = 1;
    [self startcloseAnimation];
}
// 跳过事件
- (void)touchSkipAction:(UIButton *)btn {
    _idx = 2;
    [self startcloseAnimation];
    
}
// 开启定时器
- (void)onTimier {
    __weak typeof(self)weakSelf = self;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf.skipBtn setTitle:[NSString stringWithFormat:@"%lds | 跳过",_adTime--] forState:UIControlStateNormal];
        if(_adTime == -1) {
            [timer invalidate];
            _idx = 3;
            [weakSelf startcloseAnimation];
        }
    }];
}
#pragma mark - 开启关闭动画
- (void)startcloseAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.3];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.adImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnimation.duration
                                     target:self
                                   selector:@selector(closeAddImgAnimation)
                                   userInfo:nil
                                    repeats:NO];
    
}
#pragma mark - 关闭动画完成时处理事件
-(void)closeAddImgAnimation {
    if(self.clickAction) {
        self.clickAction(_idx);
    }
    [self removeFromSuperview];
    [_countDownTimer invalidate];
}


#pragma mark - 尺寸

CGRect hr_skipBtn_frame () {
    return CGRectMake(hr_screen_width()-100, 50, 80, 30);
}
CGRect hr_screen_bounds () {
    return [UIScreen mainScreen].bounds;
}
CGSize hr_screen_size () {
    return [UIScreen mainScreen].bounds.size;
}
CGPoint hr_screen_point () {
    return [UIScreen mainScreen].bounds.origin;
}
CGFloat hr_screen_width () {
    return [UIScreen mainScreen].bounds.size.width;
}
CGFloat hr_screen_height () {
    return [UIScreen mainScreen].bounds.size.height;
}




@end
