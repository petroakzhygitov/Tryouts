#import "PollResultView.h"

#pragma mark const

const int kTextMargins = 20;


@implementation PollResultView

#pragma mark Initializer

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initializeSubviews];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initializeSubviews];
    }

    return self;
}

#pragma mark Private

- (void)_initializeSubviews {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

    UIView *view = nibContents.firstObject;
    if (!view) return;

    [self addSubview:view];

    [view setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f
                                                                    constant:0.0f];

    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f
                                                                    constant:0.0f];

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f
                                                                    constant:0.0f];

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f
                                                                    constant:0.0f];

    [self addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
}

- (void)_decideWhichLabelToShow {
    CGSize textSize = [self.insideTitleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.insideTitleLabel.font}];

    if (textSize.width + kTextMargins < self.resultsBackgroundImageWidthConstraint.constant) {
        self.insideTitleLabel.hidden = NO;
        self.outsideTitleLabel.hidden = YES;

    } else {
        self.insideTitleLabel.hidden = YES;
        self.outsideTitleLabel.hidden = NO;
    }
}

#pragma mark Override

- (void)setTitle:(NSString *)title {
    _title = [title copy];

    self.insideTitleLabel.text = self.title;
    self.outsideTitleLabel.text = self.title;

    [self _decideWhichLabelToShow];
}

- (void)setPercentage:(CGFloat)percentage {
    _percentage = percentage;

    self.percentageLabel.text = [NSString stringWithFormat:@"%.0f%%", percentage];

    self.resultsBackgroundImageWidthConstraint.constant = (CGFloat) (1.92 * percentage);
    [self setNeedsLayout];

    [self _decideWhichLabelToShow];
}


@end