//
//  UIImage+AltaImage.m
//  FoundationObjC
//
//  Created by Raghvendra Kumar on 07/04/16.
//  Copyright © 2016 Hubworks. All rights reserved.
//

#import "UIImage+AltaImage.h"

@implementation UIImage (AltaImage)

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle{
    return [self imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
