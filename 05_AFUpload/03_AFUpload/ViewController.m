//
//  ViewController.m
//  03_AFUpload
//
//  Created by JayWon on 15/10/6.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIProgressView+AFNetworking.h"

@interface ViewController ()
{
    __weak IBOutlet UIProgressView *progressView2;
    __weak IBOutlet UIProgressView *progressView1;
    __weak IBOutlet UILabel *progressLabel1;
    __weak IBOutlet UILabel *progressLabel2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//1. 基于NSURLConnection
- (IBAction)uploadAction:(id)sender {
    //URL链接
    NSString *urlstring = @"https://upload.api.weibo.com/2/statuses/upload.json";
    NSDictionary *params = @{
                             @"access_token":@"2.00TSa6WDewTgPDfa63e0f0883oK2XE",
                             @"status":@"AF发送了一张图片uploadAction"
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager POST:urlstring parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"8.jpg" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:filePath];

        //添加文件数据，将上传的文件数据，添加到formData对象中
        [formData appendPartWithFileData:data name:@"pic" fileName:@"file" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        progressLabel1.text = @"上传成功";
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        progressLabel1.text = @"上传失败";
    }];
    
    //设置进度条
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
        progressView1.progress = progress;
        progressLabel1.text = [NSString stringWithFormat:@"%.2f%%", progress * 100];
    }];
    
}

//2.基于NSURLSession
- (IBAction)sessionUploadAction:(id)sender {
    //URL链接
    NSString *urlstring = @"https://upload.api.weibo.com/2/statuses/upload.json";
    NSDictionary *params = @{
                             @"access_token":@"2.00TSa6WDewTgPDfa63e0f0883oK2XE",
                             @"status":@"AF发送了一张图片sessionUploadAction"
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDataTask *uploadTask = [manager POST:urlstring parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"8.jpg" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        //添加文件数据，将上传的文件数据，添加到formData对象中
        [formData appendPartWithFileData:data name:@"pic" fileName:@"file" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        progressLabel2.text = @"上传成功";
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        progressLabel2.text = @"上传失败";
    }];
    
    
    //上传进度的监听
    [progressView2 setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask *)uploadTask animated:YES];

}

@end
