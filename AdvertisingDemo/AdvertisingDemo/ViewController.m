//
//  ViewController.m
//  AdvertisingDemo
//
//  Created by 王凯 on 2017/3/28.
//  Copyright © 2017年 王凯. All rights reserved.
//

#import "ViewController.h"

#import "HRAdverViewController.h"

#import "HRLaunchAdverView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    HRLaunchAdverView *adver = [[HRLaunchAdverView alloc] initWithSuperView:self.view imageStr:@"http://img5q.duitang.com/uploads/item/201412/21/20141221014202_uS3h5.jpeg"];
//    [self.view addSubview:adver];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
    HRAdverViewController *vc=[[HRAdverViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:NO completion:^{
        //        vc.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        vc.view.backgroundColor = [UIColor clearColor];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
