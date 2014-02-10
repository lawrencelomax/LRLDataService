//
//  LRLFileStorageDataProvider.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import "LRLFileStorageDataProvider.h"

#import "LRLURLHelpers.h"

@interface LRLFileStorageDataProvider()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation LRLFileStorageDataProvider

+ (instancetype) dataProviderWithFileManager:(NSFileManager *)fileManager {
	LRLFileStorageDataProvider *provider = [[self alloc] init];
	provider.fileManager = fileManager;
	return provider;
}

+ (instancetype) dataProvider {
	return [self dataProviderWithFileManager:[[NSFileManager alloc] init]];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL {
	return [RACSignal defer:^{
		NSURL *localSave = [LRLFileStorageDataProvider localFileForResourceURL:resourceURL];
		if(![localSave checkResourceIsReachableAndReturnError:nil]) {
			return RACSignal.empty;
		}
		NSInputStream *inputStream = [NSInputStream inputStreamWithURL:resourceURL];
		[inputStream open];
		
		NSError *error = nil;
		id value = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:&error];
		[inputStream close];
		
		if(!value) {
			return [RACSignal error:error];
		}
		
		return [RACSignal return:value];
	}];
}

- (RACSignal *) saveData:(id<NSCoding>)data withResourceURL:(NSURL *)resourceURL {
	return [RACSignal defer:^{
		NSURL *localSave = [LRLFileStorageDataProvider localFileForResourceURL:resourceURL];
		
		NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:localSave append:NO];
		[outputStream open];
		
		NSError *error = nil;
		NSInteger result = [NSJSONSerialization writeJSONObject:data toStream:outputStream options:0 error:&error];
		[outputStream close];
		
		if(result == 0) {
			return [RACSignal error:error];
		}
		
		return [RACSignal return:data];
	}];
}

+ (NSURL *) localFileForResourceURL:(NSURL *)resourceURL {
	NSString *fileName = [LRLURLHelpers uniqueStringForURL:resourceURL];
	return [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:fileName isDirectory:NO];
}

@end
