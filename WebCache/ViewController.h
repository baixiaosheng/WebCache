//
//  ViewController.h
//  WebCache
//
//  Created by 张帅 on 13-5-29.
//  Copyright (c) 2013年 SHX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MyURLCache.h"

@interface ViewController : UIViewController
@property(nonatomic,strong)NSString *myUrl;
@property(nonatomic,strong)MBProgressHUD *HUD;

@end
