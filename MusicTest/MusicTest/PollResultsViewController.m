#import "PollResultsViewController.h"
#import "RACSignal+Operations.h"
#import "PollResultView.h"

@implementation PollResultsViewController
#pragma mark Override

- (void)viewDidLoad {
    [super viewDidLoad];

    [[[self.service pollResults] deliverOnMainThread] subscribeNext:^(NSDictionary *dictionary) {
        PollResultView *guitarPollResultView = self.guitarPollResultView;
        guitarPollResultView.title = @"Guitar";
        guitarPollResultView.percentage = ((NSNumber *) dictionary[@(PAKPollSelectionTypeGuitar)]).floatValue;
        [guitarPollResultView.resultsBackgroundImage setImage:[UIImage imageNamed:@"bg_blue.png"]];

        PollResultView *bassPollResultView = self.bassPollResultView;
        bassPollResultView.title = @"Bass";
        bassPollResultView.percentage = ((NSNumber *) dictionary[@(PAKPollSelectionTypeBass)]).floatValue;
        [bassPollResultView.resultsBackgroundImage setImage:[UIImage imageNamed:@"bg_orange.png"]];

        PollResultView *electricPollResultView = self.electricPollResultView;
        electricPollResultView.title = @"Electric";
        electricPollResultView.percentage = ((NSNumber *) dictionary[@(PAKPollSelectionTypeElectric)]).floatValue;
        [electricPollResultView.resultsBackgroundImage setImage:[UIImage imageNamed:@"bg_pink.png"]];

        PollResultView *banjoPollResultView = self.banjoPollResultView;
        banjoPollResultView.title = @"Banjo";
        banjoPollResultView.percentage = ((NSNumber *) dictionary[@(PAKPollSelectionTypeBanjo)]).floatValue;
        [banjoPollResultView.resultsBackgroundImage setImage:[UIImage imageNamed:@"bg_green.png"]];

        CGFloat selectionTypePercentage = ((NSNumber *) dictionary[@(self.selectionType)]).floatValue;
        NSString *selectionTypeString = [PAKPollSelectionTypeObject selectionTypeStringWithSelectionType:self.selectionType];

        self.similarLikeLabel.text = [NSString stringWithFormat:@"%@,\n %.f%% also likes %@", self.userName,
                                                                selectionTypePercentage, selectionTypeString];

    }                                                         error:^(NSError *error) {
        NSLog(@"Error occurred: %@", error);
    }];
}

@end