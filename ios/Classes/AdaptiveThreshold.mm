#import "AdaptiveThreshold.h"

@implementation AdaptiveThreshold

+ (void)process:(FlutterStandardTypedData *)data maxValue: (double)maxValue adaptiveMethod: (int) adaptiveMethod thresholdType: (int) thresholdType blockSize: (int) blockSize constantValue: (int) constantValue result: (FlutterResult) result{
    
    result(adaptiveThreshold(data, maxValue, adaptiveMethod, thresholdType, blockSize, constantValue));
}

FlutterStandardTypedData * adaptiveThreshold(FlutterStandardTypedData * data, double maxValue, int adaptiveMethod, int thresholdType, int blockSize, double constantValue) {
    

    CGColorSpaceRef colorSpace;
    const char * suffix;
    std::vector<uint8_t> fileData;    
    FlutterStandardTypedData* result;
      
    cv::Mat src;
    
    
    UInt8* valor1 = (UInt8*) data.data.bytes;
    
    int size = data.elementCount;
    

    CFDataRef file_data_ref = CFDataCreateWithBytesNoCopy(NULL, valor1,
                                                          size,
                                                          kCFAllocatorNull);
    
    CGDataProviderRef image_provider = CGDataProviderCreateWithCFData(file_data_ref);
    
    CGImageRef image = nullptr;
    
    image = CGImageCreateWithPNGDataProvider(image_provider, NULL, true,
                                                 kCGRenderingIntentDefault);
    suffix = (char*)".png";
    if (image == nil) {
        image = CGImageCreateWithJPEGDataProvider(image_provider, NULL, true,
                                                  kCGRenderingIntentDefault);
        suffix = (char*)".jpg";
    }
    
    if (image == nil) {
        suffix = (char*)"otro";
    }
    
    if(!(strcasecmp(suffix, "otro") == 0)){
        colorSpace = CGImageGetColorSpace(image);
        CGFloat cols = CGImageGetWidth(image);
        CGFloat rows = CGImageGetHeight(image);
        
        src = cv::Mat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
        CGContextRef contextRef = CGBitmapContextCreate(src.data,                 // Pointer to  data
                                                         cols,                       // Width of bitmap
                                                         rows,                       // Height of bitmap
                                                         8,                          // Bits per component
                                                         src.step[0],              // Bytes per row
                                                         colorSpace,                 // Colorspace
                                                         kCGImageAlphaNoneSkipLast |
                                                         kCGBitmapByteOrderDefault); // Bitmap info flags
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image);
        CGContextRelease(contextRef);
        CFRelease(image);
        CFRelease(image_provider);
        CFRelease(file_data_ref);
    } else {
        src = cv::Mat();
    }
    
    
    //***********
    
    if(src.empty()){
        result = [FlutterStandardTypedData typedDataWithBytes: data.data];
    } else {
        
        NSData * response;
        if(blockSize % 2 == 1){
            cv::Mat dst;
            cv::Mat srcGRAY;
            cv::cvtColor(src, srcGRAY, cv::COLOR_BGRA2GRAY);
            cv::adaptiveThreshold(srcGRAY, dst, maxValue, adaptiveMethod, thresholdType, blockSize, constantValue);
            
            NSData *data = [NSData dataWithBytes:dst.data length:dst.elemSize()*dst.total()];
            
            if (dst.elemSize() == 1) {
                  colorSpace = CGColorSpaceCreateDeviceGray();
              } else {
                  colorSpace = CGColorSpaceCreateDeviceRGB();
              }
              CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

              CGImageRef imageRef = CGImageCreate(dst.cols,                                 //width
                                                 dst.rows,                                 //height
                                                 8,                                          //bits per component
                                                 8 * dst.elemSize(),                       //bits per pixel
                                                 dst.step[0],                            //bytesPerRow
                                                 colorSpace,                                 //colorspace
                                                 kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                                 provider,                                   //CGDataProviderRef
                                                 NULL,                                       //decode
                                                 false,                                      //should interpolate
                                                 kCGRenderingIntentDefault                   //intent
                                                 );

              UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
              CGImageRelease(imageRef);
              CGDataProviderRelease(provider);
              CGColorSpaceRelease(colorSpace);
            
            NSData* imgConvert;
            
            if (strcasecmp(suffix, ".png") == 0) {
                imgConvert = UIImagePNGRepresentation(finalImage);
            } else if ((strcasecmp(suffix, ".jpg") == 0) ||
                       (strcasecmp(suffix, ".jpeg") == 0)) {
                imgConvert = UIImageJPEGRepresentation(finalImage, 1);
            }
            
            response = imgConvert;
        } else {
            response = data.data;
        }
        
        result = [FlutterStandardTypedData typedDataWithBytes: response];
    }
    
    return result;
}

@end
