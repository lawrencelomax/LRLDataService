//
//  LRLURLHelpers.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLURLHelpers.h"

#import <NSString-Hashes/NSString+Hashes.h>

@implementation LRLURLHelpers

+ (NSString *) uniqueStringForURL:(NSURL *)url {
	return url.absoluteString.md5;
}

@end
