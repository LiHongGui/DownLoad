//
//  ViewController.m
//  DownLoad
//
//  Created by lihonggui on 2017/1/9.
//  Copyright © 2017年 lihonggui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong) NSMutableData *currentData;
@property(nonatomic,assign) long long sumData;
@property(nonatomic,assign) long long current;
@property(nonatomic,strong) NSString *filePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
      NSLog(@"开始下载");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //创建请求地址
    NSString *string = @"http://localhost/01-URLConnection.avi";
    NSURL *url = [NSURL URLWithString:string];
    //创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //发送请求
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    //判断  文件存在就删除
    [[NSFileManager defaultManager]removeItemAtPath:self.filePath error:nil];
    
}
#pragma mark
#pragma mark-开始下载
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.current = 0;
    self.sumData = response.expectedContentLength;
    //保存文件路径
    self.filePath = [@"/Users/lihongguilihonggui/Desktop/"stringByAppendingString:response.suggestedFilename];
}
#pragma mark
#pragma mark-接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.current += data.length;

    [self writeToFileWith:data];
    NSLog(@"%0.2f",(float)self.current/self.sumData*100);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完成");
}

-(void)writeToFileWith:(NSData *)data
{
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    
    if (handle == nil) {
        [data writeToFile:self.filePath atomically:YES];
    }else {
        //就继续追加----直至写入完毕
        [handle seekToEndOfFile];
        [handle writeData:data];
        [handle closeFile];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
#warning 先下载后,最后在写入磁盘,回事内存增大
/*
 -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
 {
 
 //创建请求地址
 NSString *string = @"http://localhost/01-URLConnection.avi";
 NSURL *url = [NSURL URLWithString:string];
 //创建网络请求
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 //发送请求
 NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
 
 
 
 [connection start];
 
 }
 #pragma mark
 #pragma mark-接受服务器相应
 -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 {
 self.current = 0;
 self.sumData = response.expectedContentLength;
 NSLog(@"%lld",self.sumData);
 
 //保存文件路径
 self.filePath = [@"/Users/lihongguilihonggui/Desktop/"stringByAppendingString:response.suggestedFilename];
 
 }
 -(NSMutableData *)currentData
 {
 if (_currentData == nil) {
 _currentData = [NSMutableData data];
 }
 return _currentData;
 }
 #pragma mark
 #pragma mark-接受数据
 -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
 {
 
 self.current += data.length;
 
 //拼接数据
 [self.currentData appendData:data];
 NSLog(@"%f",(float)self.current/self.sumData*100);
 }
 #pragma mark
 #pragma mark-下载完成后,加载数据
 -(void)connectionDidFinishLoading:(NSURLConnection *)connection
 {
 //写入磁盘
 [self.currentData writeToFile:self.filePath atomically:YES];
 NSLog(@"%@",connection);
 NSLog(@"下载完毕");
 self.currentData = nil;
 
 }
 -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
 {
 NSLog(@"下载错误");
 }

 */

@end
