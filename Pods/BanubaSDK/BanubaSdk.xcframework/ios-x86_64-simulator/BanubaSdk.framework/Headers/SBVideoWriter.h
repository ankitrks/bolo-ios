#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SBVideoWriterError.h"

@interface SBVideoWriter : NSObject

@property (assign, nonatomic, readonly) CMTime recorderVideoDuration;

- (instancetype)initWithCaptureSize:(CGSize)size;
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)buffer;
- (void)pushVideoSampleBuffer:(CVPixelBufferRef)buffer;

- (void)prepareInputs:(NSURL *)fileUrl;
- (void)startCapturingScreenWithUrl:(NSURL *)fileUrl
                           progress:(void(^)(CMTime))progress
       periodicProgressTimeInterval:(NSTimeInterval)periodicProgressTimeInterval
                      boundaryTimes:(NSArray<NSValue *> *)boundaryTimes
                    boundaryHandler:(void(^)(CMTime))boundaryHandler
                      totalDuration:(NSTimeInterval)totalDuration
                limitReachedHandler:(void(^)(void))limitReachedHandler
                         completion:(void(^)(BOOL, NSError *))completionHandler;

- (void)startCapturingScreenWithProgress:(void(^)(CMTime))progress
            periodicProgressTimeInterval:(NSTimeInterval)periodicProgressTimeInterval
                           boundaryTimes:(NSArray<NSValue *> *)boundaryTimes
                         boundaryHandler:(void(^)(CMTime))boundaryHandler
                           totalDuration:(NSTimeInterval)totalDuration
                     limitReachedHandler:(void(^)(void))limitReachedHandler
                              completion:(void(^)(BOOL, NSError *))completionHandler;
- (void)stopCapturing;
- (void)discardCapturing;
+ (BOOL)isEnoughDiskSpaceForRecording;

@end
