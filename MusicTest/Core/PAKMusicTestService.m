#import "PAKMusicTestService.h"
#import "RACSignal.h"
#import "RACSubscriber.h"

#pragma mark const
NSString *const PAKMusicTestServiceErrorDomain = @"PAKMusicTestServiceErrorDomain";
const int PAKMusicTestServiceErrorCodeBadResponse = 1;

NSString *const kURLStringSubmitPoll = @"https://demo7130406.mockable.io/submit-poll";
NSString *const kURLPollResults = @"https://demo7130406.mockable.io/poll-results";

static const Byte kHTTPStatusCodeOK = 200;


@implementation PAKMusicTestService
#pragma mark Private

- (RACSignal *)_dataWithRequest:(NSURLRequest *)request {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSURLSession *session = [NSURLSession sharedSession];

        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];

                return;
            }

            NSInteger responseStatusCode = ((NSHTTPURLResponse *) response).statusCode;
            if (responseStatusCode != kHTTPStatusCodeOK) {
                [subscriber sendError:[self _badResponseError]];

                return;
            }

            [subscriber sendNext:data];
            [subscriber sendCompleted];

        }] resume];

        return nil;
    }];
}

- (NSError *)_badResponseError {
    return [NSError errorWithDomain:PAKMusicTestServiceErrorDomain code:PAKMusicTestServiceErrorCodeBadResponse userInfo:nil];
}

#pragma mark Public

- (RACSignal *)submitPollWithUserName:(NSString *)userName selectionType:(PAKPollSelectionType)selectionType {
    NSString *selectionTypeString = [PAKPollSelectionTypeObject selectionTypeStringWithSelectionType:selectionType];

    NSString *postValues = [NSString stringWithFormat:@"username=%@&selectionType=%@", userName, selectionTypeString];
    NSData *postData = [postValues dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%li", (unsigned long) [postValues length]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kURLStringSubmitPoll]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];

    return [self _dataWithRequest:request];
}

- (RACSignal *)pollResults {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kURLPollResults]];

    return [[self _dataWithRequest:request] flattenMap:^RACStream *(NSData *data) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (error) return [RACSignal error:error];

        NSMutableDictionary *selectionsDictionary = [[NSMutableDictionary alloc] init];
        for (NSString *key in jsonDictionary.allKeys) {
            PAKPollSelectionType selectionType = [PAKPollSelectionTypeObject selectionTypeWithString:key];
            if (selectionType == PAKPollSelectionTypeUndefined) continue;

            selectionsDictionary[@(selectionType)] = jsonDictionary[key];
        }

        return [RACSignal return:selectionsDictionary];
    }];
}

@end