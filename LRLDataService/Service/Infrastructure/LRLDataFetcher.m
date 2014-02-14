//
//  LRLDataFetcher.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import "LRLDataFetcher.h"

#import "RACSignal+LRLOperatons.h"

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
	return [self dataFetcherWithHTTPProvider:[LRLHTTPDataProvider dataProvider] fileProvider:[LRLFileStorageDataProvider dataProvider]];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL {
	return [self dataForResourceURL:resourceURL withLocalCache:YES repeatInterval:-1];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL withLocalCache:(BOOL)useCache repeatInterval:(NSTimeInterval)repeatInterval {
	LRLHTTPDataProvider *httpProvider = self.httpProvider;
	LRLFileStorageDataProvider *fileProvider = self.fileProvider;
	
	return [[[[[[RACSignal return:resourceURL]
		lrl_checkCorrectClass:NSURL.class]
		map:^(NSURL *resourceURL){
			if(useCache) {
				return [[fileProvider dataForResourceURL:resourceURL] catchTo:RACSignal.empty];
			}
			return RACSignal.empty;
		}]
		map:^(RACSignal *signal) {
			RACSignal *remote = [httpProvider dataForResourceURL:resourceURL];
			if(useCache) {
				remote = [remote flattenMap:^(id value) {
					RACSignal *saveSignal = [[fileProvider saveData:value withResourceURL:resourceURL] catchTo:RACSignal.empty];
					return [saveSignal startWith:value];
				}];
			}
			if(repeatInterval > 0) {
				RACSignal *delay = [[[RACSignal interval:repeatInterval onScheduler:RACScheduler.mainThreadScheduler] take:1] ignoreValues];
				remote = [[remote concat:delay] repeat];
			}
			return [signal concat:remote];
		}]
		switchToLatest]
		setNameWithFormat:@"dataForResourceURL %@", resourceURL];
}

@end
