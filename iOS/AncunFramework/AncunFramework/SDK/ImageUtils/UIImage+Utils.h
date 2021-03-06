//
//  UIImage+Utils.h
//  Ume
//
//  Created by Start on 15/6/15.
//  Copyright (c) 2015年 Ancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Utils)

- (UIImage *)scaleImagetoScale:(float)scaleSize;
- (UIImage *)imageByScalingToMaxSize;
- (UIImage *)imageByScalingAndCroppingForSourceImageTargetSize:(CGSize)targetSize;
//- (UIImage *)cutCenterImageSize:(CGSize)size;
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)buildScreenshotWithView:(UIView*)view Size:(CGSize)size;
- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize;

@end