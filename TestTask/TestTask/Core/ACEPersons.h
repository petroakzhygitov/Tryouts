#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ACEPerson;


@interface ACEPersons : JSONModel
#pragma mark Properties
@property(nonatomic, copy) NSArray <ACEPerson, Optional> *Persons;

@end