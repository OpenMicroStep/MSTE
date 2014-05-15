/*
 
 MSTEncoder.m
 
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

#import "MSTEncoder.h"



#define MSTEncoderLastVersion	100

static const char *__hexa = "0123456789ABCDEF" ;


static inline MSByte _ShortValueToHexaCharacter(MSByte c)
{
    if (c < 16) return __hexa[c] ;
    
    [NSException raise:NSGenericException format:@"_ShortValueToHexaCharacter - not an hexadecimal value %u",c] ;
    return 0 ;
}

@interface MSTEncoder (Private)

- (void)_encodeTokenSeparator ;

- (void)_encodeTokenType:(MSByte)tokenType ;

- (void)_encodeGlobalUnicodeString:(const char *)str ;
- (void)_encodeGlobalUnsignedLongLong:(MSULong)l ;
- (void)_encodeGlobalHexaUnsignedInt:(unsigned int)i inRange:(NSRange)range;

- (void)_clean ;
@end

@interface NSObject (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder ;
@end

@implementation MSTEncoder

+ (id)encoder
{
    return [[[self alloc] init] autorelease];
}

+ (void)initialize
{
    if ([self class] == [MSTEncoder class]) {
        [MSTEncoder setVersion:MSTEncoderLastVersion] ;
    }
}

- (void)dealloc
{
    [self _clean] ;
    [super dealloc] ;
}

- (void)encodeBool:(BOOL)b withTokenType:(BOOL)token
{
    if (token) {
        [self _encodeTokenSeparator] ;
        if (b) [self _encodeTokenType:MSTE_TOKEN_TYPE_TRUE] ;
        else [self _encodeTokenType:MSTE_TOKEN_TYPE_FALSE] ;
    }
}

- (void)encodeBytes:(void *)bytes length:(NSUInteger)length withTokenType:(BOOL)token
{
    unsigned char s = (unsigned char)'"' ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_BASE64_DATA] ;
    }
    
    [self _encodeTokenSeparator] ;
    [_content appendBytes:(const void*)&s length:1] ;
    if (bytes){
        if (length){
            NSData *buffer = Base64FromBytes(bytes, length) ; //returns base64 encoded autoreleased NSData
            [_content appendBytes:(const void*)[buffer bytes] length:[buffer length]] ;
        }
    }
    [_content appendBytes:(const void*)&s length:1] ;
}

- (void)encodeUnicodeString:(const char *)str withTokenType:(BOOL)token // encodes an UTF8 string
{
    if (str) {
        NSUInteger len = (MSUInt)strlen(str) ;
        if (token) {
            [self _encodeTokenSeparator] ;
            [self _encodeTokenType:MSTE_TOKEN_TYPE_STRING] ;
        }
        
        [self _encodeTokenSeparator] ;
        [_content appendBytes:(const void*)"\"" length:1];
        if (len) {
            NSUInteger i ;
            
            for (i=0 ; i<len ; i++) {
                MSByte c = (MSByte)str[i] ;
                switch (c) { //Escape some characters
                    case 34 : { // double quote
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"\"" length:1];
                        break ;
                    }
                    case 92 : { // antislash
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"\\" length:1];
                        break ;
                    }
                    case 47 : { // slash
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"/" length:1];
                        break ;
                    }
                    case 8 : { // backspace
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"b" length:1];
                        break ;
                    }
                    case 12 : { // formfeed
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"f" length:1];
                        break ;
                    }
                    case 10 : { // newline
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"n" length:1];
                        break ;
                    }
                    case 13 : { // carriage return
                        [_content appendBytes:(const void*)"\\" length:1];
                       [_content appendBytes:(const void*)"r" length:1];
                        break ;
                    }
                    case 9 : { // tabulation
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"t" length:1];
                        break ;
                    }
                    default: {
                        unsigned char car = (unsigned char)c ;
                        [_content appendBytes:(const void*)&car length:1];
                        break ;
                    }
                }
            }
        }
        [_content appendBytes:(const void*)"\"" length:1];
    }
    else [NSException raise:NSGenericException format:@"encodeUnicodeString:withTokenType: no string to encode!"] ;
}

- (void)encodeString:(NSString *)s withTokenType:(BOOL)token // transforms a string in its UTF16 counterpart and encodes it
{
    if (s) {
        NSUInteger len = [s length] ;
        if (token) {
            [self _encodeTokenSeparator] ;
            [self _encodeTokenType:MSTE_TOKEN_TYPE_STRING] ;
        }
        
        [self _encodeTokenSeparator] ;
        [_content appendBytes:(const void*)"\"" length:1];
        
        if (len) {
            NSUInteger i ;
            
            for (i=0 ; i<len ; i++) {
                unichar c = [s characterAtIndex:i] ;
                switch (c) { //Escape some characters
                    case 34 : { // double quote
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"\"" length:1];
                        break ;
                    }
                    case 92 : { // antislash
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"\\" length:1];
                        break ;
                    }
                    case 47 : { // slash
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"/" length:1];
                        break ;
                    }
                    case 8 : { // backspace
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"b" length:1];
                        break ;
                    }
                    case 12 : { // formfeed
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"f" length:1];
                        break ;
                    }
                    case 10 : { // newline
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"n" length:1];
                        break ;
                    }
                    case 13 : { // carriage return
                        [_content appendBytes:(const void*)"\\" length:1];
                       [_content appendBytes:(const void*)"r" length:1];
                        break ;
                    }
                    case 9 : { // tabulation
                        [_content appendBytes:(const void*)"\\" length:1];
                        [_content appendBytes:(const void*)"t" length:1];
                        break ;
                    }
                    default: {
                        
                        if ((c < 32) || (c > 127)) { //escape non printable ASCII characters with a 4 characters in UTF16 hexadecimal format (\UXXXX)
                            MSByte b0 = (MSByte)((c & 0xF000)>>12);
                            MSByte b1 = (MSByte)((c & 0x0F00)>>8);
                            MSByte b2 = (MSByte)((c & 0x00F0)>>4);
                            MSByte b3 = (MSByte)(c & 0x000F);
                                                        
                            [_content appendBytes:(const void*)"\\" length:1];
                            [_content appendBytes:(const void*)"u" length:1];
                            unsigned char car = (unsigned char)_ShortValueToHexaCharacter(b0) ;
                            unsigned char car1 = (unsigned char)_ShortValueToHexaCharacter(b1) ;
                            unsigned char car2 = (unsigned char)_ShortValueToHexaCharacter(b2) ;
                            unsigned char car3 = (unsigned char)_ShortValueToHexaCharacter(b3) ;
                            [_content appendBytes:(const void*)&car length:1];
                            [_content appendBytes:(const void*)&car1 length:1];
                            [_content appendBytes:(const void*)&car2 length:1];
                            [_content appendBytes:(const void*)&car3 length:1];
                            
                        }
                        else {
                            unsigned char car = (unsigned char)c ;                            
                            [_content appendBytes:(const void*)&car length:1];
                            
                        }
                        break ;
                    }
                }
            }
        }
        [_content appendBytes:(const void*)"\"" length:1];
    }
    else [NSException raise:NSGenericException format:@"encodeString:withTokenType: no string to encode!"] ;
}

- (void)encodeUnsignedChar:(MSByte)c withTokenType:(BOOL)token
{
    char toAscii[4] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_UNSIGNED_CHAR] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%u", c);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeChar:(MSChar)c withTokenType:(BOOL)token
{
    char toAscii[5] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_CHAR] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%d", c);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeUnsignedShort:(MSUShort)s withTokenType:(BOOL)token
{
    char toAscii[6] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_UNSIGNED_SHORT] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%u", s);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeShort:(MSShort)s withTokenType:(BOOL)token
{
    char toAscii[7] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_SHORT] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%d", s);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeUnsignedInt:(MSUInt)i withTokenType:(BOOL)token
{
    char toAscii[11] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_INSIGNED_INT32] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%u", i);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeInt:(MSInt)i withTokenType:(BOOL)token
{
    char toAscii[12] = "";
    NSUInteger len ;
   
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_INT32] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%d", i);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeUnsignedLongLong:(MSULong)l withTokenType:(BOOL)token
{
    char toAscii[21] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_UNSIGNED_INT64] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%llu", l);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeLongLong:(MSLong)l withTokenType:(BOOL)token
{
    char toAscii[22] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_INT64] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%lld", l);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeFloat:(float)f withTokenType:(BOOL)token
{
    char toAscii[20] = "";
    NSUInteger len ;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_FLOAT] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%f", f);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeDouble:(double)d withTokenType:(BOOL)token
{
    char toAscii[40] = "";
    NSUInteger len;
    
    if (token) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:MSTE_TOKEN_TYPE_DOUBLE] ;
    }
    
    [self _encodeTokenSeparator] ;
    sprintf(toAscii, "%.15f", d);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)encodeArray:(NSArray *)anArray
{
    id object ;
    NSEnumerator *e = [anArray objectEnumerator] ;
    
    [self encodeUnsignedLongLong:(MSULong)[anArray count] withTokenType:NO] ;
    while ((object = [e nextObject])) {
        [self encodeObject:object] ;
    }
}

- (void)encodeDictionary:(NSDictionary *)aDictionary
{
    [self encodeDictionary:(NSDictionary *)aDictionary isSnapshot:NO] ;
}

- (void)encodeDictionary:(NSDictionary *)aDictionary isSnapshot:(BOOL)isSnapshot
{
    id key ;
    NSEnumerator *ek = [aDictionary keyEnumerator] ;
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:[aDictionary count]] ;
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[aDictionary count]] ;
    NSUInteger i, count ;
    
    while ((key = [ek nextObject])) {
        id object = [aDictionary objectForKey:key] ;
        if ([object singleEncodingCode:self] != MSTE_TOKEN_TYPE_NULL) {
            [keys addObject:[key toString]] ;
            [objects addObject:object] ;
        }
    }
    
    count = [keys count] ;
    [self encodeUnsignedLongLong:(MSULong)count withTokenType:NO] ;
    
    for (i = 0 ; i< count ; i++) {
        NSString *stringKey = [keys objectAtIndex:i] ;
        NSUInteger keyReference = (NSUInteger)NSMapGet(_keys, (const void *)stringKey) ;
        if (!keyReference) {
            keyReference = ++_lastKeyIndex ;
            NSMapInsertKnownAbsent(_keys, (const void *)stringKey, (const void *)keyReference) ;
            [_keysArray addObject:stringKey] ;
        }
        
        [self encodeUnsignedLongLong:(MSULong)(keyReference-1) withTokenType:NO] ;
        [self encodeObject:[objects objectAtIndex:i]] ;
    }
    [keys release] ;
    [objects release] ;
}

- (void)encodeObject:(id)anObject
{
    
    MSInt singleToken = [anObject singleEncodingCode:self] ;
    if (singleToken != MSTE_TOKEN_MUST_ENCODE) {
        [self _encodeTokenSeparator] ;
        [self _encodeTokenType:singleToken] ;
    }
    else {
        NSUInteger objectReference = (NSUInteger)NSMapGet(_encodedObjects, (const void *)anObject) ;
        
        if (objectReference) {
            //this is an already encoded object
            [self _encodeTokenSeparator] ;
            [self _encodeTokenType:MSTE_TOKEN_TYPE_REFERENCED_OBJECT] ;
            [self encodeUnsignedLongLong:(objectReference-1) withTokenType:NO] ;
        }
        else {
            MSByte tokenType = [anObject tokenType] ;
            if (tokenType == MSTE_TOKEN_TYPE_USER_CLASS) {
                Class objectClass ;
                NSUInteger classIndex ;
                NSDictionary *snapshot = [anObject MSTESnapshot] ;
                if (!snapshot) [NSException raise:NSGenericException format:@"encodeObject: Specific user classes must implement MSTESnapshot to be encoded as a dictionary!"] ;
                
                objectClass = [anObject class] ;
                classIndex = (NSUInteger)NSMapGet(_classes, (const void *)objectClass) ;
                
                if (!classIndex) {
                    classIndex = ++_lastClassIndex ;
                    NSMapInsertKnownAbsent(_classes, (const void *)objectClass, (const void *)classIndex) ;
                    [_classesArray addObject:NSStringFromClass(objectClass)] ;
                }
                
                objectReference = ++_lastReference ;
                NSMapInsertKnownAbsent(_encodedObjects, (const void *)anObject, (const void *)objectReference) ;
                [self _encodeTokenSeparator] ;
                [self _encodeTokenType:(MSTE_TOKEN_TYPE_USER_CLASS + classIndex - 1)] ;
                [self encodeDictionary:snapshot isSnapshot:YES] ;
            }
            else if (tokenType <= MSTE_TOKEN_LAST_DEFINED_TYPE) {
                
                objectReference = ++_lastReference ;
                NSMapInsertKnownAbsent(_encodedObjects, (const void *)anObject, (const void *)objectReference) ;
                
                [self _encodeTokenSeparator] ;
                
                [self _encodeTokenType:tokenType] ;
                 
                [anObject encodeWithMSTEncoder:self] ;
               
            }
            else {
                [NSException raise:NSGenericException format:@"encodeObject: cannot encode an object with token type %u!", (MSUInt)tokenType] ;
            }
            
        }
    }
}

- (NSMutableData *)encodeRootObject:(id)anObject
{
    NSZone *zone = [self zone] ;
    NSMutableData *ret = [[NSMutableData alloc]init] ;
    NSEnumerator *ec, *ek ;
    NSString *aClassName, *aKey ;
    NSRange range ;
    
    _keysArray = [[NSMutableArray alloc]init] ;
    _classesArray = [[NSMutableArray alloc]init] ;
    _classes = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSIntegerMapValueCallBacks, 32, zone) ;
    _keys = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSIntegerMapValueCallBacks, 256, zone) ;
    _encodedObjects = NSCreateMapTableWithZone(NSNonOwnedPointerMapKeyCallBacks, NSIntegerMapValueCallBacks, 256, zone) ;
    _global = [[NSMutableData alloc] init] ;
    _content = [[NSMutableData alloc] init] ;
    
    [self encodeObject:anObject] ;
    
    //MSTE header
    [_global appendBytes:"[\"MSTE" length:6] ;
    [_global appendBytes:MSTE_CURRENT_VERSION length:4] ;
    [_global appendBytes:"\"," length:2] ;
    
    [self _encodeGlobalUnsignedLongLong:(5+_lastKeyIndex+_lastClassIndex+_tokenCount)] ;
    [_global appendBytes:",\"CRC" length:5] ;
    range = NSMakeRange([_global length], 8);
    [_global appendBytes:"00000000\"," length:10] ;
    
    //Classes list
    ec = [_classesArray objectEnumerator] ;
    [self _encodeGlobalUnsignedLongLong:(unsigned char)[_classesArray count]] ;
    while ((aClassName = [ec nextObject])) {
        [_global appendBytes:"," length:1] ;
        [self _encodeGlobalUnicodeString:[aClassName UTF8String]] ;
    }
    
    //Keys list
    ek = [_keysArray objectEnumerator] ;
    [_global appendBytes:"," length:1] ;
    [self _encodeGlobalUnsignedLongLong:(unsigned int)[_keysArray count]] ;
    while ((aKey = [ek nextObject])) {
        [_global appendBytes:"," length:1] ;
        [self _encodeGlobalUnicodeString:[aKey UTF8String]] ;
    }
    
    if ([_content length]) {
        [_global appendData:_content] ;
    }
    [_global appendBytes:"]" length:1] ; // ajout 0 terminal
    
    [self _encodeGlobalHexaUnsignedInt:[_global longCRC] inRange:range] ;
   
    ret = [_global retain] ;
      
    return [ret autorelease] ;
    
}

@end

@implementation MSTEncoder (Private)

- (void)_encodeTokenSeparator { _tokenCount++ ; [_content appendBytes:(const void*)"," length:1];}

- (void)_encodeTokenType:(MSByte)tokenType
{
    char toAscii[4] = "";
    NSUInteger len;

    sprintf(toAscii, "%u", tokenType);
    len = (MSUInt)strlen(toAscii) ;
    [_content appendBytes:(const void*)toAscii length:len];
}

- (void)_encodeGlobalUnicodeString:(const char *)str // encodes an UTF8 string
{
    if (str) {
        NSUInteger len = (MSUInt)strlen(str) ;
        [_global appendBytes:(const void*)"\"" length:1];
        if (len) {
            NSUInteger i ;
            
            for (i=0 ; i<len ; i++) {
                MSByte c = (MSByte)str[i] ;
                switch (c) { //Escape some characters
                    case 9 : { // \t
                        [_global appendBytes:(const void*)"\\" length:1];
                        [_global appendBytes:(const void*)"t" length:1];
                        break ;
                    }
                    case 10 : { // \n
                        [_global appendBytes:(const void*)"\\" length:1];
                       [_global appendBytes:(const void*)"n" length:1];
                        break ;
                    }
                    case 13 : { // \r
                        [_global appendBytes:(const void*)"\\" length:1];
                        [_global appendBytes:(const void*)"r" length:1];
                        break ;
                    }
                    case 34 : { // \"
                        [_global appendBytes:(const void*)"\\" length:1];
                        [_global appendBytes:(const void*)"\"" length:1];
                        break ;
                    }
                    case 92 : { // antislash
                        [_global appendBytes:(const void*)"\\" length:1];
                        [_global appendBytes:(const void*)"\\" length:1];
                        break ;
                    }
                    case 47 : { // slash
                        [_global appendBytes:(const void*)"\\" length:1];
                        [_global appendBytes:(const void*)"/" length:1];
                        break ;
                    }
                    default: {
                        unsigned char car = (unsigned char)c ;   
                        [_global appendBytes:(const void*)&car length:1];
                        break ;
                    }
                }
            }
        }
        [_global appendBytes:(const void*)"\"" length:1];
    }
    else [NSException raise:NSGenericException format:@"_encodeGlobalUnicodeString: no string to encode!"] ;
}

- (void)_encodeGlobalUnsignedLongLong:(MSULong)l
{
    char toAscii[21] = "";
    NSUInteger len ;
    
    sprintf(toAscii, "%llu", l);
    len = (MSUInt)strlen(toAscii) ;    
    [_global appendBytes:(const void*)toAscii length:len];
    
}

- (void)_encodeGlobalHexaUnsignedInt:(unsigned int)i inRange:(NSRange)range
{
    unsigned char b0 = (unsigned char)((i & 0xF0000000)>>28);
    unsigned char b1 = (unsigned char)((i & 0x0F000000)>>24);
    unsigned char b2 = (unsigned char)((i & 0x00F00000)>>20);
    unsigned char b3 = (unsigned char)((i & 0x000F0000)>>16);
    unsigned char b4 = (unsigned char)((i & 0x0000F000)>>12);
    unsigned char b5 = (unsigned char)((i & 0x00000F00)>>8);
    unsigned char b6 = (unsigned char)((i & 0x000000F0)>>4);
    unsigned char b7 = (unsigned char)(i & 0x0000000F);
    unsigned char s[9];
    
    s[0] = _ShortValueToHexaCharacter(b0) ;
    s[1] = _ShortValueToHexaCharacter(b1) ;
    s[2] = _ShortValueToHexaCharacter(b2) ;
    s[3] = _ShortValueToHexaCharacter(b3) ;
    s[4] = _ShortValueToHexaCharacter(b4) ;
    s[5] = _ShortValueToHexaCharacter(b5) ;
    s[6] = _ShortValueToHexaCharacter(b6) ;
    s[7] = _ShortValueToHexaCharacter(b7) ;
    [_global replaceBytesInRange:range withBytes:s] ;
}

- (void)_clean
{
    if (_classes) NSFreeMapTable(_classes) ;
    if (_keys) NSFreeMapTable(_keys) ;
    if (_encodedObjects) NSFreeMapTable(_encodedObjects) ;
    _keys = _classes = _encodedObjects = (NSMapTable *)nil ;
    _lastKeyIndex = _lastClassIndex = _lastReference = _tokenCount = 0 ;
    [_keysArray release] ;
    [_classesArray release] ;
    [_content release] ;
    [_global release] ;
}

@end

@implementation NSObject (MSTEncoding)

- (MSByte)tokenType { return MSTE_TOKEN_TYPE_USER_CLASS ; } //must be overriden by subclasse to be encoded
- (NSDictionary *)MSTESnapshot { [NSException raise:NSGenericException format:@"method not implemented"] ; return nil ; } //must be overriden by subclasse to be encoded as a dictionary. keys of snapshot are member names, values are MSCouple with the member in firstMember and in secondMember : nil if member is strongly referenced, or not nil if member is weakly referenced.

- (MSInt)singleEncodingCode:(MSTEncoder *)encoder {return MSTE_TOKEN_MUST_ENCODE ; }
- (NSData *)MSTEncodedBuffer
{
    MSTEncoder *encoder = [[MSTEncoder alloc]init] ;
    NSData *ret = [encoder encodeRootObject:self] ;
    [encoder release] ;
    return ret ;
}

@end

@implementation NSObject (MSTEncodingPrivate)

- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder { [NSException raise:NSGenericException format:@"method not implemented"] ;  } //must be overriden by subclasse to be encoded

@end

@implementation NSNull (MSTEncoding)
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_NULL ; }
- (MSInt)singleEncodingCode:(MSTEncoder *)encoder { return MSTE_TOKEN_TYPE_NULL ; }
@end


@implementation NSString (MSTEncoding)
- (MSInt)singleEncodingCode:(MSTEncoder *)encoder
{
    return [self length] ? MSTE_TOKEN_MUST_ENCODE : MSTE_TOKEN_TYPE_EMPTY_STRING ;
}
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_STRING ; }
@end

@implementation NSString (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder
{
    if ([self length]) [encoder encodeString:self withTokenType:NO] ;
}
@end

static NSNumber *__aBool = nil ;


@implementation NSNumber (MSTEncoding)
- (MSInt)singleEncodingCode:(MSTEncoder *)encoder
{
    unsigned char type = *[self objCType] ;
    if (type == 'c') {
        if(!__aBool) __aBool = [NSNumber numberWithBool:YES] ;
        if([self isKindOfClass:[__aBool class]]) {
            if ([self isTrue]) return MSTE_TOKEN_TYPE_TRUE ;
            else return MSTE_TOKEN_TYPE_FALSE ;
        }
    }
    return MSTE_TOKEN_MUST_ENCODE ;
}

- (MSByte)tokenType
{
    unsigned char type = *[self objCType] ;
    switch (type) {
        case 'c':
        {
            return MSTE_TOKEN_TYPE_CHAR ;
            break ;
        }
        case 'C':
        {
            return MSTE_TOKEN_TYPE_UNSIGNED_CHAR ;
            break ;
        }
        case 's':
        {
            return MSTE_TOKEN_TYPE_SHORT ;
            break ;
        }
        case 'S':
        {
            return MSTE_TOKEN_TYPE_UNSIGNED_SHORT ;
            break ;
        }
        case 'i':
        case 'l':
        {
            return MSTE_TOKEN_TYPE_INT32 ;
            break ;
        }
        case 'I':
        case 'L':
        {
            return MSTE_TOKEN_TYPE_INSIGNED_INT32 ;
            break ;
        }
        case 'q':
        {
            return MSTE_TOKEN_TYPE_INT64 ;
            break ;
        }
        case 'Q':
        {
            return MSTE_TOKEN_TYPE_UNSIGNED_INT64 ;
            break ;
        }
        case 'f':
        {
            return MSTE_TOKEN_TYPE_FLOAT ;
            break ;
        }
        case 'd':
        {
            return MSTE_TOKEN_TYPE_DOUBLE ;
            break ;
        }
#ifdef WO451
        default:  [NSException raise:NSInvalidArgumentException format:@"Unknown number type '%s'", type] ; break;
#else
        default:  [NSException raise:NSInvalidArgumentException format:@"Unknown number type '%hhu'", type] ; break;
#endif
    }
    return 0 ;
}
@end

@implementation NSNumber (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder
{
    unsigned char type = *[self objCType] ;
    switch (type) {
        case 'c': [encoder encodeChar:[self charValue] withTokenType:NO] ; break;
        case 'C': [encoder encodeUnsignedChar:[self unsignedCharValue] withTokenType:NO] ; break;
        case 's': [encoder encodeShort:[self shortValue] withTokenType:NO] ; break;
        case 'S': [encoder encodeUnsignedShort:[self unsignedShortValue] withTokenType:NO] ; break;
        case 'i': [encoder encodeInt:[self intValue] withTokenType:NO] ; break;
        case 'I': [encoder encodeUnsignedInt:[self unsignedIntValue] withTokenType:NO] ; break;
        case 'l': [encoder encodeInt:(int)[self longValue] withTokenType:NO] ; break;
        case 'L': [encoder encodeUnsignedInt:(unsigned int)[self unsignedLongValue] withTokenType:NO] ; break;
        case 'q': [encoder encodeLongLong:[self longLongValue] withTokenType:NO] ; break;
        case 'Q': [encoder encodeUnsignedLongLong:[self unsignedLongLongValue] withTokenType:NO] ; break;
        case 'f': [encoder encodeFloat:[self floatValue] withTokenType:NO] ; break;
        case 'd': [encoder encodeDouble:[self doubleValue] withTokenType:NO] ; break;
            #ifdef WO451
        default:  [NSException raise:NSInvalidArgumentException format:@"Unknown number type '%s'", type] ; break;
#else
        default:  [NSException raise:NSInvalidArgumentException format:@"Unknown number type '%hhu'", type] ; break;
#endif
    }
}
@end

@implementation NSDictionary (MSTEncoding)
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_DICTIONARY ; }
@end

@implementation NSDictionary (MSTEncodingPricate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder { [encoder encodeDictionary:self] ; }
@end

@implementation NSArray (MSTEncoding)
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_ARRAY ; }
@end

@implementation NSArray (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder { [encoder encodeArray:self] ; }
@end


@implementation NSDate (MSTEncoding)
- (MSInt)singleEncodingCode:(MSTEncoder *)encoder
{
    if ([[NSDate distantPast] isEqual:self]) return MSTE_TOKEN_TYPE_DISTANT_PAST ;
    else if ([[NSDate distantFuture] isEqual:self]) return MSTE_TOKEN_TYPE_DISTANT_FUTURE ;
    else return MSTE_TOKEN_MUST_ENCODE ;
}
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_DATE ; }
@end

@implementation NSDate (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder
{
    if (![[NSDate distantPast] isEqual:self] && ![[NSDate distantFuture] isEqual:self]) [encoder encodeLongLong:[self timeIntervalSince1970] withTokenType:NO] ;
}
@end

@implementation MSCouple (MSTEncoding)
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_COUPLE ; }
@end

@implementation MSCouple (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder
{
    [encoder encodeObject:_members[0]] ;
    [encoder encodeObject:_members[1]] ;
}
@end

@implementation NSData (MSTEncoding)
- (MSInt)singleEncodingCode:(MSTEncoder *)encoder
{
    return [self length] ? MSTE_TOKEN_MUST_ENCODE : MSTE_TOKEN_TYPE_EMPTY_DATA ;
}
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_BASE64_DATA ; }
@end

@implementation NSData (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder {
    [encoder encodeBytes:(void *)[self bytes] length:[self length] withTokenType:NO] ;
}
@end

@implementation MSColor (MSTEncoding)
- (MSByte)tokenType { return MSTE_TOKEN_TYPE_COLOR ; }
@end

@implementation MSColor (MSTEncodingPrivate)
- (void)encodeWithMSTEncoder:(MSTEncoder *)encoder { [encoder encodeUnsignedInt:[self cssValue] withTokenType:NO] ; }
@end
