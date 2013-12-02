/*
 
 MSObjectAdditions.m
 
 This file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
Herve Malaingre : herve@malaingre.com
Jean-Michel Bertheas :  jean-michel.bertheas@club-internet.fr

 
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



#import "MSObjectAdditions.h"

@implementation NSObject (MSObjectAdditions)

- (NSString *)toString { return @"" ; }
- (NSString *)listItemString { return [self toString] ; }

- (BOOL)isTrue { return NO ; }
- (BOOL)isNull { return NO ; }
- (BOOL)isSignificant { return YES ; }


- (NSString *)className { return NSStringFromClass(isa) ; }
+ (NSString *)className { return NSStringFromClass((Class)self) ; }

#ifndef GNUSTEP
- (id)notImplemented:(SEL)aSel // for Gnustep compatibilkity
{
	if (aSel) [NSException raise:NSGenericException format:@"method not implemented - %@", NSStringFromSelector(aSel)] ;
	else [NSException raise:NSGenericException format:@"method not implemented"] ;
	return nil ;
}
#endif

- (id)notYetImplemented:(SEL)aSel ;
{ [NSException raise:NSGenericException format:@"hey dude, this method should be implemented!"] ; return nil ;}


@end

@implementation NSString (MSObjectAdditions)

- (NSString *)toString { return self ; }

@end

@implementation NSData (MSDataAdditions)

- (MSUInt)longCRC { return _MSLongCRC((void *)[self bytes], [self length]) ; }

@end

/************************************************************************
	NSString completude to toString, listeItemString, isTrue, etc is 
	in MSStringAdditions file
 *************************************************************************/

@implementation NSNumber (MSObjectAdditions)
- (BOOL)isTrue
{
    const char *c = [self objCType] ;
    if (c) {
        switch (*c) {
            case 'f':
                return ([self floatValue] == (float)0.0 ? NO : YES) ;
            case 'd':
                return ([self doubleValue] == (double)0.0 ? NO : YES) ;
            case 'q':
                return ([self longLongValue] == 0 ? NO : YES) ;
            case 'Q':
                return ([self unsignedLongLongValue] == 0 ? NO : YES) ;
            default:
                return ([self intValue] == 0 ? NO : YES) ;
        }
    }
    return NO ;
}

- (NSString *)toString { return [self description] ; }

@end

@implementation NSDecimalNumber (MSObjectAdditions)
#if defined(WO451)
 - (BOOL)isTrue { return (_length == 0 ? NO : (_mantissa[0] == 0 ? NO : YES)) ; } // if it's not a number it's not true
#else
- (BOOL)isTrue { NSDecimal d = [self decimalValue] ; return (d._length == 0 ? NO : (d._mantissa[0] == 0 ? NO : YES)) ; }
#endif
@end

@implementation NSNull (MSObjectAdditions)
- (NSString *)description { return @"" ; }
- (NSString *)toString { return @"null" ; }
- (NSString *)listItemString { return @"null" ; }


- (BOOL)isNull { return YES ; }
- (BOOL)isSignificant { return NO ; }
@end

BOOL MSUnicharIsHexa(unichar c) { return ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f')) ; }


/************************** TO DO IN THIS FILE  ****************
 
 (1)	a more efficient NSNumber toString method
 (2)	a better isTrue method on NSDecimalNumber. On MacOSX
	the WO451 implementation gives 2 links error
 
 *************************************************************/

