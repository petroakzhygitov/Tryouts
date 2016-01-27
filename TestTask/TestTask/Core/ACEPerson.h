#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@class ACEPersonBirthDeathPlace;

#pragma mark Protocol
@protocol ACEPerson

@end


@interface ACEPerson : JSONModel
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *Name;
@property(nonatomic, copy) NSString <Optional> *Portrait;
@property(nonatomic, copy) NSString <Optional> *Sex;
@property(nonatomic, copy) ACEPersonBirthDeathPlace <Optional> *Birth;
@property(nonatomic, copy) ACEPersonBirthDeathPlace <Optional> *Death;

#pragma mark Methods

@end