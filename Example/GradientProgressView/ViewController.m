//
//  ViewController.m
//  GradientProgressView
//
//  Created by Nick Jensen on 11/22/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import "ViewController.h"
#import "GradientProgressView.h"
#import "ProgressBar.h"
#import "StatisticsRequest.h"

#define kWebAddress @"http://aws.ey-tec.com/cc/service/statistics"
#define kHttpBody @"{\"id\":\"2\",\"method\":\"getUserStatistics\",\"params\":[\"su\"],\"jsonrpc\":\"2.0\"}"

@interface ViewController()
-(void)prepareForStateChanges;

@end


@implementation ViewController
-(void) dealloc
{
    [_progressBar release];
    [_progressView release];
    [super dealloc];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //CGRect frame = CGRectMake(0, 0, CGRectGetWidth([[self view] bounds]), CGRectGetHeight([[self view] bounds]));
    //GradientProgressView* progressView = [[[GradientProgressView alloc] initWithFrame:frame] autorelease];
    //ProgressBar* barView= [[[ProgressBar alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 10) strokeWidth:12.0f color:[UIColor redColor]] autorelease];
                           
    
    
    //self.progressBar=barView;
    //self.progressView=progressView;
    
    //[self.view setBackgroundColor:[UIColor yellowColor]];
    //[self.view addSubview:progressView];
    //[self.view addSubview:barView];
    
    
    [self prepareForStateChanges];
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self setupConstraintsInView];
    [self simulateProgress];
}
/*
- (void)simulateProgress
{
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
        CGFloat progress  = [self.progressView percent] + increment;
        [self.progressView setPercent:progress animated:YES];
        [self.progressBar setPercent:progress animated:YES];
        
        if (progress < 1.0)
        {
            
            [self simulateProgress];
        }
        else
            [self.progressBar deleteAnimatedProgress];
    });
}
 */
- (void)simulateProgress
{
    
    //double delayInSeconds = 2.0;
    //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
        //CGFloat progress  = [self.progressView percent] + increment;
        [self.progressView setPercent:0.9 animated:YES];
        [self.progressBar setPercent:0.9 animated:YES];
        
        //if (progress < 1.0)
        //{
            
        //    [self simulateProgress];
        //}
        //else
        //    [self.progressBar deleteAnimatedProgress];
    //});
}


-(void)prepareForStateChanges
{
    //首先声明app
    UIApplication * app= [UIApplication sharedApplication];
    //接下来四行是新的功能，能检查设备是否支持后台，老系统和一代的backgroundSupported = NO;支持的自然就是YES
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    
    //如果设备不支持后台，那么就继续使用applicationWillTerminate:
    if(backgroundSupported == NO)
    {
        [[NSNotificationCenter defaultCenter ] addObserver:self
                                                  selector:@selector(applicationWillTerminate:)
                                                      name:UIApplicationWillTerminateNotification
                                                    object:app];
    }
    //如果支持
    else
    {
        //这个新的UIApplicationWillResignActiveNotification就是在用户按下home键时的通知，建议用它的selector去保存数据，能防止用户直接在任务管理器里强制退出
        [[NSNotificationCenter defaultCenter ] addObserver:self
                                                  selector:@selector(applicationDidEnterBackground:)
                                                      name:UIApplicationWillResignActiveNotification
                                                    object:app];
        
        //这个UIApplicationWillEnterForegroundNotification是app在切回前台时的通知
        [[NSNotificationCenter defaultCenter ] addObserver:self
                                                  selector:@selector(applicationDidBecomeActive:)
                                                      name:UIApplicationWillEnterForegroundNotification
                                                    object:app];
    }

}
-(void) applicationDidEnterBackground:(NSNotification*)notification
{
    NSLog(@"enter applicationDidEnterBackground ");
    [self.progressBar deleteAnimatedProgress];
}

-(void)applicationDidBecomeActive:(NSNotification*)notification
{
    NSLog(@"enter applicationDidBecomeActive ");

    
}

-(void)setupConstraintsInView
{
    self.progressBar=[[[ProgressBar alloc] init] autorelease];
    self.progressView= [[[GradientProgressView alloc] init] autorelease];
    [self.view addSubview:self.progressBar];
    [self.view addSubview:self.progressView];
    
    [self.progressBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *tmpConstraints;
    NSDictionary *views= @{ @"tableView":self.progressBar,@"mapView":self.progressView};
    tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[tableView]-100-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tmpConstraints];
    tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[mapView]-50-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tmpConstraints];
    tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[mapView(==tableView)]-0-[tableView]-20-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tmpConstraints];

    
    
}



@end
