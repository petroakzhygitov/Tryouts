#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PAKMusicTestService.h"

@class PAKMusicTestService;
@class PollResultView;

@interface PollResultsViewController : UIViewController
#pragma mark Properties

@property(weak, nonatomic) IBOutlet PollResultView *guitarPollResultView;
@property(weak, nonatomic) IBOutlet PollResultView *electricPollResultView;
@property(weak, nonatomic) IBOutlet PollResultView *bassPollResultView;
@property(weak, nonatomic) IBOutlet PollResultView *banjoPollResultView;

@property(weak, nonatomic) IBOutlet UILabel *similarLikeLabel;

@property(nonatomic) PAKMusicTestService *service;

@property(nonatomic, copy) NSString *userName;
@property(nonatomic) PAKPollSelectionType selectionType;

@end