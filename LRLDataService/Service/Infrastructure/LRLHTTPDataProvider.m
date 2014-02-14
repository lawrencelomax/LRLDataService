//
//  LRLHTTPDataProvider.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import "LRLHTTPDataProvider.h"

#import "LRLResponseSerializer.h"

@interface LRLHTTPDataProvider()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation LRLHTTPDataProvider

+ (instancetype) dataProviderWithManager:(AFHTTPRequestOperationManager *)manager {
	LRLHTTPDataProvider *provider = [[self alloc] init];
	provider.manager = manager;
	NSArray *acceptableContentTypes = provider.manager.responseSerializer.acceptableContentTypes.allObjects;
	acceptableContentTypes = [acceptableContentTypes arrayByAddingObjectsFromArray:@[@"text/html"]];
	provider.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:acceptableContentTypes];
	return provider;
}

+ (instancetype) dataProvider {
	AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [LRLResponseSerializer serializer];
	return [self dataProviderWithManager:manager];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL  {
	@weakify(self)
	
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		@strongify(self)
		
		AFHTTPRequestOperation *operation =
		[self.manager GET:resourceURL.absoluteString
			   parameters:nil
				  success:^(AFHTTPRequestOperation *operation, id responseObject) {
					  [subscriber sendNext:responseObject];
					  [subscriber sendCompleted];
				  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					  [subscriber sendError:error];
				  }];

		@weakify(operation)
		return [RACDisposable disposableWithBlock:^{
			@strongify(operation)
			[operation setCompletionBlockWithSuccess:nil failure:nil];
			[operation cancel];
		}];
	}];
	
}

@end
