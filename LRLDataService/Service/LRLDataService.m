//
//  LRLDataService.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 4/02/2014.
//
//

#import "LRLDataService.h"

@interface LRLDataService()

@property (nonatomic, strong) LRLDataFetcher *fetcher;

@end

@implementation LRLDataService

+ (instancetype) dataServiceWithFetcher:(LRLDataFetcher *)fetcher {
	LRLDataService *service = [[self alloc] init];
	service.fetcher = fetcher;
	return service;
}

+ (instancetype) dataService {
	return [self dataServiceWithFetcher:[LRLDataFetcher dataFetcher]];
}

@end
