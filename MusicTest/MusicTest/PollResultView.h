#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PollResultView : UIView
#pragma mark Properties

@property(weak, nonatomic) IBOutlet UIImageView *resultsBackgroundImage;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *resultsBackgroundImageWidthConstraint;

@property(weak, nonatomic) IBOutlet UILabel *percentageLabel;

@property(weak, nonatomic) IBOutlet UILabel *insideTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *outsideTitleLabel;

@property(nonatomic, copy) NSString *title;
@property(nonatomic) CGFloat percentage;

@end