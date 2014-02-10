//
//  LRLHTTPDataProvider.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import "LRLHTTPDataProvider.h"

@interface LRLHTTPDataProvider()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation LRLHTTPDataProvider

+ (instancetype) dataProviderWithManager:(AFHTTPRequestOperationManager *)manager {
	LRLHTTPDataProvider *provider = [[self alloc] init];
	provider.manager = manager;
	return provider;
}

+ (instancetype) dataProvider {
	return [self dataProviderWithManager:[AFHTTPRequestOperationManager manager]];
}

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL  {
	@weakify(self)
	
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		@strongify(self)
		
		AFHTTPRequestOperation *operation =
		[self.manager GET:resourceURL.absoluteString
			   parameters:@{}
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
