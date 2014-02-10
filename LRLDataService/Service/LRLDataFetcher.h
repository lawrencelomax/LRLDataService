//
//  LRLDataFetcher.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import <Foundation/Foundation.h>

#import "LRLHTTPDataProvider.h"
#import "LRLFileStorageDataProvider.h"

@interface LRLDataFetcher : NSObject <LRLDataProvider>

+ (instancetype) dataFetcherWithHTTPProvider:(LRLHTTPDataProvider *)httpProvider fileProvider:(LRLFileStorageDataProvider *)fileProvider;
+ (instancetype) dataFetcher;

@property (nonatomic, readonly) LRLHTTPDataProvider *httpProvider;
@property (nonatomic, readonly) LRLFileStorageDataProvider *fileProvider;

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL withLocalCache:(BOOL)useCache repeatInterval:(NSTimeInterval)repeatInterval;

@end
