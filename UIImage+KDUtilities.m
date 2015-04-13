//
//  UIImage+ProportionalFill.m
//

#import "UIImage+KDUtilities.h"

@implementation UIImage (KDUtilities)

- (UIImage *)KD_imageByCroppedToSquare:(CGFloat)fitSize {
    float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth;
    float targetHeight;
	
    if (sourceWidth > sourceHeight) {
        targetHeight = fitSize;
        targetWidth = targetHeight / sourceHeight * sourceWidth;
    } else if (sourceWidth < sourceHeight) {
        targetWidth = fitSize;
        targetHeight = targetWidth / sourceWidth * sourceHeight;
    } else {
        targetWidth = fitSize;
        targetHeight = fitSize;
    }

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(fitSize, fitSize), NO, self.scale);
    if (sourceWidth > sourceHeight) {
        [self drawInRect:CGRectMake(- (targetWidth - fitSize) / 2.0f, 0, targetWidth, targetHeight)];
    } else if (sourceWidth > sourceHeight) {
        [self drawInRect:CGRectMake(0, - (targetHeight - fitSize) / 2.0f, targetWidth, targetHeight)];
    } else {
        [self drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)KD_maskImageWithColor:(UIColor *)maskColor {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, rect);

    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return maskImage;
}

+ (UIImage *)KD_imageWithColor:(UIColor *)color {
    return [self KD_imageWithColor:color andSize:CGSizeMake(1, 1)];
}

+ (UIImage *)KD_imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retval;
}


@end