//
//  CustomLaunchController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/15.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "CustomLaunchController.h"

@interface CustomLaunchController ()

@end

@implementation CustomLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openPlayHandler:(id)sender {
    self.openPlayButton.userInteractionEnabled = NO;
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(superView);
        make.leading.mas_equalTo(-CGRectGetWidth(superView.frame));
        make.width.equalTo(superView);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [superView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        self.hasRemoved = YES;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
