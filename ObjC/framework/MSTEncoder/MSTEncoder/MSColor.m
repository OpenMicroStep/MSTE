/*
 
 MSColor.m
 
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

#import "_MSColorPrivate.h"

#define MS_COLOR_LAST_VERSION		201

@implementation MSColor
+ (void)initialize
{
    if ([self class] == [MSColor class]) {
        [MSColor setVersion:MS_COLOR_LAST_VERSION] ;
    }
}

//+ (MSColor *)colorWithName:(NSString *)name { return MSColorNamed(name) ; }

+ (MSColor *)colorWithRGBAValue:(MSUInt)color
{ return [MSCreateColor(color)autorelease] ; }

+ (MSColor *)colorWithCSSValue:(MSUInt)color ; // TTRRGGBB
{ return [MSCreateCSSColor(color) autorelease] ; }

+ (MSColor *)colorWithRed:(MSByte)red green:(MSByte)green blue:(MSByte)blue
{ return [_MSCreateColor(red, green, blue, OPAQUE_COLOR)autorelease] ; }

+ (MSColor *)colorWithRed:(MSByte)red green:(MSByte)green blue:(MSByte)blue opacity:(MSByte)alpha
{ return [_MSCreateColor(red, green, blue, alpha) autorelease] ; }

+ (MSColor *)colorWithRedComponent:(float)red greenComponent:(float)green blueComponent:(float)blue
{ return [_MSCreateComponentsColor(red, green, blue, 1.0) autorelease] ; }

+ (MSColor *)colorWithRedComponent:(float)red greenComponent:(float)green blueComponent:(float)blue alphaComponent:(float)alpha
{ return [_MSCreateComponentsColor(red, green, blue, alpha) autorelease] ; }

- (BOOL)isTrue { return ([self opacity] > 0 ? YES : NO) ; }

- (BOOL)isEqual:(id)object
{
	if (object == (id)self) return YES ;
	if (!object || ![object conformsToProtocol:@protocol(MSColor)]) return NO ;
	return [self rgbaValue] == [(id <MSColor>)object rgbaValue] ;
}

- (unsigned int)unsignedIntValue { return (unsigned int)[self rgbaValue] ; }

- (NSString *)toString { return ([self opacity] == OPAQUE_COLOR ? [NSString stringWithFormat:@"#%02x%02x%02x", [self red], [self green], [self blue]] : [NSString stringWithFormat:@"#%02x%02x%02x%02x", [self transparency], [self red], [self green], [self blue]]) ; }
- (NSString *)description { return [NSString stringWithFormat:@"<color #%02x%02x%02x%02x>", [self red], [self green], [self blue], [self opacity]] ; }
- (NSString *)htmlRepresentation { return [NSString stringWithFormat:@"#%02x%02x%02x", [self red], [self green], [self blue]] ; } // html representation does not know about opacity

// MSColor protocol ============================================================
- (float)redComponent { return ((float)[self red])/255.0 ; }
- (float)greenComponent { return ((float)[self green])/255.0 ; }
- (float)blueComponent { return ((float)[self blue])/255.0 ; }
- (float)alphaComponent { return ((float)[self opacity])/255.0 ; }
- (float)cyanComponent
{
	float C = 1.0 - ((float)[self red])/255.0 ;
	float M = 1.0 - ((float)[self green])/255.0 ;
	float Y = 1.0 - ((float)[self blue])/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	if (K >= 1.0) return 0.0 ;
	return (C - K) / (1 - K) ;
	
}

- (float)magentaComponent
{
	float C = 1.0 - ((float)[self red])/255.0 ;
	float M = 1.0 - ((float)[self green])/255.0 ;
	float Y = 1.0 - ((float)[self blue])/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	if (K >= 1.0) return 0.0 ;
	return (M - K) / (1 - K) ;
}


- (float)yellowComponent
{
	float C = 1.0 - ((float)[self red])/255.0 ;
	float M = 1.0 - ((float)[self green])/255.0 ;
	float Y = 1.0 - ((float)[self blue])/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	if (K >= 1.0) return 0.0 ;
	return (Y - K) / (1 - K) ;
}

- (float)blackComponent
{
	float C = 1.0 - ((float)[self red])/255.0 ;
	float M = 1.0 - ((float)[self green])/255.0 ;
	float Y = 1.0 - ((float)[self blue])/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	return K ;
}

// this 4 methods are considered as internal primitives for MSColor
- (MSByte)red { return 0 ; }
- (MSByte)green { return 0 ; }
- (MSByte)blue { return 0 ; }
- (MSByte)opacity { return 255 ; }
- (MSByte)transparency { return 255 - [self opacity] ; }

- (BOOL)isPaleColor { return _MSIsPaleColor([self red], [self green], [self blue], [self opacity]) ; }
- (float)luminance { return _MSColorLuminance([self red], [self green], [self blue], [self opacity]) ; }
- (MSUInt)rgbaValue { return (((MSUInt)[self red]) << 24) | (((MSUInt)[self green]) << 16) | (((MSUInt)[self blue]) << 8) | ((MSUInt)[self opacity]) ; }
- (MSUInt)cssValue { return (((MSUInt)[self transparency]) << 24) | (((MSUInt)[self red]) << 16) | (((MSUInt)[self green]) << 8) | ((MSUInt)[self blue]) ; }

- (id <MSColor>)lighterColor
{
    float rf = [self redComponent] ;
    float gf = [self greenComponent] ;
    float bf = [self blueComponent] ;
    return _MSCreateComponentsColor(LIGHTER(rf), LIGHTER(gf), LIGHTER(bf), [self alphaComponent]) ;
}

- (id <MSColor>)darkerColor
{
    float rf = [self redComponent] ;
    float gf = [self greenComponent] ;
    float bf = [self blueComponent] ;
    return _MSCreateComponentsColor(DARKER(rf), DARKER(gf), DARKER(bf), [self alphaComponent]) ;
}

- (id <MSColor>)lightestColor
{
    float rf = [self redComponent] ;
    float gf = [self greenComponent] ;
    float bf = [self blueComponent] ;
	rf = LIGHTER(rf) ;
    gf = LIGHTER(gf) ;
    bf = LIGHTER(bf) ;
	return _MSCreateComponentsColor(LIGHTER(rf), LIGHTER(gf), LIGHTER(bf), [self alphaComponent]) ;
}

- (id <MSColor>)darkestColor
{
    float rf = [self redComponent] ;
    float gf = [self greenComponent] ;
    float bf = [self blueComponent] ;
	rf = DARKER(rf) ;
    gf = DARKER(gf) ;
    bf = DARKER(bf) ;
    return _MSCreateComponentsColor(DARKER(rf), DARKER(gf), DARKER(bf), [self alphaComponent]) ;
}

- (id <MSColor>)matchingVisibleColor { return _MSIsPaleColor([self red], [self green], [self blue], [self opacity]) ? [self darkestColor] : [self lightestColor] ; }

- (id <MSColor>)colorWithAlpha:(MSByte)opacity
{ return _MSCreateColor([self red], [self green], [self blue], opacity) ; }



- (BOOL)isEqualToColorObject:(id <MSColor>)color
{
	if (color == (id <MSColor>)self) return YES ;
	if (!color) return NO ;
	return [self rgbaValue] == [color rgbaValue] ;
}

- (NSComparisonResult)compareToColorObject:(id <MSColor>)color
{
	MSUInt a, b ;
	
	if (color == (id <MSColor>)self) return NSOrderedSame ;
	if (!color) return NSOrderedDescending ;
	
	a = [self rgbaValue] ; b = [color rgbaValue] ;
	if (a < b) return NSOrderedAscending ;
	if (b > a) return NSOrderedDescending ;
	
	return NSOrderedSame ;
}

// NSCoding protocol ============================================================
- (Class)classForCoder { return __MSColorClass ; }
- (Class)classForAchiver { return [self classForCoder] ; }
- (Class)classForPortCoder { return [self classForCoder] ; }

- (id)replacementObjectForPortCoder:(NSPortCoder *)encoder
{
    if ([encoder isBycopy]) return self;
    return [super replacementObjectForPortCoder:encoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	MSUInt u = [self rgbaValue] ;
	if ([aCoder allowsKeyedCoding]) {
		MSInt i = *((MSInt *)&u) ;
		[aCoder encodeInt32:i forKey:@"color"] ;
	}
	else {
		[aCoder encodeValueOfObjCType:@encode(MSUInt) at:&u] ;
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder { RELEASE(self) ; return nil ; } // this class must not be dearchived


// NSCopying protocol ============================================================
- (id)copyWithZone:(NSZone *)zone
{
	_MSRGBAColor *ret ;
	if ([self zone] == zone) return RETAIN(self) ;
	ret = [_MSRGBAColor allocWithZone:zone] ;
	if (ret) {
		ret->_color.r = [self red] ;
		ret->_color.g = [self green] ;
		ret->_color.b = [self blue] ;
		ret->_color.a = [self opacity] ;
	}
	return ret ;
}

@end

#define MS_RGBACOLOR_LAST_VERSION	301

@implementation _MSRGBAColor : MSColor
+ (void)load { if (!__MSColorClass) {  __MSColorClass = [_MSRGBAColor class] ; }}
+ (void)initialize
{
    if ([self class] == [_MSRGBAColor class]) {
        [_MSRGBAColor setVersion:MS_RGBACOLOR_LAST_VERSION] ;
    }
}

- (BOOL)isTrue { return (_color.a > 0 ? YES : NO) ; }
- (BOOL)isEqual:(id)object
{
	if (object == (id)self) return YES ;
	if (!object || ![object conformsToProtocol:@protocol(MSColor)]) return NO ;
	return ((((MSUInt)(_color.r)) << 24) | (((MSUInt)(_color.g)) << 16) | (((MSUInt)(_color.b)) << 8) | ((MSUInt)(_color.a))) == [(id <MSColor>)object rgbaValue] ;
}
- (unsigned int)unsignedIntValue { return (((unsigned int)(_color.r)) << 24) | (((unsigned int)(_color.g)) << 16) | (((unsigned int)(_color.b)) << 8) | ((unsigned int)(_color.a)) ; }

- (NSString *)toString { return (_color.a == OPAQUE_COLOR ? [NSString stringWithFormat:@"#%02x%02x%02x", _color.r, _color.g, _color.b] : [NSString stringWithFormat:@"#%02x%02x%02x%02x", 255-_color.a, _color.r, _color.g, _color.b]) ; }
- (NSString *)listItemString { return (_color.a == OPAQUE_COLOR ? [NSString stringWithFormat:@"#%02x%02x%02x", _color.r, _color.g, _color.b] : [NSString stringWithFormat:@"#%02x%02x%02x%02x", 255-_color.a, _color.r, _color.g, _color.b]) ; }
- (NSString *)displayString { return (_color.a == OPAQUE_COLOR ? [NSString stringWithFormat:@"#%02x%02x%02x", _color.r, _color.g, _color.b] : [NSString stringWithFormat:@"#%02x%02x%02x%02x", 255-_color.a, _color.r, _color.g, _color.b]) ; }
- (NSString *)htmlRepresentation { return [NSString stringWithFormat:@"#%02x%02x%02x", _color.r, _color.g, _color.b] ; } // html representation does not know about opacity

- (NSString *)description { return [NSString stringWithFormat:@"<color #%02x%02x%02x%02x>", _color.r, _color.g, _color.b, _color.a] ; }

- (NSString *)jsonRepresentation { return [NSString stringWithFormat:@"\"%@\"", [self toString]] ; }

// MSColor protocol ============================================================
- (float)redComponent { return ((float)(_color.r))/255.0 ; }
- (float)greenComponent { return ((float)(_color.g))/255.0 ; }
- (float)blueComponent { return ((float)(_color.b))/255.0 ; }
- (float)alphaComponent { return ((float)(_color.a))/255.0 ; }
- (float)cyanComponent
{
	float C = 1.0 - ((float)(_color.r))/255.0 ;
	float M = 1.0 - ((float)(_color.g))/255.0 ;
	float Y = 1.0 - ((float)(_color.b))/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	if (K >= 1.0) return 0.0 ;
	return (C - K) / (1 - K) ;
	
}

- (float)magentaComponent
{
	float C = 1.0 - ((float)(_color.r))/255.0 ;
	float M = 1.0 - ((float)(_color.g))/255.0 ;
	float Y = 1.0 - ((float)(_color.b))/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	if (K >= 1.0) return 0.0 ;
	return (M - K) / (1 - K) ;
}


- (float)yellowComponent
{
	float C = 1.0 - ((float)(_color.r))/255.0 ;
	float M = 1.0 - ((float)(_color.g))/255.0 ;
	float Y = 1.0 - ((float)(_color.b))/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	if (K >= 1.0) return 0.0 ;
	return (Y - K) / (1 - K) ;
}

- (float)blackComponent
{
	float C = 1.0 - ((float)(_color.r))/255.0 ;
	float M = 1.0 - ((float)(_color.g))/255.0 ;
	float Y = 1.0 - ((float)(_color.b))/255.0 ;
	float K = 1.0 ;
	if ( C < K ) K = C ;
	if ( M < K ) K = M ;
	if ( Y < K ) K = Y ;
	return K ;
}

// this 4 methods are considered as internal primitives for MSColor
- (MSByte)red { return _color.r ; }
- (MSByte)green { return _color.g ; }
- (MSByte)blue { return _color.b ; }
- (MSByte)opacity { return _color.a ; }
- (MSByte)transparency { return 255-_color.a ; }

- (BOOL)isPaleColor { return _MSIsPaleColor(_color.r, _color.g, _color.b, _color.a) ; }
- (float)luminance { return _MSColorLuminance(_color.r, _color.g, _color.b, _color.a) ; }
- (MSUInt)rgbaValue { return (((MSUInt)(_color.r)) << 24) | (((MSUInt)(_color.g)) << 16) | (((MSUInt)(_color.b)) << 8) | ((MSUInt)(_color.a)) ; }
- (MSUInt)cssValue { return (((MSUInt)(255-_color.a)) << 24) | (((MSUInt)(_color.r)) << 16) | (((MSUInt)(_color.g)) << 8) | ((MSUInt)(_color.b)) ; }

- (id <MSColor>)lighterColor
{
    float rf = ((float)(_color.r))/255.0 ;
    float gf = ((float)(_color.g))/255.0 ;
    float bf = ((float)(_color.b))/255.0 ;
    return _MSCreateComponentsColor(LIGHTER(rf), LIGHTER(gf), LIGHTER(bf), ((float)(_color.a))/255.0) ;
}

- (id <MSColor>)darkerColor
{
    float rf = ((float)(_color.r))/255.0 ;
    float gf = ((float)(_color.g))/255.0 ;
    float bf = ((float)(_color.b))/255.0 ;
    return _MSCreateComponentsColor(DARKER(rf), DARKER(gf), DARKER(bf), ((float)(_color.a))/255.0) ;
}

- (id <MSColor>)lightestColor
{
    float rf = ((float)(_color.r))/255.0 ;
    float gf = ((float)(_color.g))/255.0 ;
    float bf = ((float)(_color.b))/255.0 ;
	rf = LIGHTER(rf) ;
    gf = LIGHTER(gf) ;
    bf = LIGHTER(bf) ;
	return _MSCreateComponentsColor(LIGHTER(rf), LIGHTER(gf), LIGHTER(bf), ((float)(_color.a))/255.0) ;
}

- (id <MSColor>)darkestColor
{
    float rf = ((float)(_color.r))/255.0 ;
    float gf = ((float)(_color.g))/255.0 ;
    float bf = ((float)(_color.b))/255.0 ;
	rf = DARKER(rf) ;
    gf = DARKER(gf) ;
    bf = DARKER(bf) ;
    return _MSCreateComponentsColor(DARKER(rf), DARKER(gf), DARKER(bf), ((float)(_color.a))/255.0) ;
}

- (id <MSColor>)matchingVisibleColor { return _MSIsPaleColor(_color.r, _color.g, _color.b, _color.a) ? [self darkestColor] : [self lightestColor] ; }
- (id <MSColor>)colorWithAlpha:(MSByte)opacity
{ return _MSCreateColor(_color.r, _color.g, _color.b, opacity) ; }



- (BOOL)isEqualToColorObject:(id <MSColor>)color
{
	if (color == (id <MSColor>)self) return YES ;
	if (!color) return NO ;
	return ((((MSUInt)(_color.r)) << 24) | (((MSUInt)(_color.g)) << 16) | (((MSUInt)(_color.b)) << 8) | ((MSUInt)(_color.a))) == [color rgbaValue] ;
}

- (NSComparisonResult)compareToColorObject:(id <MSColor>)color
{
	MSUInt a, b ;
	
	if (color == (id <MSColor>)self) return NSOrderedSame ;
	if (!color) return NSOrderedDescending ;
	
	a = (((MSUInt)(_color.r)) << 24) | (((MSUInt)(_color.g)) << 16) | (((MSUInt)(_color.b)) << 8) | ((MSUInt)(_color.a)) ;
	b = [color rgbaValue] ;
	if (a < b) return NSOrderedAscending ;
	if (b > a) return NSOrderedDescending ;
	
	return NSOrderedSame ;
}

// NSCopying protocol ============================================================
- (id)copyWithZone:(NSZone *)zone
{
	_MSRGBAColor *ret ;
	if ([self zone] == zone) return RETAIN(self) ;
	ret = [_MSRGBAColor allocWithZone:zone] ;
	if (ret) {
		ret->_color.r = _color.r ;
		ret->_color.g = _color.g ;
		ret->_color.b = _color.b ;
		ret->_color.a = _color.a ;
	}
	return ret ;
}

// NSCoding protocol ============================================================
- (id)initWithCoder:(NSCoder *)aDecoder
{
	MSUInt value ;
	if ([aDecoder allowsKeyedCoding]) {
		MSInt v = [aDecoder decodeInt32ForKey:@"color"] ;
		value = *((MSUInt *)&v) ;
	}
	else {
		[aDecoder decodeValueOfObjCType:@encode(MSUInt) at:&value] ;
	}
	_color.r = (MSByte)((value >> 24) & 0xff) ;
	_color.g = (MSByte)((value >> 16) & 0xff) ;
	_color.b = (MSByte)((value >> 8) & 0xff) ;
	_color.a = (MSByte)(value & 0xff) ;
	return self ;
}


@end




MSColor *MSCreateColor(MSUInt rgba)
{
	_MSRGBAColor *ret = (_MSRGBAColor *)MSCreateObject(__MSColorClass) ;
	if (ret) {
		ret->_color.r = (MSByte)((rgba >> 24) & 0xff) ;
		ret->_color.g = (MSByte)((rgba >> 16) & 0xff) ;
		ret->_color.b = (MSByte)((rgba >> 8) & 0xff) ;
		ret->_color.a = (MSByte)(rgba & 0xff) ;
	}
	return (MSColor *)ret ;
}

MSColor *MSCreateCSSColor(MSUInt trgb)
{
	_MSRGBAColor *ret = (_MSRGBAColor *)MSCreateObject(__MSColorClass) ;
	if (ret) {
		ret->_color.a = (MSByte)(255 - ((trgb >> 24) & 0xff)) ;
		ret->_color.r = (MSByte)((trgb >> 16) & 0xff) ;
		ret->_color.g = (MSByte)((trgb >> 8) & 0xff) ;
		ret->_color.b = (MSByte)(trgb & 0xff) ;
	}
	return (MSColor *)ret ;
}



#define MS_INDEXEDCOLOR_LAST_VERSION	401

@implementation _MSIndexedColor
+ (void)load { if (!__MSIndexedColorClass) {  __MSIndexedColorClass = [_MSIndexedColor class] ; }}
+ (void)initialize
{
    if ([self class] == [_MSIndexedColor class]) {
        [_MSIndexedColor setVersion:MS_INDEXEDCOLOR_LAST_VERSION] ;
    }
}
- (oneway void)release {}
- (id)retain { return self ;}
- (id)autorelease { return self ;}
- (void)dealloc {if (0) [super dealloc];} // No warning
- (Class)classForCoder { return __MSIndexedColorClass ; }
- (id)copyWithZone:(NSZone *)zone { return self ; }
- (id)copy { return self ; }
- (id)initWithCoder:(NSCoder *)aDecoder
{
	int i = -1 ;
	if ([aDecoder allowsKeyedCoding]) {
		i = [aDecoder decodeIntForKey:@"color-index"] ;
	}
	else {
		[aDecoder decodeValueOfObjCType:@encode(int) at:&i] ;
	}
	RELEASE(self) ;


	return nil ;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if ([aCoder allowsKeyedCoding]) {
		[aCoder encodeInt:_colorIndex forKey:@"color-index"] ;
	}
	else {
		[aCoder encodeValueOfObjCType:@encode(int) at:&_colorIndex] ;
	}
}

- (NSString *)htmlRepresentation { return _name ; }

@end




