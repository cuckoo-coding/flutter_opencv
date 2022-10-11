#import "HaarObjectDetection.h"

@implementation HaarObjectDetection

+ (void)process:(FlutterStandardTypedData *)data cascadePath:(NSString*)cascadePath minNeighbors:(int)minNeighbors result:(FlutterResult)result {
    cv::CascadeClassifier face_cascade;

    std::string stdPath = std::string([cascadePath UTF8String]);

    cv::String path = cv::String(stdPath);

    face_cascade.load(path);

    CGColorSpaceRef colorSpace;
    const char * suffix;
    cv::Mat src;
    FlutterStandardTypedData* res;
    
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
    
    
    if(src.empty()){
        res = [FlutterStandardTypedData typedDataWithBytes: data.data];
    } else {
        cv::Mat srcGray;
        cv::cvtColor(src, srcGray, cv::COLOR_BGR2GRAY);
        std::vector<cv::Rect> faces;
        face_cascade.detectMultiScale(srcGray, faces, 1.1, minNeighbors);

        NSLog(@"%d faces were detected.", faces.size());

        for (int i = 0;i < faces.size();i++) {
            cv::rectangle(src, cv::Point(faces[i].x, faces[i].y), cv::Point(faces[i].x + faces[i].width, faces[i].y + faces[i].height), cv::Scalar( 255, 0, 0 ), 5);
        }

        NSData *data = [NSData dataWithBytes:src.data length:src.elemSize()*src.total()];
        
        if (src.elemSize() == 1) {
              colorSpace = CGColorSpaceCreateDeviceGray();
          } else {
              colorSpace = CGColorSpaceCreateDeviceRGB();
          }
          CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
          // Creating CGImage from cv::Mat
          CGImageRef imageRef = CGImageCreate(src.cols,                                 //width
                                             src.rows,                                 //height
                                             8,                                          //bits per component
                                             8 * src.elemSize(),                       //bits per pixel
                                             src.step[0],                            //bytesPerRow
                                             colorSpace,                                 //colorspace
                                             kCGImageAlphaNoneSkipLast|kCGBitmapByteOrderDefault,// bitmap info
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

        res = [FlutterStandardTypedData typedDataWithBytes: imgConvert];

    }

    result(res);
}

@end