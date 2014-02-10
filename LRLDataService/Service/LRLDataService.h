//
//  LRLDataService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 4/02/2014.
//
//

#import <Foundation/Foundation.h>

#import "LRLDataFetcher.h"

@interface LRLDataService : NSObject

+ (instancetype) dataServiceWithFetcher:(LRLDataFetcher *)fetcher;
+ (instancetype) dataService;

@property (nonatomic, readonly) LRLDataFetcher *fetcher;

@end
