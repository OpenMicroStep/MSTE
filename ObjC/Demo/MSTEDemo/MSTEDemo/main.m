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
	
}

+ (id)personWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay;
- (id)initWithName:(NSString *)name firstName:(NSString *)firstName birthDay:(NSDate *)birthDay;

- (void)setMariedTo:(Person *)person;
- (void)setFather:(Person *)person;
- (void)setMother:(Person *)person;

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

- (NSString *)description
{ return [NSString stringWithFormat:@"Person: %@ %@ %@", _name, _firstName, _birthday] ; }

- (NSDictionary *)MSTESnapshot
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		_name, @"name",
		_firstName, @"firstName",
		_birthday, @"birthday",
		_maried_to, @"maried-to",
		_father, @"father",
		_mother, @"mother",
		nil] ;
}

- (id)initWithDictionary:(NSDictionary *)values
{
	_name = [[values objectForKey:@"name"] retain] ;
	_firstName = [[values objectForKey:@"firstName"] retain] ;
	_birthday = [[values objectForKey:@"birthday"] retain] ;
	_maried_to = [[values objectForKey:@"maried-to"] retain] ;
	_father = [[values objectForKey:@"father"] retain] ;
	_mother = [[values objectForKey:@"mother"] retain] ;
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
    
    //Encodage puis decodage    
/*    NSString *aString = @"unechainemélodie^^";
    NSNumber *aNumber = [NSNumber numberWithInt:12];
    NSNumber *aBool = [NSNumber numberWithBool:YES];
    NSArray *anArray = [NSArray arrayWithObjects:aString,aNumber,aBool,nil];
    
    NSData* aData=[anArray MSTEncodedBuffer];
    id encodeDecode=[aData MSTDecodedObjectAndVerifyCRC:YES];
    
    
 
    //Test decodage d'une chaine
    NSString *myString = @"[\"MSTE0101\",45,\"CRC00000000\",1,\"MSTETest\",7,\"Arraaaayy\",\"blabla\",\"Array\",\"color\",\"datata\",\"date\",\"string\",50,6,0,20,2,7,2200083711,8,1,1,6,1351586383,2,20,3,14,12,1,9,2,3,9,2,4,23,\"bcOpbG9kaWU=\",5,9,4,6,5,\"SomeT\\u00E9ext\"]";

    
    NSData *myData = [myString dataUsingEncoding:NSUTF8StringEncoding];
    id decode=[myData MSTDecodedObject];    

       
    NSLog(@"decodage après encodage %@", encodeDecode);
    NSLog(@"decodage autre chaine %@", decode);*/
	
	Person *pers1 = [Person personWithName:@"Durand ¥-$-€" firstName:@"Yves" birthDay:[NSDate dateWithTimeIntervalSince1970:-243820800]] ;
	Person *pers2 = [Person personWithName:@"Durand" firstName:@"Claire" birthDay:[NSDate dateWithTimeIntervalSince1970:-207360000]] ;
	Person2 *pers3 = [Person2 personWithName:@"Durand" firstName:@"Lou" birthDay:[NSDate dateWithTimeIntervalSince1970:552096000]] ;
    NSData *emptyData = [NSData data] ;
    NSData *filledData = [NSData dataWithBytes:"F7y4" length:4] ;
	NSArray *tab = [NSArray arrayWithObjects:pers1, pers2, pers3, emptyData, filledData, pers1, filledData, emptyData, nil] ;
	NSData *buffer = nil ;
	
	[pers1 setMariedTo:pers2] ;
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

    [pool release] ;
    return 0;
}

