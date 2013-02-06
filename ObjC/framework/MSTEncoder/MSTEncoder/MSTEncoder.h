/*
 
 MSTEncoder.h
 
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

#define MSTE_TOKEN_MUST_ENCODE              -1

#define MSTE_TOKEN_TYPE_NULL                0
#define MSTE_TOKEN_TYPE_TRUE                1
#define MSTE_TOKEN_TYPE_FALSE               2
#define MSTE_TOKEN_TYPE_INTEGER_VALUE       3
#define MSTE_TOKEN_TYPE_REAL_VALUE          4
#define MSTE_TOKEN_TYPE_STRING              5
#define MSTE_TOKEN_TYPE_DATE                6
#define MSTE_TOKEN_TYPE_COLOR               7
#define MSTE_TOKEN_TYPE_DICTIONARY          8
#define MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT   9
#define MSTE_TOKEN_TYPE_CHAR                10
#define MSTE_TOKEN_TYPE_UNSIGNED_CHAR       11
#define MSTE_TOKEN_TYPE_SHORT               12
#define MSTE_TOKEN_TYPE_UNSIGNED_SHORT      13
#define MSTE_TOKEN_TYPE_INT32               14
#define MSTE_TOKEN_TYPE_INSIGNED_INT32      15
#define MSTE_TOKEN_TYPE_INT64               16
#define MSTE_TOKEN_TYPE_UNSIGNED_INT64      17
#define MSTE_TOKEN_TYPE_FLOAT               18
#define MSTE_TOKEN_TYPE_DOUBLE              19
#define MSTE_TOKEN_TYPE_ARRAY               20
#define MSTE_TOKEN_TYPE_NATURAL_ARRAY       21
#define MSTE_TOKEN_TYPE_COUPLE              22
#define MSTE_TOKEN_TYPE_BASE64_DATA         23
#define MSTE_TOKEN_TYPE_DISTANT_PAST        24
#define MSTE_TOKEN_TYPE_DISTANT_FUTURE      25
#define MSTE_TOKEN_TYPE_EMPTY_STRING        26
#define MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT   27

#define MSTE_TOKEN_LAST_DEFINED_TYPE        MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT

#define MSTE_TOKEN_TYPE_USER_CLASS        50
#define MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_USER_OBJECT       MSTE_TOKEN_TYPE_USER_CLASS
#define MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_USER_OBJECT         MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_USER_OBJECT + 1

#import "MSTETypes.h"
#import "MSColor.h"
#import "MSCouple.h"
#import "MSTDecoder.h"




@interface MSTEncoder : NSObject
{
	NSMutableData *_content, *_global ;
	NSMapTable *_keys ;
    NSMutableArray *_keysArray ;
	NSMapTable *_classes ;
    NSMutableArray *_classesArray ;
    NSMapTable *_encodedObjects ;
    NSUInteger _lastClassIndex ;
    NSUInteger _lastKeyIndex ;
    NSUInteger _lastReference ;
    NSUInteger _tokenCount ;
}

+ (id)encoder ;

- (void)encodeBool:(BOOL)b withTokenType:(BOOL)token ;
- (void)encodeBytes:(void *)bytes length:(NSUInteger)length withTokenType:(BOOL)token ;
- (void)encodeUnicodeString:(const char *)str withTokenType:(BOOL)token ; // encodes an UTF8 string
- (void)encodeString:(NSString *)s withTokenType:(BOOL)token ; // transforms a string in its UTF16 counterpart and encodes it
- (void)encodeUnsignedChar:(MSByte)c withTokenType:(BOOL)token ;
- (void)encodeChar:(MSChar)c withTokenType:(BOOL)token ;
- (void)encodeUnsignedShort:(MSUShort)s withTokenType:(BOOL)token ;
- (void)encodeShort:(MSShort)s withTokenType:(BOOL)token ;
- (void)encodeUnsignedInt:(MSUInt)i withTokenType:(BOOL)token ;
- (void)encodeInt:(MSInt)i withTokenType:(BOOL)token ;
- (void)encodeUnsignedLongLong:(MSULong)l withTokenType:(BOOL)token ;
- (void)encodeLongLong:(MSLong)l withTokenType:(BOOL)token ;
- (void)encodeFloat:(float)f withTokenType:(BOOL)token ;
- (void)encodeDouble:(double)d withTokenType:(BOOL)token ;

- (void)encodeArray:(NSArray *)anArray ;
- (void)encodeDictionary:(NSDictionary *)aDictionary isSnapshot:(BOOL)isSnapshot ;
- (void)encodeDictionary:(NSDictionary *)aDictionary ;

- (void)encodeObject:(id)anObject ;
- (void)encodeObject:(id)anObject weaklyReferenced:(BOOL)weakRef ;

- (NSMutableData *)encodeRootObject:(id)anObject ;

@end

@interface NSObject (MSTEncoding)
- (MSByte)tokenType ; //must be overriden by subclasse to be encoded
- (NSDictionary *)MSTESnapshot ; //must be overriden by subclasse to be encoded as a dictionary
- (NSData *)MSTEncodedBuffer ; //returns a buffer containing the object encoded with MSTE protocol
- (MSInt)singleEncodingCode:(MSTEncoder *)encoder ; // defaults returns MSTE_TOKEN_MUST_ENCODE
@end


