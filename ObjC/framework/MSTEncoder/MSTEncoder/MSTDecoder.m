/*
 
 MSTDecoder.m
 
 This file is is a part of the MicroStep Framework.
 
 Initial copyright Herve MALAINGRE and Eric BARADAT (1996)
 Contribution from LOGITUD Solutions (logitud@logitud.fr) since 2011
 
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
 
 WARNING : this header file cannot be included alone, please direclty
 include <MSFoundation/MSFoundation.h>
 */





#define MSTE_DECODING_ARRAY_START               0
#define MSTE_DECODING_VERSION_START             1
#define MSTE_DECODING_VERSION_HEADER            2
#define MSTE_DECODING_VERSION_VALUE             3
#define MSTE_DECODING_VERSION_END               4
#define MSTE_DECODING_VERSION_NEXT_TOKEN        5
#define MSTE_DECODING_TOKEN_NUMBER_VALUE        6
#define MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN   7
#define MSTE_DECODING_CRC_START                 8
#define MSTE_DECODING_CRC_HEADER                9
#define MSTE_DECODING_CRC_VALUE                 10
#define MSTE_DECODING_CRC_END                   11
#define MSTE_DECODING_CRC_NEXT_TOKEN            12
#define MSTE_DECODING_CLASSES_NUMBER_VALUE      13
#define MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN 14
#define MSTE_DECODING_CLASS_NAME                15
#define MSTE_DECODING_CLASS_NEXT_TOKEN          16
#define MSTE_DECODING_KEYS_NUMBER_VALUE         17
#define MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN    18
#define MSTE_DECODING_KEY_NAME                  19
#define MSTE_DECODING_KEY_NEXT_TOKEN            20
#define MSTE_DECODING_ROOT_OBJECT               21
#define MSTE_DECODING_ARRAY_END                 22
#define MSTE_DECODING_GLOBAL_END                23

#define MSTE_DECODING_STRING_START              0
#define MSTE_DECODING_STRING                    1
#define MSTE_DECODING_STRING_ESCAPED_CAR        2
#define MSTE_DECODING_STRING_STOP               3

#import "MSTDecoder.h"


static NSNull *__theNull = nil ;
static NSDate *__theDistantPast = nil ;
static NSDate *__theDistantFuture = nil ;

void _MSTJumpToNextToken(unsigned char **pointer, unsigned char *endPointer, MSULong *tokenCount) ;

