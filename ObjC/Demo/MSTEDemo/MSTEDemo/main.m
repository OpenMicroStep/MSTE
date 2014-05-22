//
//  main.m
//  MSTEDemo
//
//  Created by Melodie on 28/01/13.
//  Copyright (c) 2013 Logitud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSTEncoder/MSTEncoder.h>
#import <MSTEncoder/MSTDecoder.h>

@interface Person : NSObject
{
	NSString *_name;
	NSString *_firstName;
	NSDate *_birthday;
	
	Person *_maried_to ;
	Person *_father ;
	Person *_mother ;
	
    BOOL _aBool ;
    int _aInt ;
    NSNumber *_aNumber1 ;
    NSNumber *_aNumber2 ;
    NSNumber *_aNumber3 ;
}

+ (id)personWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay;
- (id)initWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay;

- (void)setMariedTo:(Person *)person;
- (void)setFather:(Person *)person;
- (void)setMother:(Person *)person;

- (void)setBool:(BOOL)value ;
- (void)setInt:(int)value ;
- (void)setNumber1:(NSNumber *)value ;
- (void)setNumber2:(NSNumber *)value ;
- (void)setNumber3:(NSNumber *)value ;

@end

@interface Person2 : Person
{
}
@end


@implementation Person

+ (id)personWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay
{
	return [[[self alloc] initWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay] autorelease] ;
}
- (id)initWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay
{
	_name = [name retain] ;
	_firstName = [firstName retain] ;
	_birthday = [birthDay retain] ;
    return self;
}

- (void)dealloc
{
	[_name release] ;
	[_firstName release] ;
	[_birthday release] ;
	[_maried_to release] ;
	[_father release] ;
	[_mother release] ;
    [_aNumber1 release] ;
    [_aNumber2 release] ;
    [_aNumber3 release] ;
	[super dealloc] ;
}

- (void)setMariedTo:(Person *)person
{
	_maried_to = [person retain] ;
}

- (void)setFather:(Person *)person
{
	_father = [person retain] ;
}

- (void)setMother:(Person *)person
{
	_mother = [person retain] ;
}

- (void)setBool:(BOOL)value { _aBool = value ; }
- (void)setInt:(int)value {_aInt = value ; }
- (void)setNumber1:(NSNumber *)value { _aNumber1 = [value retain] ; }
- (void)setNumber2:(NSNumber *)value { _aNumber2 = [value retain] ; }
- (void)setNumber3:(NSNumber *)value { _aNumber3 = [value retain] ; }

- (NSString *)description
{ return [NSString stringWithFormat:@"Person: %@ %@ %@ %d %d %@ %@ %@", _name, _firstName, _birthday, _aBool, _aInt, _aNumber1, _aNumber2, _aNumber3] ; }

- (NSDictionary *)MSTESnapshot
{
    NSMutableDictionary *res = [NSMutableDictionary dictionary] ;

    if (_name) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_name, YES) forKey:@"name"] ; }
    if (_firstName) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_firstName, YES) forKey:@"firstName"] ; }
    if (_birthday) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_birthday, YES) forKey:@"birthday"] ; }
    if (_maried_to) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_maried_to, YES) forKey:@"maried-to"] ; }
    if (_father) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_father, YES) forKey:@"father"] ; }
    if (_mother) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_mother, YES) forKey:@"mother"] ; }
    if (_aBool) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE([NSNumber numberWithBool:_aBool], NO) forKey:@"aBool"] ; }
    if (_aInt) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE([NSNumber numberWithInt:_aInt], NO) forKey:@"aInt"] ; }
    if (_aNumber1) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_aNumber1, YES) forKey:@"aNumber1"] ; }
    if (_aNumber2) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_aNumber2, YES) forKey:@"aNumber2"] ; }
    if (_aNumber3) { [res setObject:CREATE_MSTE_SNAPSHOT_VALUE(_aNumber3, YES) forKey:@"aNumber3"] ; }
    
    return res ;
}

- (id)initWithDictionary:(NSDictionary *)values
{
	_name = [[values objectForKey:@"name"] retain] ;
	_firstName = [[values objectForKey:@"firstName"] retain] ;
	_birthday = [[values objectForKey:@"birthday"] retain] ;
	_maried_to = [[values objectForKey:@"maried-to"] retain] ;
	_father = [[values objectForKey:@"father"] retain] ;
	_mother = [[values objectForKey:@"mother"] retain] ;
    _aBool = [[values objectForKey:@"aBool"] boolValue] ;
    _aInt = [[values objectForKey:@"aInt"] intValue] ;
    _aNumber1 = [[values objectForKey:@"aNumber1"] retain] ;
    _aNumber2 = [[values objectForKey:@"aNumber2"] retain] ;
    _aNumber3 = [[values objectForKey:@"aNumber3"] retain] ;
	return self ;
}

