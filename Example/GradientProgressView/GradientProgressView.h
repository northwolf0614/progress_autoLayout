//
//  GradientProgressView.h
//  GradientProgressView
//
//  Created by Nick Jensen on 11/22/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface GradientProgressView : UIView
{
}

-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
-(void)deleteAnimatedProgress;
@end
