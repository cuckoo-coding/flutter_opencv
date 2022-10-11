#import "OpenCVPlugin.h"
#import "ApplyColorMap.h"
#import "CvtColor.h"
#import "BilateralFilter.h"
#import "Blur.h"
#import "MedianBlur.h"
#import "AdaptiveThreshold.h"
#import "DistanceTransform.h"
#import "Threshold.h"
#import "AbsoluteDifference.h"
#import "Bitwise.h"
#import "ConnectedComponent.h"
#import "HaarObjectDetection.h"

@implementation OpenCVPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"opencv"
            binaryMessenger:[registrar messenger]];
  OpenCVPlugin* instance = [[OpenCVPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"absdiff" isEqualToString:call.method]) {
        FlutterStandardTypedData* image1 = call.arguments[@"image1"];
        FlutterStandardTypedData* image2 = call.arguments[@"image2"];

        [AbsoluteDifference process:image1 compare:image2 result:result];
    }
    else if ([@"adaptiveThreshold" isEqualToString:call.method]) {

        FlutterStandardTypedData* data = call.arguments[@"data"];
        double maxValue = [call.arguments[@"maxValue"] doubleValue];
        int adaptiveMethod = [call.arguments[@"adaptiveMethod"] intValue];
        int thresholdType = [call.arguments[@"thresholdType"] intValue];
        int blockSize = [call.arguments[@"blockSize"] intValue];
        double constantValue = [call.arguments[@"constantValue"] doubleValue];

        [AdaptiveThreshold process:data maxValue:maxValue adaptiveMethod:adaptiveMethod thresholdType:thresholdType blockSize:blockSize constantValue:constantValue result:result];
    } 
    else if ([@"applyColorMap" isEqualToString:call.method]) {

        FlutterStandardTypedData* data = call.arguments[@"data"];
        int colorMap = [call.arguments[@"colorMap"] intValue];

        [ApplyColorMap process:data colorMap:colorMap result:result];
    }
    else if ([@"bilateralFilter" isEqualToString:call.method]) {

        FlutterStandardTypedData* data = call.arguments[@"data"];
        int diameter = [call.arguments[@"diameter"] intValue];
        double sigmaColor = [call.arguments[@"sigmaColor"] doubleValue];
        double sigmaSpace = [call.arguments[@"sigmaSpace"] doubleValue];
        int borderType = [call.arguments[@"borderType"] intValue];

        [BilateralFilter process:data diameter:diameter sigmaColor:sigmaColor sigmaSpace:sigmaSpace borderType:borderType result:result];

    }
    else if (([@"bitwiseOr" isEqualToString:call.method])) {
        FlutterStandardTypedData* image1 = call.arguments[@"image1"];
        FlutterStandardTypedData* image2 = call.arguments[@"image2"];

        [Bitwise process:image1 compare:image2 result:result];
    }
    else if ([@"blur" isEqualToString:call.method]) {

        FlutterStandardTypedData* data = call.arguments[@"data"];
        NSArray* kernelSize = call.arguments[@"kernelSize"];
        NSArray* anchorPoint = call.arguments[@"anchorPoint"];
        int borderType = [call.arguments[@"borderType"] intValue];
        double p1 = [[anchorPoint objectAtIndex:0] doubleValue];
        double p2 = [[anchorPoint objectAtIndex:1] doubleValue];
        double x = [[kernelSize objectAtIndex:0] doubleValue];
        double y = [[kernelSize objectAtIndex:1] doubleValue];
        double kernelSizeDouble[2] = {x,y};
        double anchorPointDouble[2] = {p1,p2};

        [Blur process:data kernelSize:kernelSizeDouble anchorPoint:anchorPointDouble borderType:borderType result:result];
    }
    else if ([@"connectedComponentsWithStats" isEqualToString:call.method]) {
        FlutterStandardTypedData* data = call.arguments[@"data"];
        int connectivity = [call.arguments[@"connectivity"] intValue];
        int ltype = [call.arguments[@"ltype"] intValue];

        [ConnectedComponent process:data connectivity:connectivity ltype:ltype result:result];
    }
    else if ([@"cvtColor" isEqualToString:call.method]) {
    
        FlutterStandardTypedData* data = call.arguments[@"data"];
        int outputType = [call.arguments[@"outputType"] intValue];

        [CvtColor process:data outputType:outputType result:result];

    }
    else if ([@"distanceTransform" isEqualToString:call.method]) {

        FlutterStandardTypedData* data = call.arguments[@"data"];
        int distanceType = [call.arguments[@"distanceType"] intValue];
        int maskSize = [call.arguments[@"maskSize"] intValue];

        [DistanceTransform process:data distanceType:distanceType maskSize:maskSize result:result];
    } 
    else if ([@"medianBlur" isEqualToString:call.method]) {
    
        FlutterStandardTypedData* data = call.arguments[@"data"];
        int kernelSize = [call.arguments[@"kernelSize"] intValue];

        [MedianBlur process:data kernelSize:kernelSize result:result];
    }
    else if ([@"objectDetection" isEqualToString:call.method]) {
        FlutterStandardTypedData* data = call.arguments[@"data"];
        int minNeighbors = [call.arguments[@"minNeighbors"] intValue];
        NSString* cascadePath = call.arguments[@"cascadePath"];

        [HaarObjectDetection process:data cascadePath:cascadePath minNeighbors:minNeighbors result:result];
    } else if ([@"threshold" isEqualToString:call.method]) {

        FlutterStandardTypedData* data = call.arguments[@"data"];
        double thresholdValue = [call.arguments[@"thresholdValue"] doubleValue];
        double maxThresholdValue = [call.arguments[@"maxThresholdValue"] doubleValue];
        int thresholdType = [call.arguments[@"thresholdType"] intValue];


        [Threshold process:data thresholdValue:thresholdValue maxThresholdValue:maxThresholdValue thresholdType:thresholdType result:result];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

@end
