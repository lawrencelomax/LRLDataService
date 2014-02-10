//
//  LRLDataFetcher.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import "LRLDataFetcher.h"

@interface LRLDataFetcher ()

@property (nonatomic, strong) LRLHTTPDataProvider *httpProvider;
@property (nonatomic, strong) LRLFileStorageDataProvider *fileProvider;

@end

@implementation LRLDataFetcher

+ (instancetype) dataFetcherWithHTTPProvider:(LRLHTTPDataProvider *)httpProvider fileProvider:(LRLFileStorageDataProvider *)fileProvider {
	LRLDataFetcher *fetcher = [[self alloc] init];
	fetcher.httpProvider = httpProvider;
	fetcher.fileProvider = fileProvider;
	return fetcher;
}

+ (instancetype) dataFetcher {
	return [self dataFetcherWithHTTPProvider:[[LRLHTTPDataProvider alloc] init] fileProvider:[[LRLFileStorageDataProvider alloc] init]];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL {
	return [self dataForResourceURL:resourceURL withLocalCache:YES repeatInterval:-1];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL withLocalCache:(BOOL)useCache repeatInterval:(NSTimeInterval)repeatInterval {
	RACSignal *fileSignal = useCache ? RACSignal.empty : [self.fileProvider dataForResourceURL:resourceURL];
	RACSignal *httpSignal = [self.httpProvider dataForResourceURL:resourceURL];
	
	RACSignal *composedSignal = [fileSignal concat:httpSignal];
	
	if(repeatInterval > 0) {
		RACSignal *delay = [[[RACSignal interval:repeatInterval onScheduler:RACScheduler.mainThreadScheduler] take:1] ignoreValues];
		httpSignal = [[composedSignal concat:delay] repeat];
	}
	
	return [fileSignal concat:httpSignal];
}

@end
