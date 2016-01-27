#import "PAKPollSelectionTypeObject.h"

#pragma mark const
NSString *const kSelectionTypeStringBanjo = @"banjo";
NSString *const kSelectionTypeStringBass = @"bass";
NSString *const kSelectionTypeStringElectric = @"electric";
NSString *const kSelectionTypeStringGuitar = @"guitar";


@implementation PAKPollSelectionTypeObject
#pragma mark Public

+ (NSString *)selectionTypeStringWithSelectionType:(PAKPollSelectionType)selectionType {
    switch (selectionType) {
        case PAKPollSelectionTypeUndefined:
            return nil;

        case PAKPollSelectionTypeBanjo:
            return kSelectionTypeStringBanjo;

        case PAKPollSelectionTypeBass:
            return kSelectionTypeStringBass;

        case PAKPollSelectionTypeElectric:
            return kSelectionTypeStringElectric;

        case PAKPollSelectionTypeGuitar:
            return kSelectionTypeStringGuitar;
    }

    return nil;
}

+ (PAKPollSelectionType)selectionTypeWithString:(NSString *)selectionTypeString {
    if ([selectionTypeString isEqualToString:kSelectionTypeStringBanjo]) {
        return PAKPollSelectionTypeBanjo;
    }

    if ([selectionTypeString isEqualToString:kSelectionTypeStringBass]) {
        return PAKPollSelectionTypeBass;
    }

    if ([selectionTypeString isEqualToString:kSelectionTypeStringElectric]) {
        return PAKPollSelectionTypeElectric;
    }

    if ([selectionTypeString isEqualToString:kSelectionTypeStringGuitar]) {
        return PAKPollSelectionTypeGuitar;
    }

    return PAKPollSelectionTypeUndefined;
}

@end