/* Primitives to use for decoding basic types */
MSByte _MSTDecodeUnsignedChar(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSChar _MSTDecodeChar(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSUShort _MSTDecodeUnsignedShort(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSShort _MSTDecodeShort(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSUInt _MSTDecodeUnsignedInt(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSInt _MSTDecodeInt(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSULong _MSTDecodeUnsignedLong(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
MSLong _MSTDecodeLong(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
float _MSTDecodeFloat(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
double _MSTDecodeDouble(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;

/* Primitives to use for decoding simple objects */
NSString *_MSTDecodeString(unsigned char **pointer, unsigned char *endPointer, NSString *operation) ;
NSNumber *_MSTDecodeNumber(unsigned char **pointer, unsigned char *endPointer, MSShort tokenType, NSZone *zone) ;
NSMutableDictionary *_MSTDecodeDictionary(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL manageReference, BOOL decodingUserClass, BOOL allowsUnknownUserClasses, NSZone *zone) ;
NSMutableArray *_MSTDecodeArray(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL allowsUnknownUserClasses, NSZone *zone) ;
NSMutableArray *_MSTDecodeNaturalArray(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, MSULong *tokenCount, NSZone *zone) ;
MSMutableCouple *_MSTDecodeCouple(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL allowsUnknownUserClasses, NSZone *zone) ;
NSData *_MSTDecodeBufferBase64String(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSZone *zone) ;
NSData *_MSTDecodeBufferHexaString(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSZone *zone) ;
MSColor *_MSTDecodeColor(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSZone *zone) ;

/* Primitives to use for decoding an object */
id _MSTDecodeObject(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL *isWeaklyReferenced, BOOL allowsUnknownUserClasses, NSZone *zone) ;


id _MSTDecodeUserDefinedObject(unsigned char **pointer, unsigned char *endPointer, NSString *operation, MSByte tokenType, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL allowsUnknownUserClasses, NSZone *zone) ;

// encode 3 octets vers 4 caracteres ASCII
void encodeblock( const unsigned char *in, unsigned char *out, int len )
{
    out[0] = (unsigned char) cb64[ (int)(in[0] >> 2) ];
    out[1] = (unsigned char) cb64[ (int)(((in[0] & 0x03) << 4) | ((in[1] & 0xf0) >> 4)) ];
    out[2] = (unsigned char) (len > 1 ? cb64[ (int)(((in[1] & 0x0f) << 2) | ((in[2] & 0xc0) >> 6)) ] : '=');
    out[3] = (unsigned char) (len > 2 ? cb64[ (int)(in[2] & 0x3f) ] : '=');
}

// decode 4 caracteres ASCII vers 3 octets
void decodeblock( const unsigned char *in, unsigned char *out )
{
    out[0] = (unsigned char) (in[0] << 2 | in[1] >> 4);
    out[1] = (unsigned char) (in[1] << 4 | in[2] >> 2);
    out[2] = (unsigned char) (((in[2] << 6) & 0xc0) | in[3]);
}

NSData * Base64FromBytes(const unsigned char * str, NSUInteger len)
{
    NSMutableData * ret = [[NSMutableData alloc] init] ;
    NSUInteger d = len / 3 ;
    NSUInteger r = len % 3 ;
    NSUInteger i;
    const unsigned char *ptr = str;
    unsigned char buff_C[5] ;
    buff_C[4] = 0;
    
    for(i=0; i<d; i++)
    {
        encodeblock(ptr, buff_C, 3);
        [ret appendBytes:(const void*)&buff_C length:4] ;
        ptr += 3;
    }
    if(r)
    {
        memset(buff_C, 0, 4);
        encodeblock(ptr, buff_C, (int)r);
        [ret appendBytes:(const void*)&buff_C length:strlen((char *)buff_C)] ;
    }
    return [ret autorelease] ;
}

NSData * NSDataFromBase64(const unsigned char * str, unsigned long len)
{
    NSMutableData * ret = [[NSMutableData alloc] init] ;
    unsigned long d = len / 4 ;
    unsigned long i, j;
    unsigned long v, n;
    const unsigned char *ptr = str;
    unsigned char buff_M[4] ;
    unsigned char buff_C[5] ;
    buff_C[4] = 0;
    buff_M[3] = 0;
    
    for(i=0; i<d; i++)
    {
        strncpy((char *)buff_C, (char *)ptr, 4);
        v = 0;
        n = 0;
        for(j=0; j<4; j++)
        {
            if(ptr[j] == '=') n++;
            v = ptr[j];
            v = ((v < 43 || v > 122) ? 0 : (int) cd64[ v - 43 ]);
            if(v) v = ((v == (int)'$') ? 0 : v - 61);
            buff_C[j] = (unsigned char) (v - 1);
        }
        decodeblock(buff_C, buff_M);
        if(n == 2)
            [ret appendBytes:(const void*)&buff_M length:1] ;
        else if(n == 1)
            [ret appendBytes:(const void*)&buff_M length:2] ;
        else
            [ret appendBytes:(const void*)&buff_M length:3] ;
        ptr += 4;
    }
    return [ret autorelease] ;
}



static inline MSByte _hexaCharacterToShortValue(unichar c)
{
    if (c >= 48) {
        if (c <= 57) { //'0' to '9'
            return (MSByte)(c - 48) ;
        }
        else if (c >= 65) {
            if (c <= 70) { //'A' to 'F'
                return (MSByte)(c - 55);
            }
            else if ((c >= 97) && (c <= 102)) { //'a' to 'f'
                return (MSByte)(c - 87) ;
            }
        }
    }
    [NSException raise:NSGenericException format:@"_hexaCharacterToShortValue - not an hexadecimal character %c", c] ;
    return 0 ;
}


void _MSTJumpToNextToken(unsigned char **pointer, unsigned char *endPointer, MSULong *tokenCount)
{
    unsigned char *s = (unsigned char *)*pointer ;
    
    BOOL separatorFound = NO ;
    BOOL nextFound = NO ;
    while (!separatorFound && (endPointer-s)) {
        if (*s == (unichar)' ') { s++ ; }
        else if (*s == (unichar)',') { s++ ; separatorFound = YES ; (*tokenCount)++ ; }
        else [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad format (unexpected character before token separator: %u)", *s] ;
    }
    if (!separatorFound) [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad format (no token separator)"] ;
     
    while (!nextFound && (endPointer-s)) {
        if (*s == (unichar)' ') { s++ ; }
        nextFound = (*s != (unichar)' ') ;
    }
    if (!separatorFound) [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad format (no next token)"] ;

    *pointer = s ;
}

MSByte _MSTDecodeUnsignedChar(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSULong result = strtoull((const char *)s, &stopCar, 10) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedChar - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        if (result>MSByteMax) [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedChar - out of range (%llu)", result] ;
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedChar - %@ (no termination)", operation] ;
    
    return (MSByte)result ;
}

MSChar _MSTDecodeChar(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSLong result = strtoll((const char *)s, &stopCar, 10) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeChar - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        if ((result>MSCharMax) || (result<MSCharMin)) [NSException raise:NSGenericException format:@"_MSTDecodeChar - out of range (%lld)", result] ;
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeChar - %@ (no termination)", operation] ;

    return (MSChar)result ;
}

MSUShort _MSTDecodeUnsignedShort(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSULong result = strtoull((const char *)s, &stopCar, 10) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedShort - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        if (result>MSUShortMax) [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedShort - out of range (%llu)", result] ;
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedShort - %@ (no termination)", operation] ;
    
    return (MSUShort)result ;
}

MSShort _MSTDecodeShort(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSLong result = strtoll((const char *)s, &stopCar, 10) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeShort - %@ (exceed buffer end)", operation];
    if ((unsigned char *)stopCar > s) {
        if ((result>MSShortMax) || (result<MSShortMin)) [NSException raise:NSGenericException format:@"_MSTDecodeShort - out of range (%lld)", result] ;
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeShort - %@ (no termination)", operation] ;
    
    return (MSShort)result ;
}

MSUInt _MSTDecodeUnsignedInt(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSULong result = strtoull((const char *)s, &stopCar, 10) ;
    
    if ((unsigned char *)stopCar > endPointer)[NSException raise:NSGenericException format:@"_MSTDecodeUnsignedInt - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        if (result>MSUIntMax) [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedInt - out of range (%llu)", result] ;
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedInt - %@ (no termination)", operation] ;
    
    return (MSUInt)result ;
}

MSInt _MSTDecodeInt(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSLong result = strtoll((const char *)s, &stopCar, 10) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeInt - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        if (((MSInt)result>MSIntMax) || ((MSInt)result<MSIntMin)) {
            [NSException raise:NSGenericException format:@"_MSTDecodeInt - out of range (%lld)", result] ;
        }
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeInt - %@ (no termination)", operation] ;
    
    return (MSInt)result ;
}

MSULong _MSTDecodeUnsignedLong(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSULong result = strtoull((const char *)s, &stopCar, 10);
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedLong - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeUnsignedLong - %@ (no termination)", operation] ;
    
    return result ;
}

MSLong _MSTDecodeLong(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    MSLong result = strtoll((const char *)s, &stopCar, 10);
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeLong - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeLong - %@ (no termination)", operation] ;
    
    return result ;
}

float _MSTDecodeFloat(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    float result = strtof((const char *)s, &stopCar) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeFloat - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeFloat - %@ (no termination)", operation] ;
    
    return result ;
}

double _MSTDecodeDouble(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    double result = strtod((const char *)s, &stopCar) ;
    
    if ((unsigned char *)stopCar > endPointer) [NSException raise:NSGenericException format:@"_MSTDecodeDouble - %@ (exceed buffer end)", operation] ;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeDouble - %@ (no termination)", operation] ;
    
    return result ;
}


NSString *_MSTDecodeString(unsigned char **pointer, unsigned char *endPointer, NSString *operation)
{
    unsigned char *start = (unsigned char *)*pointer ;
    unsigned char *s = start ;
    BOOL endStringFound = NO ;
    MSShort state = MSTE_DECODING_STRING_START ;
    //MSUnicodeString *ret = MSCreateUnicodeString(2) ;
    //NSMutableString *ret= [[NSMutableString alloc] initWithCapacity:2];
    NSMutableString *ret = [[NSMutableString alloc]init] ;

   
    while ((s < endPointer) && !endStringFound) {
        unsigned char character = *s ;
        
        switch (state) {
            case MSTE_DECODING_STRING_START:
            {
                
                if ((unichar)character == (unichar)'"') { s++ ; state = MSTE_DECODING_STRING ; break ; }
                [NSException raise:NSGenericException format:@"_MSTDecodeString - %@ (wrong starting character : %c)", operation, character] ;
                break ;
            }
            case MSTE_DECODING_STRING :
            {
                
                if ((unichar)character == (unichar)'\\') { s++ ; state = MSTE_DECODING_STRING_ESCAPED_CAR ; break ; }
                if ((unichar)character == (unichar)'"') { s++ ; state = MSTE_DECODING_STRING_STOP ; endStringFound = YES ; break ; }
                unichar car = (unichar) character;
            
                [ret appendString:[NSString stringWithCharacters:(const unichar*)&car length:1]] ; //adding visible ascii character to unicode string
                
                s++ ; //pass to next character
                break ;
            }
            case MSTE_DECODING_STRING_ESCAPED_CAR :
            {
               
                unichar uniCharacter = (unichar)character ;
                if (uniCharacter == (unichar)'"')
                {
                    unichar car = (unichar)0x0022 ;
                    [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'\\')
                {
                    unichar car = (unichar)0x005c;
                    [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'/')
                {
                    unichar car = (unichar)0x002F;
                    [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                   
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'b')
                {
                    unichar car = (unichar)0x0008;
                    [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'f')
                {
                    unichar car = (unichar)0x0012;
                   [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'n')
                {
                    unichar car = (unichar)0x000a;
                   [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'r')
                {
                    unichar car = (unichar)0x000d;
                    [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'t')
                {
                    unichar car = (unichar)0x0009;
                    [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (uniCharacter == (unichar)'u')
                {
                    //UTF16 value on 4 hexadecimal characters expected
                    unichar s0, s1, s2, s3 ;
                        
                    if ((endPointer-s)<5) [NSException raise:NSGenericException format:@"_MSTDecodeString - %@ (too short UTF16 character expected)", operation] ;
                   
                    s0 = (unichar)s[1] ;
                    s1 = (unichar)s[2] ;
                    s2 = (unichar)s[3] ;
                    s3 = (unichar)s[4] ;
                        
                    if (!MSUnicharIsHexa(s0) ||
                        !MSUnicharIsHexa(s1) ||
                        !MSUnicharIsHexa(s2) ||
                        !MSUnicharIsHexa(s3)) [NSException raise:NSGenericException format:@"_MSTDecodeString - %@ (bad hexadecimal character for UTF16)", operation] ;
                    else {                        
                        MSByte b0 = _hexaCharacterToShortValue(s0) ;
                        MSByte b1 = _hexaCharacterToShortValue(s1) ;
                        MSByte b2 = _hexaCharacterToShortValue(s2) ;
                        MSByte b3 = _hexaCharacterToShortValue(s3) ;
                        unichar car = (unichar)((b0<<12) + (b1<<8) + (b2<<4) + b3);                        
                        [ret appendString:[NSString stringWithCharacters:(const unichar *)&car length:1]] ;
                        s += 5 ;
                        state = MSTE_DECODING_STRING ;
                    }
                    break ;
                }
                else {
                   [NSException raise:NSGenericException format:@"_MSTDecodeString - %@ (unexpected escaped character : %c)", operation, (unichar)character] ;
                    break ;
                }
            }
            default: {
                [NSException raise:NSGenericException format:@"_MSTDecodeString - %@ (unknown state)", operation] ;
            }
        }
    }
  
    *pointer = s ;
    return [ret autorelease] ;
}

NSNumber *_MSTDecodeNumber(unsigned char **pointer, unsigned char *endPointer, MSShort tokenType, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    NSNumber *ret = nil ;

    switch (tokenType) {
        case MSTE_TOKEN_TYPE_INTEGER_VALUE : {
            ret = [[NSNumber allocWithZone:zone] initWithLongLong:_MSTDecodeLong(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_REAL_VALUE : 
        case MSTE_TOKEN_TYPE_DOUBLE : {
            ret = [[NSNumber allocWithZone:zone] initWithDouble:_MSTDecodeDouble(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_CHAR : {
            ret = [[NSNumber allocWithZone:zone] initWithChar:_MSTDecodeChar(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_CHAR : {
            ret = [[NSNumber allocWithZone:zone] initWithUnsignedChar:_MSTDecodeUnsignedChar(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_SHORT : {
            ret = [[NSNumber allocWithZone:zone] initWithShort:_MSTDecodeShort(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_SHORT : {
            ret = [[NSNumber allocWithZone:zone] initWithUnsignedShort:_MSTDecodeUnsignedShort(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_INT32 : {
            ret = [[NSNumber allocWithZone:zone] initWithInt:_MSTDecodeInt(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_INSIGNED_INT32 : {
            ret = [[NSNumber allocWithZone:zone] initWithUnsignedInt:_MSTDecodeUnsignedInt(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_INT64 : {
            ret = [[NSNumber allocWithZone:zone] initWithLongLong:_MSTDecodeLong(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_INT64 : {
            ret = [[NSNumber allocWithZone:zone] initWithUnsignedLongLong:_MSTDecodeUnsignedLong(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_FLOAT : {
            ret = [[NSNumber allocWithZone:zone] initWithFloat:_MSTDecodeFloat(&s, endPointer, @"_MSTDecodeNumber")] ;
            break ;
        }
        default: {
            [NSException raise:NSGenericException format:@"_MSTDecodeNumber - unknown tokenType : %d", tokenType] ;
        }
    }

    if (!ret) [NSException raise:NSGenericException format:@"_MSTDecodeNumber - unable to decode number with tokenType = %d", tokenType] ;

    *pointer = s ;
    return [ret autorelease] ;
}

NSMutableDictionary *_MSTDecodeDictionary(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL manageReference, BOOL decodingUserClass, BOOL allowsUnknownUserClasses, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    NSMutableDictionary *ret = nil ;
    NSUInteger count = _MSTDecodeUnsignedLong(&s, endPointer, operation) ;
    
    ret = [[NSMutableDictionary allocWithZone:zone] initWithCapacity:count] ;
    if (manageReference) { [decodedObjects addObject:ret] ; }

    if (count) {
        NSUInteger i ;
        
        for (i = 0 ; i < count ; i++) {
            BOOL isWeakRef ;
            MSUInt keyReference ;
            id object, key ;
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            keyReference = _MSTDecodeUnsignedInt(&s, endPointer, operation) ;
            key = [keys objectAtIndex:keyReference] ;
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            object = _MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount, &isWeakRef, allowsUnknownUserClasses, zone) ;
            
            if (!object) object = __theNull ;
            [ret setObject:object forKey:key] ;
            
            if (isWeakRef) {
                if (decodingUserClass) {
                    if (manageReference) [NSException raise:NSGenericException format:@"_MSTDecodeDictionary - Weakly referenced object encountered while decoding a user class!"] ;
                }
                else
                    [NSException raise:NSGenericException format:@"_MSTDecodeDictionary - Weakly referenced object encountered while decoding a non user class!"] ;
            }
        }
    }
   
    *pointer = s ;
    return [ret autorelease] ;
}

NSMutableArray *_MSTDecodeArray(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL allowsUnknownUserClasses, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    NSMutableArray *ret = nil ;
    NSUInteger count = _MSTDecodeUnsignedLong(&s, endPointer, operation) ;
    
    ret = [[NSMutableArray allocWithZone:zone] initWithCapacity:count] ;
    [decodedObjects addObject:ret] ;

    if (count) {
        NSUInteger i ;
        
        for (i = 0 ; i < count ; i++) {
            BOOL isWeakRef ;
            id object ;
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            object = _MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount, &isWeakRef, allowsUnknownUserClasses, zone) ;
            if (!object) object = __theNull ;
            [ret addObject:object] ;
            
            if (isWeakRef) [NSException raise:NSGenericException format:@"_MSTDecodeArray - Weakly referenced object encountered while decoding an array!"] ;
        }
    }

    *pointer = s ;
    return [ret autorelease] ;
}

NSMutableArray *_MSTDecodeNaturalArray(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, MSULong *tokenCount, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    NSMutableArray *ret = nil ;
    NSUInteger count = _MSTDecodeUnsignedLong(&s, endPointer, operation) ;
    
    ret = [[NSMutableArray allocWithZone:zone] initWithCapacity:count] ;
    [decodedObjects addObject:ret] ;
    
    if (count) {
        NSUInteger i ;
        
        for (i = 0 ; i < count ; i++) {
            NSUInteger natural ;
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            natural = _MSTDecodeUnsignedLong(&s, endPointer, operation) ;
            [ret addObject:[NSNumber numberWithUnsignedLong:natural]] ;
        }
    }
    
    *pointer = s ;
    return [ret autorelease] ;
}


MSMutableCouple *_MSTDecodeCouple(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL allowsUnknownUserClasses, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    MSMutableCouple *ret = nil ;
    id firstMember, secondMember ;
    BOOL isWeakRef ;
    
    ret = [[MSMutableCouple allocWithZone:zone] init] ;
    [decodedObjects addObject:ret] ;

    firstMember = _MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount, &isWeakRef, allowsUnknownUserClasses, zone) ;
    if (isWeakRef) [NSException raise:NSGenericException format:@"_MSTDecodeCouple - Weakly referenced object encountered while decoding an array!"] ;

    _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
    secondMember = _MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount, &isWeakRef, allowsUnknownUserClasses, zone) ;
    if (isWeakRef) [NSException raise:NSGenericException format:@"_MSTDecodeCouple - Weakly referenced object encountered while decoding an array!"] ;

    [ret setFirstMember:firstMember] ;
    [ret setSecondMember:secondMember] ;
    
    *pointer = s ;
    return [ret autorelease] ;
}

NSData *_MSTDecodeBufferBase64String(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    NSData *ret = nil ;
    NSString *base64String = _MSTDecodeString(&s, endPointer, operation) ;
    const char *utf8String = [base64String UTF8String] ;
    
    if ([base64String length]) ret = NSDataFromBase64((const void *)(utf8String), strlen(utf8String)) ; //returns base64 decoded autoreleased NSData
    else ret = [[NSData data]autorelease] ;
    
    *pointer = s ;
    return ret ; //already autoreleased
}

NSMutableData *_MSTDecodeBufferHexaString(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    NSMutableData *ret = nil ;
    NSString *hexaString = _MSTDecodeString(&s, endPointer, operation) ;
    const char *c0, *c1, *utf8String = [hexaString UTF8String] ;
    unsigned long long i, utf8StringLen = strlen(utf8String) ;
    unsigned long long bufferLen ;
    char tmp[1] = "\x00";
    
    if (utf8StringLen%2) [NSException raise:NSGenericException format:@"__MSTDecodeDataHexaString - bad length of hexadecimal string : %llu", utf8StringLen] ;
    
    bufferLen = utf8StringLen/2 ;
    ret = [NSMutableData data] ;
    
    if (utf8StringLen>1) {
        c0 = &utf8String[0] ;
        c1 = &utf8String[1] ;
        for (i = 0 ; i < bufferLen ; i++) {
            unsigned char b0 = ((unsigned char)_hexaCharacterToShortValue((unichar)*c0))<<4 ;
            unsigned char b1 = (unsigned char)_hexaCharacterToShortValue((unichar) *c1) ;
            tmp[0] = b0 + b1;
            [ret appendBytes:(const void*)&tmp length:1] ;
            c0 += 2 ;
            c1 += 2 ;
        }
    }
    
    *pointer = s ;
    return [ret autorelease] ;
}

MSColor *_MSTDecodeColor(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSZone *zone)
{
    
    unsigned char *s = (unsigned char *)*pointer ;
    MSColor *ret = nil ;
    MSUInt trgbValue = _MSTDecodeUnsignedInt(&s, endPointer, operation) ;
    ret = MSCreateCSSColor(trgbValue) ;
    *pointer = s ;
    return [ret autorelease] ;
}

id _MSTDecodeUserDefinedObject(unsigned char **pointer, unsigned char *endPointer, NSString *operation, MSByte tokenType, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL allowsUnknownUserClasses, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    id ret = nil ;
    MSInt classIndex = (tokenType - MSTE_TOKEN_TYPE_USER_CLASS)/2 ;
    
    if (classIndex >=0 && classIndex < (MSInt)[classes count]) {
        NSString *className = [classes objectAtIndex:classIndex] ;
        Class aClass = NSClassFromString(className) ;

        if (aClass) {
            NSDictionary *dictionary ;
            ret = [(id)aClass allocWithZone:zone] ;
            [decodedObjects addObject:ret] ;
            
            dictionary = _MSTDecodeDictionary(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount, NO, YES, allowsUnknownUserClasses, zone) ;
            
            [ret initWithDictionary:dictionary] ;
            [ret autorelease] ;
        }
        else if (allowsUnknownUserClasses) {
            ret = _MSTDecodeDictionary(&s, endPointer, @"_MSTDecodeUserDefinedObject", decodedObjects, classes, keys, tokenCount, YES, YES, allowsUnknownUserClasses, zone) ;
        }
        else [NSException raise:NSGenericException format:@"_MSTDecodeUserDefinedObject - unable to find user class %@ in current system", className] ;
    }
    else [NSException raise:NSGenericException format:@"_MSTDecodeUserDefinedObject - unable to find user class at index %u",classIndex] ;

    *pointer = s ;
    return ret ;
}

id _MSTDecodeObject(unsigned char **pointer, unsigned char *endPointer, NSString *operation, NSMutableArray *decodedObjects, NSArray *classes, NSArray *keys, MSULong *tokenCount, BOOL *isWeaklyReferenced, BOOL allowsUnknownUserClasses, NSZone *zone)
{
    unsigned char *s = (unsigned char *)*pointer ;
    id ret = nil ;
    MSByte tokenType = _MSTDecodeUnsignedShort(&s, endPointer, @"token type") ;

    if (isWeaklyReferenced) *isWeaklyReferenced = NO ;
    switch (tokenType) {
        case MSTE_TOKEN_TYPE_NULL :
        {
            //nothing to do: returning nil
            break ;
        }
        case MSTE_TOKEN_TYPE_TRUE :
        {
            ret = [NSNumber numberWithBool:YES] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_FALSE :
        {
            ret = [NSNumber numberWithBool:NO] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_INTEGER_VALUE :
        case MSTE_TOKEN_TYPE_REAL_VALUE :
        {            
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeNumber(&s, endPointer, tokenType, zone) ;
            [decodedObjects addObject:ret] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_CHAR :
        case MSTE_TOKEN_TYPE_UNSIGNED_CHAR :
        case MSTE_TOKEN_TYPE_SHORT :
        case MSTE_TOKEN_TYPE_UNSIGNED_SHORT :
        case MSTE_TOKEN_TYPE_INT32 :
        case MSTE_TOKEN_TYPE_INSIGNED_INT32 :
        case MSTE_TOKEN_TYPE_INT64 :
        case MSTE_TOKEN_TYPE_UNSIGNED_INT64 :
        case MSTE_TOKEN_TYPE_FLOAT :
        case MSTE_TOKEN_TYPE_DOUBLE :
        {
            //no reference on simple types
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeNumber(&s, endPointer, tokenType, zone) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_STRING :
        {
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeString(&s, endPointer, @"_MSTDecodeObject") ;
            [decodedObjects addObject:ret] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_DATE :
        {
            MSLong seconds ;            
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            seconds = _MSTDecodeLong(&s, endPointer, @"_MSTDecodeObject") ;
            ret = [[[NSDate allocWithZone:zone] initWithTimeIntervalSince1970:(NSTimeInterval)seconds] autorelease] ;
            [decodedObjects addObject:ret] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_DICTIONARY :
        {
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeDictionary(&s, endPointer, @"_MSTDecodeObject", decodedObjects, classes, keys, tokenCount, YES, NO, allowsUnknownUserClasses, zone) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT :
        {
            NSUInteger objectReference ;            
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            objectReference = _MSTDecodeLong(&s, endPointer, @"_MSTDecodeObject") ;
            ret = [decodedObjects objectAtIndex:objectReference] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_COLOR : {
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeColor(&s, endPointer, @"_MSTDecodeObject", zone) ;
            [decodedObjects addObject:ret] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_ARRAY : {            
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeArray(&s, endPointer, @"_MSTDecodeObject", decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses, zone) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_NATURAL_ARRAY : {
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeNaturalArray(&s, endPointer, @"_MSTDecodeObject", decodedObjects, tokenCount, zone) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_COUPLE : {
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeCouple(&s, endPointer, @"_MSTDecodeObject", decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses, zone);
            break ;
        }
        case MSTE_TOKEN_TYPE_BASE64_DATA : {
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = _MSTDecodeBufferBase64String(&s, endPointer, @"_MSTDecodeObject", zone) ;
            [decodedObjects addObject:ret] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_DISTANT_PAST : {
            ret = __theDistantPast ;
            break ;
        }
        case MSTE_TOKEN_TYPE_DISTANT_FUTURE : {
            ret = __theDistantFuture ;
            break ;
        }
        case MSTE_TOKEN_TYPE_EMPTY_STRING : {
            ret = [NSString string] ;
            break ;
        }
        case MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT : {
            NSUInteger objectReference ;
            _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            objectReference = _MSTDecodeLong(&s, endPointer, @"_MSTDecodeObject") ;
            ret = [decodedObjects objectAtIndex:objectReference] ;
            if (isWeaklyReferenced) *isWeaklyReferenced = YES ;
            break ;
        }
        default :
        {
            if (tokenType >= MSTE_TOKEN_TYPE_USER_CLASS) {
                 
                _MSTJumpToNextToken(&s, endPointer, tokenCount) ;
                ret = _MSTDecodeUserDefinedObject(&s, endPointer, @"__MSTDecodeObject", tokenType, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses, zone) ;

                if (isWeaklyReferenced) *isWeaklyReferenced = ((tokenType - MSTE_TOKEN_TYPE_USER_CLASS)%2)>0 ;
            }
            else [NSException raise:NSGenericException format:@"__MSTDecodeObject - unknown tokenType : %u", tokenType] ;
            break ;
        }
    }

    *pointer = s ;
    return ret ;
}

id MSTDecodeRetainedObject(NSData *data, NSZone *zone, BOOL verifyCRC, BOOL allowsUnknownUserClasses)
{
    NSUInteger len = [data length] ;
    
    if (len > 26) { //minimum header size : ["MSTE0101",3,"CRC00000000" ...]
        unsigned char *s = (unsigned char *)[data bytes];
        unsigned char *end = (unsigned char *)s+len-1 ;
        unsigned char *crcPtr = NULL ;
        char crc[9] ;
        MSUInt crcInt = 0;
        MSULong tokenNumber, classesNumber, keysNumber = 0 ;
        NSMutableArray *decodedClasses = nil ;
        NSMutableArray *decodedKeys = nil ;
        MSShort state = MSTE_DECODING_ARRAY_START ;
        id object = nil ;
        NSMutableArray *decodedObjects = nil ;
        MSULong myTokenCount = 0 ;
        
        if (!__theDistantPast) {
            __theDistantPast = [[NSDate distantPast] retain] ;
            __theDistantFuture = [[NSDate distantFuture] retain] ;
            __theNull = [[NSNull null] retain] ;
        }

        while ((s < (end+1))) {
            switch (state) {
                case MSTE_DECODING_ARRAY_START: {
                    if (*s == (unichar)' ') { s++ ; break ; }                    
                    if (*s == (unichar)'[') { s++ ; state = MSTE_DECODING_VERSION_START ; break ; }
                    [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (array start)"] ;
                }
                case MSTE_DECODING_VERSION_START : {
                    if (*s == (unichar)' ') { s++ ; break ; }
                    if (*s == (unichar)'"') { s++ ; state = MSTE_DECODING_VERSION_HEADER ; break ; }
                    [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (start)"] ;
                }
                case MSTE_DECODING_VERSION_HEADER : {
                    if (((end-s) < 4) || (s[0] != (unichar)'M') || (s[1] != (unichar)'S') || (s[2] != (unichar)'T') || (s[3] != (unichar)'E')) {
                       [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (MSTE marker)"] ; }
                    s += 4 ;
                    state = MSTE_DECODING_VERSION_VALUE ;
                    break ;
                }
                case MSTE_DECODING_VERSION_VALUE : {
                    if (((end-s) < 4) || !isdigit(s[0])|| !isdigit(s[1])|| !isdigit(s[2])|| !isdigit(s[3])) {
                        [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header version"] ; }

                    s += 4 ;
                    state = MSTE_DECODING_VERSION_END ;
                    break ;
                }
                case MSTE_DECODING_VERSION_END : {
                    if (*s == (unichar)'"') { s++ ; state = MSTE_DECODING_VERSION_NEXT_TOKEN ; }
                    else [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (version end)"] ;
                    break ;
                }
                case MSTE_DECODING_VERSION_NEXT_TOKEN :
                case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN :
                case MSTE_DECODING_CRC_NEXT_TOKEN :
                case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN :
                case MSTE_DECODING_CLASS_NEXT_TOKEN :
                case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN :
                case MSTE_DECODING_KEY_NEXT_TOKEN :
                {
                  
                    _MSTJumpToNextToken(&s, end, &myTokenCount) ;
                    switch (state) {
                        case MSTE_DECODING_VERSION_NEXT_TOKEN:
                            state = MSTE_DECODING_TOKEN_NUMBER_VALUE ; break ;
                        case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN:
                            state = MSTE_DECODING_CRC_START ; break ;
                        case MSTE_DECODING_CRC_NEXT_TOKEN:
                            state = MSTE_DECODING_CLASSES_NUMBER_VALUE ; break ;
                        case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN:
                            if (classesNumber) state = MSTE_DECODING_CLASS_NAME ;
                            else state = MSTE_DECODING_KEYS_NUMBER_VALUE ;
                            break ;
                        case MSTE_DECODING_CLASS_NEXT_TOKEN:
                            if (classesNumber > [decodedClasses count]) state = MSTE_DECODING_CLASS_NAME ;
                            else state = MSTE_DECODING_KEYS_NUMBER_VALUE ;
                            break ;
                        case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN:
                            if (keysNumber) state = MSTE_DECODING_KEY_NAME ;
                            else state = MSTE_DECODING_ROOT_OBJECT ; break ;
                        case MSTE_DECODING_KEY_NEXT_TOKEN:
                            if (keysNumber > [decodedKeys count]) state = MSTE_DECODING_KEY_NAME ;
                            else state = MSTE_DECODING_ROOT_OBJECT ;
                            break ;
                        default:
                            [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - state unchanged!!!!"] ;
                    }
                    break ;
                }
                case MSTE_DECODING_TOKEN_NUMBER_VALUE : {
                    tokenNumber = _MSTDecodeUnsignedLong(&s, end, @"token number") ;
                    state = MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_CRC_START : {
                    if (*s == (unichar)'"') { s++ ; state = MSTE_DECODING_CRC_HEADER ; break ; }
                    [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (CRC start)"] ;
                }
                case MSTE_DECODING_CRC_HEADER : {
                    if (((end-s) < 3) || (s[0] != (unichar)'C') || (s[1] != (unichar)'R') || (s[2] != (unichar)'C')) { //CRC
                        [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (CRC marker)"] ; }
                    s += 3 ;
                    state = MSTE_DECODING_CRC_VALUE ;
                    break ;
                }
                case MSTE_DECODING_CRC_VALUE : {
                    MSShort j ;
                    if ((end-s) < 8) {[NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (CRC value)"] ; }
                    crcPtr = s ;
                    for (j=0; j<8; j++) {
                        MSByte localCRC ;
                        crc[j] = s[j] ;

                        localCRC = _hexaCharacterToShortValue((unichar)crc[j]) ;
                        crcInt = (crcInt<<4) ;
                        crcInt += (MSUInt)localCRC ;
                    }
                    crc[8] = 0 ; //zero terminated hexa CRC string
                    s += 8 ;
                    state = MSTE_DECODING_CRC_END ;
                    break ;
                }
                case MSTE_DECODING_CRC_END : {
                    if (*s == (unichar)'"') { s++ ; state = MSTE_DECODING_CRC_NEXT_TOKEN ; }
                    else [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad header format (CRC end)"] ;
                    break ;
                }
                case MSTE_DECODING_CLASSES_NUMBER_VALUE : {
                    classesNumber = _MSTDecodeUnsignedLong(&s, end, @"classes number") ;
                    if (classesNumber) decodedClasses = [[NSMutableArray alloc] initWithCapacity:classesNumber] ;
                    state = MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_CLASS_NAME : {
                    NSString *className = _MSTDecodeString(&s, end, @"class name") ;
                    [decodedClasses addObject:className] ;
                    state = MSTE_DECODING_CLASS_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_KEYS_NUMBER_VALUE : {
                    
                    keysNumber = _MSTDecodeUnsignedLong(&s, end, @"keys number") ;
                    if (keysNumber) decodedKeys = [[NSMutableArray alloc] initWithCapacity:keysNumber] ;
                    state = MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_KEY_NAME : {
                    NSString *key = _MSTDecodeString(&s, end, @"key name") ;
                    [decodedKeys addObject:key] ;
                    state = MSTE_DECODING_KEY_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_ROOT_OBJECT : {
                    NS_DURING
                        decodedObjects = [[NSMutableArray alloc] initWithCapacity:32] ;
                        object = [_MSTDecodeObject(&s, end, @"root object", decodedObjects, decodedClasses, decodedKeys, &myTokenCount, NULL, allowsUnknownUserClasses, zone) retain] ;
                    DESTROY(decodedClasses) ;
                    DESTROY(decodedKeys) ;
                    DESTROY(decodedObjects) ;
                        state = MSTE_DECODING_ARRAY_END ;
                    NS_HANDLER
                        object = nil ;
                    object = nil ;
                    DESTROY(decodedClasses) ;
                    DESTROY(decodedKeys) ;
                    DESTROY(decodedObjects) ;
                    [localException raise] ;
                    NS_ENDHANDLER
                    break ;
                }
                case MSTE_DECODING_ARRAY_END : {
                    if (*s == (unichar)' ') { s++ ; break ; }
                    if (*s == (unichar)']') { state = MSTE_DECODING_GLOBAL_END ; break ; }
                    [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad format (array end)"] ;
                }
                case MSTE_DECODING_GLOBAL_END : {
                    if (*s == (unichar)' ') { s++ ; break ; }
                    if (s==end) {
                        if (verifyCRC) {
                            crcPtr[0] = crcPtr[1] = crcPtr[2] = crcPtr[3] = crcPtr[4] = crcPtr[5] = crcPtr[6] = crcPtr[7] = (unichar)'0';
                            if (crcInt != [data longCRC]) [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - CRC Verification failed"] ;
                        }
                        
                        myTokenCount += 1 ;
                        if (tokenNumber != myTokenCount) [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Wrong token number : %llu (expected : %llu)", myTokenCount, tokenNumber] ;
                        s++ ;
                        break ;
                    }
                    [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - Bad format (character after array end)"] ;
                }
                default : {
                    //never go here
                    [NSException raise:NSGenericException format:@"MSTDecodeRetainedObject - unknown state"] ;
                }
            }
        }
        return object ;
    }
    return nil ;
}

@implementation NSData (MSTDecoding)

- (id)MSTDecodedObject { return MSTDecodeRetainedObject(self, NULL, NO, YES) ; }
- (id)MSTDecodedObjectAndVerifyCRC:(BOOL)verifyCRC { return MSTDecodeRetainedObject(self, NULL, verifyCRC, YES) ; }
- (id)MSTDecodedObjectAndVerifyCRC:(BOOL)verifyCRC allowsUnknownUserClasses:(BOOL)allowsUnknownUserClasses { return MSTDecodeRetainedObject(self, NULL, verifyCRC, allowsUnknownUserClasses) ; }

@end

@implementation NSObject (MSTDecoding)
- (id)initWithDictionary:(NSDictionary *)values
{
	return [self notImplemented:NSSelectorFromString(@"initWithDictionary:")] ;
}
@end

