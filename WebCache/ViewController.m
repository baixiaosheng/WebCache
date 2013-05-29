//
//  ViewController.m
//  WebCache
//
//  Created by 张帅 on 13-5-29.
//  Copyright (c) 2013年 SHX. All rights reserved.
//

#import "ViewController.h"
#define K_UIMAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_UIMAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIWebViewDelegate>
{
    UIWebView *myWebView;
    UIView *view;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT-64)];
    myWebView.scalesPageToFit = YES;
    myWebView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
    
    MyURLCache *shareCache = [[MyURLCache alloc] initWithMemoryCapacity:1024*1024 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:shareCache];
    
    self.HUD = [[MBProgressHUD alloc]init];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [webView addSubview:view];
    
    [view addSubview:self.HUD];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.labelText = @"请稍后...";
    [self.HUD show:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"请求结束");
    [self.HUD hide:YES];
    UIView *theView = (UIView *)[webView viewWithTag:108];
    MyURLCache *sharedCache = (MyURLCache *)[NSURLCache sharedURLCache];
    [sharedCache saveInfo];
    [theView removeFromSuperview];
    theView = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [view removeFromSuperview];
    [self.HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络有误" message:@"请查看网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    /* 内存警告时移除缓存 */
    MyURLCache  *urlCache = (MyURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}

@end
