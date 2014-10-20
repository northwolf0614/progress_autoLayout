//
//  ProgressBar.m


#import "ProgressBar.h"
#import "Definations.h"
@interface ProgressBar()
@property(nonatomic,assign) CGFloat percent;
@property(nonatomic,retain) CAShapeLayer* progressLayer;
@property(nonatomic,retain) CALayer* animationLayer;
@property(nonatomic,retain) CAShapeLayer* backgroundLayer;
@end

@implementation ProgressBar
-(void)dealloc
{
    //[_trackLayer release];
    [_progressLayer release];
    //[_strokeColor release];
    [_animationLayer release];
    [_backgroundLayer release];
    [super dealloc];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.animationLayer.frame =self.bounds;
    //setup the path
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat radius= self.animationLayer.frame.size.width>self.animationLayer.frame.size.height? self.animationLayer.frame.size.height/2:self.animationLayer.frame.size.width/2;
    radius-=kcProgress_Line_Width/2;
    [circlePath addArcWithCenter:CGPointMake(CGRectGetMidX(self.animationLayer.bounds), CGRectGetMidY(self.animationLayer.bounds)) radius: radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    //setup the background layer
    self.backgroundLayer.frame=self.animationLayer.bounds;
    self.backgroundLayer.path = circlePath.CGPath;
    self.backgroundLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    self.backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
    self.backgroundLayer.lineWidth = kcTrack_LineE_Width;
    //setup the progress layer
    self.progressLayer.frame=self.animationLayer.bounds;
    self.progressLayer.strokeColor = [[UIColor blueColor] CGColor];
    self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
    self.progressLayer.lineWidth=kcProgress_Line_Width;
    self.progressLayer.strokeEnd=0.f;//use this property to set up the default value
    self.progressLayer.path=circlePath.CGPath;
}
- (id)init
{
    self= [super init];
    if (self) {
        _percent=0;
        self.animationLayer= [CALayer layer];
        [self.layer addSublayer:self.animationLayer];
        
        self.backgroundLayer = [CAShapeLayer layer];
        self.progressLayer = [CAShapeLayer layer];
        [self.animationLayer addSublayer:self.backgroundLayer];
        [self.animationLayer addSublayer:self.progressLayer];

    }
    return  self;
    
}

-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    NSLog(@"current percent is %f",percent);

    if (animated)
    {
        CABasicAnimation *animation;
        animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//this place the input parameter must be strokeEnd
        [animation setFromValue:[NSNumber numberWithFloat:self.percent] ];
        [animation setToValue:[NSNumber numberWithFloat:percent]];
        [animation setDuration:kcAnimationTime];
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:kCAFillModeForwards];//must set up this property, otherwise this class does not work properly
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation setDelegate:self];
        [animation setValue:[NSString stringWithFormat:@"%f", percent] forKey:@"animation"];
        // Add the animation to our layer
        [[self progressLayer] addAnimation:animation forKey:nil];
        
        
    }
    
    _percent=percent;

}
-(void)deleteAnimatedProgress
{
    [CATransaction begin];
    [self.animationLayer removeAllAnimations];//delete the animations relevant to this layer
    [self.animationLayer removeFromSuperlayer];//delete the layer, then the layer will disappear
    [CATransaction commit];
}
#pragma CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    
    NSLog(@"this is animationID=%s stopping",[[animation valueForKey:@"animation"] UTF8String]);
}
-(void)animationDidStart:(CAAnimation *)animation
{
    NSLog(@"this is animationID=%s starting",[[animation valueForKey:@"animation"] UTF8String]);
    
}
@end
