//
//  LRLResponseSerializer.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 17/02/2014.
//
//

#import "LRLResponseSerializer.h"

@implementation LRLResponseSerializer

+ (instancetype) serializer {
	LRLResponseSerializer *serializer = [[self alloc] init];
	serializer.jsonSerializer = [AFJSONResponseSerializer serializer];
	NSArray *contentTypes = [serializer.jsonSerializer.acceptableContentTypes.allObjects arrayByAddingObject:@"text/html"];
	serializer.jsonSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
	serializer.xmlSerializer = [AFXMLParserResponseSerializer serializer];
	return serializer;
}

- (NSStringEncoding) stringEncoding {
	return self.jsonSerializer.stringEncoding;
}

- (NSIndexSet *) acceptableStatusCodes {
	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
	[indexSet addIndexes:self.jsonSerializer.acceptableStatusCodes];
	[indexSet addIndexes:self.xmlSerializer.acceptableStatusCodes];
	return [indexSet copy];
}

- (NSSet *) acceptableContentTypes {
	NSArray *array = [self.jsonSerializer.acceptableContentTypes.allObjects arrayByAddingObjectsFromArray:self.xmlSerializer.acceptableContentTypes.allObjects];
	return [NSSet setWithArray:array];
}

- (BOOL) validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError **)error {
	NSError *jsonError = nil;
	BOOL result = [self.jsonSerializer validateResponse:response data:data error:&jsonError];
	if(result) {
		return YES;
	}
	NSError *xmlError = nil;
	result = [self.xmlSerializer validateResponse:response data:data error:&xmlError];
	if(result) {
		return YES;
	}
	if(error) {
		*error = jsonError;
	}
	return NO;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError **)error {
	NSError *jsonError = nil;
	id result = [self.jsonSerializer responseObjectForResponse:response data:data error:&jsonError];
	if(result) {
		return result;
	}
	NSError *xmlError = nil;
	result = [self.xmlSerializer responseObjectForResponse:result data:data error:&xmlError];
	if(result) {
		return result;
	}
	if(error) {
		*error = jsonError;
	}
	return nil;
}


@end
