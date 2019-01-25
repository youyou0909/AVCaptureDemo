//
//  ViewController.m
//  AVCaptureDemo
//
//  Created by CLJ on 2019/1/25.
//  Copyright © 2019年 CLJ. All rights reserved.
//

#import "ViewController.h"

#import "CECaptureConfig.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(nonatomic,strong)CECaptureConfig * captureConfig;

@property(nonatomic,strong)UIImageView * showImgV;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.captureConfig startRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.captureConfig stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 自定义图片预览层
    AVCaptureVideoPreviewLayer * previewLayer =  [self.captureConfig getPreviewLayer];
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight; // 改变预览图片的横竖方向
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width,300);
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    UIButton * takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoBtn setBackgroundColor:[UIColor redColor]];
    takePhotoBtn.layer.cornerRadius = 40;
    takePhotoBtn.layer.masksToBounds = YES;
    [takePhotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    takePhotoBtn.frame = CGRectMake(Screen_Width * 0.5 - 40, 450 , 80, 80);
    [self.view addSubview:takePhotoBtn];
}

- (void)takePhoto{
    [self.captureConfig takePicture:^(UIImage * _Nonnull image) {
        // image就是拍到的照片 我们来简单展示一下
        self.showImgV.image = image;
        
        __weak ViewController * weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.showImgV.image = nil;
        });
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
  
}

- (UIImageView *)showImgV{
    if (!_showImgV) {
        _showImgV = [[UIImageView alloc] init];
        _showImgV.frame = CGRectMake(0, 350, self.view.frame.size.width, 300);
        [self.view addSubview:_showImgV];
    }
    return _showImgV;
}

- (CECaptureConfig *)captureConfig{
    if (!_captureConfig) {
        _captureConfig = [[CECaptureConfig alloc] init];
    }
    return _captureConfig;
}

@end
