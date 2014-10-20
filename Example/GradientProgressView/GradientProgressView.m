#import "GradientProgressView.h"
#import "Definations.h"

@interface GradientProgressView()
@property(nonatomic,strong) CAShapeLayer* progressLayer;
@property(nonatomic,strong) CALayer* animationLayer;
@property(nonatomic,strong) CAShapeLayer* trackLayer;
@property(nonatomic,strong) CAGradientLayer* gradientLayer;
@property(nonatomic,strong) CAGradientLayer* gradientLayer1;
@property(nonatomic,strong) CAGradientLayer* gradientLayer2;
@property(nonatomic,assign) CGFloat percent;

@end


@implementation GradientProgressView
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    
    
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
        [animation setValue:[NSString stringWithFormat:@"%f",percent] forKey:@"animation"];
        // Add the animation to our layer
        [[self progressLayer] addAnimation:animation forKey:@"animateProgress"];
    }
    
    _percent=percent;
    
    
}

-(void)deleteAnimatedProgress
{
    [CATransaction begin];
    [self.animationLayer removeAllAnimations];//delete the animations relevant to this layer
    [self.animationLayer removeFromSuperlayer];//delete the layer, then the layer will disappear
    [CATransaction commit];
    [CATransaction flush];
}
-(id)init
{
    self=[super init];
    if (self!=nil) {
        _percent=0;
        self.animationLayer= [CALayer layer];
        [self.layer addSublayer:self.animationLayer];
        
        self.trackLayer=[CAShapeLayer layer];
        [self.animationLayer addSublayer:self.trackLayer];

        
        self.progressLayer = [CAShapeLayer layer];
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer1 = [CAGradientLayer layer];
        self.gradientLayer2 = [CAGradientLayer layer];
        [self.gradientLayer addSublayer:self.gradientLayer1];
        [self.gradientLayer addSublayer:self.gradientLayer2];
        [self.animationLayer addSublayer:self.gradientLayer];
        
        
    }
    
    return self;
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.animationLayer.frame=self.bounds;
    //setup the track layer
    self.trackLayer.frame = self.animationLayer.bounds;
    self.trackLayer.fillColor = [[UIColor clearColor] CGColor];
    self.trackLayer.strokeColor = [[UIColor grayColor] CGColor];
    self.trackLayer.opacity = 0.25;
    self.trackLayer.lineCap = kCALineCapRound;//the edge of line is set as rounded instead of rectangular
    self.trackLayer.lineWidth = kcTrack_LineE_Width;
    //setup the path
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat radius= self.animationLayer.frame.size.width>self.animationLayer.frame.size.height? self.animationLayer.frame.size.height/2:self.animationLayer.frame.size.width/2;
    radius-=kcProgress_Line_Width/2;
    [circlePath addArcWithCenter:CGPointMake(CGRectGetMidX(self.animationLayer.bounds), CGRectGetMidY(self.animationLayer.bounds)) radius: radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.trackLayer.path =[circlePath CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    //setup progress layer
    self.progressLayer.frame = self.animationLayer.bounds;
    self.progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    self.progressLayer.strokeColor  = [[UIColor greenColor] CGColor];//this property must exist
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineWidth = kcProgress_Line_Width;
    self.progressLayer.path = [circlePath CGPath];
    self.progressLayer.strokeEnd = 0;
    //setup self.gradientLayer
    self.gradientLayer.frame=self.animationLayer.bounds;
    //set up gradient layer
    CGRect frame=self.gradientLayer.bounds;
    self.gradientLayer1.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width/2, frame.size.height);
    [self.gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor yellowColor] CGColor], nil]];
    [self.gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [self.gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [self.gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    self.gradientLayer2.frame = CGRectMake((frame.origin.x+frame.size.width/2), frame.origin.y, frame.size.width/2, frame.size.height);
    [self.gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
    [self.gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor yellowColor] CGColor],(id)[[UIColor blueColor] CGColor], nil]];
    [self.gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [self.gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    //set up the mask layer of self.gradientLayer as self.progressLayer
    [self.gradientLayer setMask:self.progressLayer]; //用progressLayer来截取渐变层
   
    
    
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
