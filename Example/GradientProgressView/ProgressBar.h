#import <UIKit/UIKit.h>

@interface ProgressBar : UIView

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

//-(id)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth color: (UIColor*) strokeColor;
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
-(void)deleteAnimatedProgress;


@end
