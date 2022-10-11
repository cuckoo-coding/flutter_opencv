#ifdef __cplusplus
#undef NO
#import <opencv2/opencv.hpp>
#import <opencv2/objdetect.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/core.hpp>
#endif
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface HaarObjectDetection : NSObject

+ (void)process:(FlutterStandardTypedData *)data cascadePath:(NSString *)cascadePath minNeighbors:(int)minNeighbors result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
