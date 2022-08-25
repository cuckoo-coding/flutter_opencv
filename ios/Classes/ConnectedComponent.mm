#import "ConnectedComponent.h"

@implementation ConnectedComponent


+ (void)process:(FlutterStandardTypedData *)data connectivity:(int)connectivity ltype:(int)ltype result:(FlutterResult)result{
    
    result(connectedComponentsWithStats(data, connectivity, ltype));
    
}

NSArray<NSData*>* connectedComponentsWithStats(FlutterStandardTypedData * data, int connectivity, int ltype){
    NSMutableArray *result = [NSMutableArray array];

    CGColorSpaceRef colorSpace;
    const char * suffix;

    std::vector<uint8_t> fileData;
   
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
        
        src = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
        CGContextRef contextRef = CGBitmapContextCreate(src.data,                 // Pointer to  data
                                                         cols,                       // Width of bitmap
                                                         rows,                       // Height of bitmap
                                                         8,                          // Bits per component
                                                         src.step[0],              // Bytes per row
                                                         colorSpace,                 // Colorspace
                                                         kCGImageAlphaNone); // Bitmap info flags
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image);
        CGContextRelease(contextRef);
        CFRelease(image);
        CFRelease(image_provider);
        CFRelease(file_data_ref);
    } else {
        src = cv::Mat();
    }
  
    if(src.empty()) {
        return result;
    } else {
        cv::Mat labels;
        cv::Mat stats;
        cv::Mat centroids;
        int res = cv::connectedComponentsWithStats(src, labels, stats, centroids);

        NSLog(@"Res: %d", res);

        NSData *labelsData = [NSData dataWithBytes:labels.data length:labels.elemSize()*labels.total()];
        NSData *statsData = [NSData dataWithBytes:stats.data length:stats.elemSize()*stats.total()];
        NSData *centroidsData = [NSData dataWithBytes:centroids.data length:centroids.elemSize()*centroids.total()];

        [result addObject: [NSData dataWithBytes:labels.data length:labels.elemSize()*labels.total()]];
        [result addObject: [NSData dataWithBytes:stats.data length:stats.elemSize()*stats.total()]];
        [result addObject: [NSData dataWithBytes:centroids.data length:centroids.elemSize()*centroids.total()]];
    }
    
    return result;
}


@end
