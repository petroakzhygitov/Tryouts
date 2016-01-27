#import <Foundation/Foundation.h>
#import "PAKPollSelectionTypeObject.h"

@class RACSignal;

FOUNDATION_EXTERN NSString *const PAKMusicTestServiceErrorDomain;
FOUNDATION_EXTERN const int PAKMusicTestServiceErrorCodeBadResponse;

@interface PAKMusicTestService : NSObject
#pragma mark Methods

- (RACSignal *)submitPollWithUserName:(NSString *)userName selectionType:(PAKPollSelectionType)selectionType;

- (RACSignal *)pollResults;


@end