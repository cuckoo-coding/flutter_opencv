#ifdef __cplusplus
#undef NO
#import <opencv2/opencv.hpp>
#endif
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectedComponent : NSObject

+ (void)process:(FlutterStandardTypedData *)data connectivity:(int)connectivity ltype:(int)ltype result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
