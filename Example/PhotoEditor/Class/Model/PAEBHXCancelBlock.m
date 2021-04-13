//
//  PAEBHXCancelBlock.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/7.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBHXCancelBlock.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>

__attribute__((overloadable)) NSData * HX_UIImagePNGRepresentation(UIImage *image) {
    return HX_UIImageRepresentation(image, kUTTypePNG, nil);
}

__attribute__((overloadable)) NSData * HX_UIImageJPEGRepresentation(UIImage *image) {
    return HX_UIImageRepresentation(image, kUTTypeJPEG, nil);
}

__attribute__((overloadable)) NSData * HX_UIImageRepresentation(UIImage *image, CFStringRef __nonnull type, NSError * __autoreleasing *error) {
    
    if (!image) {
        return nil;
    }
    NSDictionary *userInfo = nil;
    {
        NSMutableData *mutableData = [NSMutableData data];
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, type, 1, NULL);
        
        CGImageDestinationAddImage(destination, [image CGImage], NULL);
        
        BOOL success = CGImageDestinationFinalize(destination);
        CFRelease(destination);
        
        if (!success) {
            userInfo = @{
                         NSLocalizedDescriptionKey: NSLocalizedString(@"Could not finalize image destination", nil)
                         };
            
            goto _error;
        }
        
        return [NSData dataWithData:mutableData];
    }
    _error: {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.compuserve.image.error" code:-1 userInfo:userInfo];
        }
        return nil;
    }
}
