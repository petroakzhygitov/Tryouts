#import <Foundation/Foundation.h>

#pragma mark typedef
typedef NS_ENUM(NSUInteger, PAKPollSelectionType) {
    PAKPollSelectionTypeUndefined = 0,
    PAKPollSelectionTypeBass,
    PAKPollSelectionTypeElectric,
    PAKPollSelectionTypeGuitar,
    PAKPollSelectionTypeBanjo
};

@interface PAKPollSelectionTypeObject : NSObject
#pragma mark Methods

+ (NSString *)selectionTypeStringWithSelectionType:(PAKPollSelectionType)selectionType;

+ (PAKPollSelectionType)selectionTypeWithString:(NSString *)selectionTypeString;

@end