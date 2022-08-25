#import "AbsoluteDifference.h"

@implementation AbsoluteDifference

+ (void)process:(FlutterStandardTypedData *)data compare: (FlutterStandardTypedData *) compare result: (FlutterResult) result{
    
    result(absoluteDifference(data, compare));
    
}

FlutterStandardTypedData * absoluteDifference(FlutterStandardTypedData * image1, FlutterStandardTypedData * image2) {
    FlutterStandardTypedData* result;
    

    CGColorSpaceRef colorSpace;
    const char * suffix;

    std::vector<uint8_t> fileData;
   
    cv::Mat src1;
    cv::Mat src2;

    for (int i = 1;i <= 2;i++) {
        UInt8* valor1;
        int size;
        if (i == 1) {
            valor1 = (UInt8*) image1.data.bytes;
            size = image1.elementCount;
        } else {
            valor1 = (UInt8*) image2.data.bytes;
            size = image2.elementCount;
        }

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

        CGContextRef contextRef;
        
        if (i == 1) {
            src1 = cv::Mat(rows, cols, CV_8UC4);
            contextRef = CGBitmapContextCreate(src1.data,                 // Pointer to  data
                                                         cols,                       // Width of bitmap
                                                         rows,                       // Height of bitmap
                                                         8,                          // Bits per component
                                                         src1.step[0],              // Bytes per row
                                                         colorSpace,                 // Colorspace
                                                         kCGImageAlphaNoneSkipLast |
                                                         kCGBitmapByteOrderDefault); 
        } else {
            src2 = cv::Mat(rows, cols, CV_8UC4);
            contextRef = CGBitmapContextCreate(src2.data,                 // Pointer to  data
                                                         cols,                       // Width of bitmap
                                                         rows,                       // Height of bitmap
                                                         8,                          // Bits per component
                                                         src2.step[0],              // Bytes per row
                                                         colorSpace,                 // Colorspace
                                                         kCGImageAlphaNoneSkipLast |
                                                         kCGBitmapByteOrderDefault);
        }

        // Bitmap info flags
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image);
        CGContextRelease(contextRef);
        CFRelease(image);
        CFRelease(image_provider);
        CFRelease(file_data_ref);
    } else {
        if (i == 1) {
            src1 = cv::Mat();
        } else {
            src2 = cv::Mat();
        }
    }
    }

    if(src1.empty() || src2.empty()){
        result = [FlutterStandardTypedData typedDataWithBytes: image1.data];
    } else {
        cv::Mat dst;
        cv::absdiff(src1, src2, dst);
        
        NSData *data = [NSData dataWithBytes:dst.data length:dst.elemSize()*dst.total()];
        
        if (dst.elemSize() == 1) {
              colorSpace = CGColorSpaceCreateDeviceGray();
          } else {
              colorSpace = CGColorSpaceCreateDeviceRGB();
          }
          CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
          // Creating CGImage from cv::Mat
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
          // Getting UIImage from CGImage
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
        
        result = [FlutterStandardTypedData typedDataWithBytes: imgConvert];
    }
    
    return result;
}

@end