@end

@implementation Person2

- (NSString *)description
{ return [NSString stringWithFormat:@"Person2: %@ %@ %@", _name, _firstName, _birthday] ; }

@end

int main(int argc, const char * argv[])
{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init] ;
    
	Person *pers1 = [Person personWithName:@"Durand ¥-$-€" firstName:@"Yves" birthDay:[NSDate dateWithTimeIntervalSince1970:-243820800]] ;
	Person *pers2 = [Person personWithName:@"Durand" firstName:@"Claire" birthDay:[NSDate dateWithTimeIntervalSince1970:-207360000]] ;
	Person2 *pers3 = [Person2 personWithName:@"Durand" firstName:@"Lou" birthDay:[NSDate dateWithTimeIntervalSince1970:552096000]] ;
    NSData *emptyData = [NSData data] ;
    NSData *filledData = [NSData dataWithBytes:"F7y4" length:4] ;
	NSArray *tab = [NSArray arrayWithObjects:pers1, pers2, pers3, emptyData, filledData, pers1, filledData, emptyData, nil] ;
	NSData *buffer = nil ;
	
	[pers1 setMariedTo:pers2] ;
    [pers1 setBool:YES] ;
    [pers1 setInt:3] ;
    [pers1 setNumber1:[NSNumber numberWithInt:1765435]] ;
    [pers1 setNumber2:[NSNumber numberWithDouble:1.4568765435]] ;
    [pers1 setNumber3:[[[NSDecimalNumber alloc] initWithMantissa:1313513135130000001 exponent:-112 isNegative:YES] autorelease]] ;
	[pers2 setMariedTo:pers1] ;
	[pers3 setMother:pers2] ;
	[pers3 setFather:pers1] ;
    
	NSLog(@"tab = %@", tab);

	buffer = [tab MSTEncodedBuffer] ;
	NSLog(@"ENCODED = %@", [NSString stringWithCString:[buffer bytes] encoding:NSUTF8StringEncoding]);

	NSLog(@"DECODED = %@", [buffer MSTDecodedObject]);
	
    buffer = [[[NSData alloc] initWithContentsOfFile:@"/Users/jm-bertheas/Developer/LOGITUD_Sources/MSTE/ObjC/Demo/MSTEDemo/MSTEDemo/MSTE_Example-UTF8.txt"] autorelease];
    if ([buffer length]) {
        NSLog(@"DECODING UTF8 FILE... ***************************");
        NSLog(@"DECODED UTF8 FILE -> %@", [buffer MSTDecodedObject]);
    }

    buffer = [[[NSData alloc] initWithContentsOfFile:@"/Users/jm-bertheas/Developer/LOGITUD_Sources/MSTE/ObjC/Demo/MSTEDemo/MSTEDemo/MSTE_Example-ASCII7.txt"] autorelease];
    if ([buffer length]) {
        NSLog(@"DECODING ASCII 7 BITS FILE... ***************************");
        NSLog(@"DECODED ASCII 7 BITS FILE -> %@", [buffer MSTDecodedObject]);
    }
   
    buffer = [[[NSData alloc] initWithContentsOfFile:@"/Users/jm-bertheas/Developer/LOGITUD_Sources/MSTE/ObjC/Demo/MSTEDemo/MSTEDemo/MSTE_Example2-UTF8.txt"] autorelease];
    if ([buffer length]) {
        NSLog(@"DECODING UTF8 FILE2... ***************************");
        NSLog(@"DECODED UTF8 FILE2 -> %@", [buffer MSTDecodedObject]);
    }
    
    buffer = [[[NSData alloc] initWithContentsOfFile:@"/Users/jm-bertheas/Developer/LOGITUD_Sources/MSTE/ObjC/Demo/MSTEDemo/MSTEDemo/MSTE_Example3-UTF8.txt"] autorelease];
    if ([buffer length]) {
        NSLog(@"DECODING UTF8 FILE3... ***************************");
        NSLog(@"DECODED UTF8 FILE3 -> %@", [buffer MSTDecodedObject]);
    }
    
    [pool release] ;
    return 0;
}
