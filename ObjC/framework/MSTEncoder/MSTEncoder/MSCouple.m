/*
 
 MSCouple.m
 
 This implementation file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
Herve Malaingre : herve@malaingre.com
Eric Baradat :  k18rt@free.fr

 
 This software is a computer program whose purpose is to [describe
 functionalities and technical features of your software].
 
 This software is governed by the CeCILL-C license under French law and
 abiding by the rules of distribution of free software.  You can  use, 
 modify and/ or redistribute the software under the terms of the CeCILL-C
 license as circulated by CEA, CNRS and INRIA at the following URL
 "http://www.cecill.info". 
 
 As a counterpart to the access to the source code and  rights to copy,
 modify and redistribute granted by the license, users are provided only
 with a limited warranty  and the software's author,  the holder of the
 economic rights,  and the successive licensors  have only  limited
 liability. 
 
 In this respect, the user's attention is drawn to the risks associated
 with loading,  using,  modifying and/or developing or reproducing the
 software by the user in light of its specific status of free software,
 that may mean  that it is complicated to manipulate,  and  that  also
 therefore means  that it is reserved for developers  and  experienced
 professionals having in-depth computer knowledge. Users are therefore
 encouraged to load and test the software's suitability as regards their
 requirements in conditions enabling the security of their systems and/or 
 data to be ensured and,  more generally, to use and operate it in the 
 same conditions as regards security. 
 
 The fact that you are presently reading this means that you have had
 knowledge of the CeCILL-C license and that you accept its terms.
 
 */

#import "MSCouple.h"

#define MS_COUPLE_LAST_VERSION 300

@interface _MSCoupleEnumerator : NSEnumerator
{
    NSInteger _position ;
    MSCouple *_enumeredCouple ;
}

- (id)initWithCouple:(MSCouple *)aCouple position:(NSInteger)position ;
- (id)nextObject ;

@end

static Class __MSCoupleClass = Nil ;
static Class __MSMutableCoupleClass = Nil ;

MSCouple *MSCreateCouple(id first, id second)
{
    MSCouple *c = (MSCouple *)MSCreateObject(__MSCoupleClass) ;
    if (c)
    {
        c->_members[0] = [first retain] ;
        c->_members[1] = [second retain] ;
    }
    return c ;
}


@implementation MSCouple

+ (void)load { if (!__MSCoupleClass) __MSCoupleClass = [self class] ; }

+ (void)initialize
{ 
	if ([self class] == [MSCouple class]) [MSCouple setVersion:MS_COUPLE_LAST_VERSION]; 
}

+ (id)allocWithZone:(NSZone *)zone { return MSAllocateObject(self, 0, zone) ; }
+ (id)alloc { return MSCreateObject(self) ; }
+ (id)new { return MSCreateObject(self) ; }

+ (id)coupleWithFirstMember:(id)o1 secondMember:(id)o2
{ return [[[self alloc] initWithFirstMember:o1 secondMember:o2] autorelease]; }

+ (id)coupleWithCouple:(MSCouple *)aCouple
{ return [[[self alloc] initWithFirstMember:[aCouple firstMember] secondMember:[aCouple secondMember]] autorelease]; }

- (id)initWithFirstMember:(id)o1 secondMember:(id)o2
{ _members[0] = [o1 retain]; _members[1] = [o2 retain]; return self; }

- (id)initWithCouple:(MSCouple *)aCouple
{ return [self initWithFirstMember:[aCouple firstMember] secondMember:[aCouple secondMember]] ; }

- (id)initWithMembers:(id *)members { if (members) { _members[0] = [members[0]retain] ; _members[1] = [members[1]retain] ; } return self ; }


- (void)dealloc { [_members[0]release]; [_members[1]release]; [super dealloc]; }

- (id)firstMember {return _members[0] ;}
- (id)secondMember {return _members[1] ;}

- (BOOL)isEqual:(id)o
{
    if (o == self) return YES ;
    return [o isKindOfClass:__MSCoupleClass] && MSEqualObjects(_members[0], [o firstMember]) && MSEqualObjects(_members[1], [o secondMember]) ;
}

- (BOOL)isEqualToCouple:(MSCouple *)couple
{
    if (couple == self) return YES ;
    return MSEqualObjects(_members[0], [couple firstMember]) && MSEqualObjects(_members[1], [couple secondMember]) ;
}

// we use quite the same description as NSArray
// the difference is that we can have null values here
- (NSString *)toString
{
	return [NSString stringWithFormat:@"[%@,%@]", 
			(_members[0] ? [_members[0] listItemString] : @"null"),
			(_members[1] ? [_members[1] listItemString] : @"null")] ;
}

