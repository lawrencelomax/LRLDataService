//
//  LRLFileStorageDataProvider.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import "LRLFileStorageDataProvider.h"

#import "LRLURLHelpers.h"
#import "RACSignal+LRLOperatons.h"

NSString *const LRLFileStorageDataProviderErrorDomain = @"com.github.lawrencelomax.lrldataservice.dataprovider";

@interface LRLFileStorageDataProvider()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation LRLFileStorageDataProvider

+ (NSError *) errorWithDescription:(NSString *)description {
	return [NSError errorWithDomain:LRLFileStorageDataProviderErrorDomain
							   code:0
						   userInfo:@{NSLocalizedDescriptionKey : description}];
}

+ (instancetype) dataProviderWithFileManager:(NSFileManager *)fileManager {
	LRLFileStorageDataProvider *provider = [[self alloc] init];
	provider.fileManager = fileManager;
	return provider;
}

+ (instancetype) dataProvider {
	return [self dataProviderWithFileManager:[[NSFileManager alloc] init]];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL {
	return [[[[[[RACSignal return:resourceURL]
		lrl_checkCorrectClass:NSURL.class]
		map:^(NSURL *url){
			if([resourceURL isFileURL]) {
				return resourceURL;
			} else {
				return [LRLFileStorageDataProvider localFileForResourceURL:resourceURL];
			}
		}]
		try:^BOOL(NSURL *url, NSError **errorPtr) {
			return [url checkResourceIsReachableAndReturnError:errorPtr];
		}]
		tryMap:^(NSURL *resourceURL, NSError **errorPtr) {
			id value = [NSKeyedUnarchiver unarchiveObjectWithFile:resourceURL.absoluteString];
			if(!value) {
				*errorPtr = [NSError errorWithDomain:LRLFileStorageDataProviderErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Could not read file from url"}];
			}
			return value;
		}]
		setNameWithFormat:@"dataForResourceURL: %@", resourceURL];
}

- (RACSignal *) saveData:(id<NSCoding>)data withResourceURL:(NSURL *)resourceURL {
	return [[[[[RACSignal return:resourceURL]
		lrl_checkCorrectClass:NSURL.class]
		map:^(NSURL *resourceURL){
			if(![resourceURL isFileURL]) {
				return [LRLFileStorageDataProvider localFileForResourceURL:resourceURL];
			}
			return resourceURL;
		}]
		tryMap:^ id (NSURL *resourceURL, NSError **errorPtr) {
			BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:resourceURL.absoluteString];
			if(!result) {
				*errorPtr = [NSError errorWithDomain:LRLFileStorageDataProviderErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Could not save file to url"}];
				return nil;
		   	}
			return data;
		}]
		setNameWithFormat:@"saveData: %@ withResourceURL %@", data, resourceURL];
}

+ (NSURL *) localFileForResourceURL:(NSURL *)resourceURL {
	NSString *fileName = [LRLURLHelpers uniqueStringForURL:resourceURL];
	return [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:fileName isDirectory:NO];
}

@end
