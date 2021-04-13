//
//  PAEBPhotoModel.m
//  PhotoEditor_Example
//
//  Created by 黄玺(EX-HUANGXI001) on 2021/4/12.
//  Copyright © 2021 234539037@qq.com. All rights reserved.
//

#import "PAEBPhotoModel.h"

@implementation PAEBPhotoModel


+ (instancetype)photoModelWithPHAsset:(PHAsset *)asset {
    return [[self alloc] initWithPHAsset:asset];
}

- (instancetype)initWithPHAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.asset = asset;
    }
    return self;
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.photoEdit forKey:@"photoEdit"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        self.photoEdit =  [coder decodeObjectForKey:@"photoEdit"];
    }
    return self;
}

@end
