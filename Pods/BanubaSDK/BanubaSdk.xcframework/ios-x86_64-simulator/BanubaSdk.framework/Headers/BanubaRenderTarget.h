//
//  BNBLayerHandler.h
//  Easy Snap
//
//  Created by Victor Privalov on 7/12/18.
//  Copyright © 2018 Banuba. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BanubaRenderTarget: NSObject

@property (nonatomic, assign) GLuint framebuffer2;
@property (nonatomic, assign) CGSize renderSize;

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, weak) CAEAGLLayer *layer;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContext:(EAGLContext *)context layer:(CAEAGLLayer *)layer renderSize: (CGSize)renderSize NS_DESIGNATED_INITIALIZER;
- (CVPixelBufferRef)createRenderedVideoPixelBuffer;
- (UIImage *)snapshot;
- (UIImage *)snapshotWith:(CVPixelBufferRef)watermarkPixelBuffer;
- (void)activate;
- (void)presentRenderbuffer: (void(^)(void))postProcessHandler;

+ (CVImageBufferRef)rotateBuffer:(CVImageBufferRef)imageBuffer;

@end

NS_ASSUME_NONNULL_END
