#ifdef __cplusplus
#undef NO
#import <opencv2/opencv.hpp>
#endif
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BilateralFilter : NSObject

+ (void)process:(FlutterStandardTypedData *)data diameter:(int)diameter sigmaColor:(double)sigmaColor sigmaSpace:(double)sigmaSpace borderType:(int)borderType result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