- (NSString *)description { return [self toString] ; }
- (NSString *)displayString
{ 
	return ([_members[0] length] ? 
			( [_members[1] length] ? [NSString stringWithFormat:@"%@, %@", _members[0], _members[1]] : _members[0]) :
			( [_members[1] length] ? _members[1] : @"")); 
}

- (NSArray *)allObjects
{ 
    if (_members[0]) {
        return [NSArray arrayWithObjects:_members count:(_members[1] ? 2 : 1)] ;
    }
    if (_members[1]) return [NSArray arrayWithObject:_members[1]] ;
	
    return [NSArray array] ;
}

- (NSEnumerator *)objectEnumerator
{ return (NSEnumerator *)[[[_MSCoupleEnumerator alloc ]initWithCouple:self position:-1] autorelease] ; }

- (NSEnumerator *)reverseObjectEnumerator
{ return (NSEnumerator *)[[[_MSCoupleEnumerator alloc] initWithCouple:self position:2] autorelease] ; }

- (BOOL)isTrue { return [_members[0] isTrue] && [_members[1] isTrue] ; }


// ===================== NSCODING PROTOCOL ======================================
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ([aDecoder allowsKeyedCoding]) {
		_members[0] = [[aDecoder decodeObjectForKey:@"first"]retain] ;
		_members[1] = [[aDecoder decodeObjectForKey:@"second"]retain] ;
	}
	else {
    	[aDecoder decodeValuesOfObjCTypes:"@@",&_members] ;
	}
    return self;
}

- (id)replacementObjectForPortCoder:(NSPortCoder *)encoder
{
    if ([encoder isBycopy]) return self;
    return [super replacementObjectForPortCoder:encoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if ([aCoder allowsKeyedCoding]) {
		[aCoder encodeObject:_members[0] forKey:@"first"] ;
		[aCoder encodeObject:_members[1] forKey:@"second"] ;
	}
	else {
    	[aCoder encodeValuesOfObjCTypes:"@@",_members] ;
	}
}

// ===================== NSCOPYING AND MUTABLE COPYING PROTOCOL ======================================
- (id)mutableCopyWithZone:(NSZone *)zone { return [[MSMutableCouple allocWithZone:zone] initWithFirstMember:_members[0] secondMember:_members[1]] ; }
- (id)copyWithZone:(NSZone *)zone { return zone == [self zone] ? [self retain] : [[isa allocWithZone:zone]  initWithFirstMember:_members[0] secondMember:_members[1]] ; }

@end


MSMutableCouple *MSCreateMutableCouple(id first, id second) 
{
    MSMutableCouple *c = (MSMutableCouple *)MSCreateObject(__MSMutableCoupleClass) ;
    if (c) {
        c->_members[0] = [first retain] ;
        c->_members[1] = [second retain] ;
    }
    return c ;
}

@implementation MSMutableCouple

+ (void)load { if (!__MSMutableCoupleClass) __MSMutableCoupleClass = [self class] ; }
- (void)setFirstMember:(id)firstMember { ASSIGN(_members[0], firstMember) ; }
- (void)setSecondMember:(id)secondMember { ASSIGN(_members[1], secondMember) ; }
- (void)setCouple:(MSCouple *)couple
{
    ASSIGN(_members[0], [couple firstMember]) ;
    ASSIGN(_members[1], [couple secondMember]) ;
}

// ===================== NSCOPYING AND MUTABLE COPYING PROTOCOL ======================================
- (id)mutableCopyWithZone:(NSZone *)zone { return [[isa allocWithZone:zone] initWithFirstMember:_members[0] secondMember:_members[1]] ; }
- (id)copyWithZone:(NSZone *)zone { return [[MSCouple allocWithZone:zone]  initWithFirstMember:_members[0] secondMember:_members[1]] ; }

@end

@implementation _MSCoupleEnumerator
- (id)initWithCouple:(MSCouple *)aCouple position:(NSInteger)position
{
    if (!(self = [super init])) return nil ;
    _enumeredCouple = [aCouple retain] ;
	_position = position ;
	
    return self ;
}

- (void)dealloc { [_enumeredCouple release] ; [super dealloc] ; }

- (id)nextObject
{
    id theObject = nil ;
	
    switch (_position) {
		case 2:
            theObject = [_enumeredCouple secondMember] ;
			_position = 1 ;
			if (theObject) break ;
        case 1 :
            theObject = [_enumeredCouple firstMember] ;
			_position = NSNotFound ;
            break ;
		case -1:
            theObject = [_enumeredCouple firstMember] ;
			_position = 0 ;
			if (theObject) break ;
        case 0 :
            theObject = [_enumeredCouple secondMember] ;
			_position = NSNotFound ;
            break ;
        default :
            break ;
    }
    return theObject ;
}
@end

