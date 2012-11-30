//
//  MSTDecodeur.h
//  MSTEncodDecodCpp
//
//  Created by Melodie on 24/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include <sstream>
#include <vector>
#include <map>
using namespace std;

class MSTEObject ;
class MSTEArray ;
class MSTEColor ;
class MSTEBool ;
class MSTECouple ;
class MSTEData ;
class MSTEDate ;
class MSTEDictionary ;
class MSTENaturalArray ;
class MSTENumber ;
class MSTEString ;


#define MSCharMin		-128
#define MSCharMax		127
#define MSByteMax		255
#define MSShortMin		-32768
#define MSShortMax		32767
#define MSUShortMax		65535
#define MSIntMax		2147483647
#define MSIntMin		(-MSIntMax-1)
#define MSUIntMax		4294967295U
#define MSLongMax		9223372036854775807LL
#define MSLongMin		(-MSLongMax-1)
#define	MSULongMax		18446744073709551615ULL

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
static MSTEDate *__theDistantPast = NULL ;
static MSTEDate *__theDistantFuture = NULL ;

class MSTDecodeur {
    private :
	bool MSUnicharIsHexa(unsigned c) { return ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f')) ; }
    //vector<MSTEObject*> *decodedObjects;
public:
	MSTDecodeur();
	virtual ~MSTDecodeur();
	unsigned char MSTDecodeUnsignedChar(unsigned char **pointer, unsigned char *endPointer, string *operation);
	char MSTDecodeChar(unsigned char **pointer, unsigned char *endPointer, string *operation);
	unsigned short MSTDecodeUnsignedShort(unsigned char **pointer, unsigned char *endPointer, string *operation);
	short MSTDecodeShort(unsigned char **pointer, unsigned char *endPointer, string *operation);
	unsigned int MSTDecodeUnsignedInt(unsigned char **pointer, unsigned char *endPointer, string *operation);
	int MSTDecodeInt(unsigned char **pointer, unsigned char *endPointer, string *operation);
	unsigned long MSTDecodeUnsignedLong(unsigned char **pointer, unsigned char *endPointer, string *operation);
	long MSTDecodeLong(unsigned char **pointer, unsigned char *endPointer, string *operation);
	float MSTDecodeFloat(unsigned char **pointer, unsigned char *endPointer, string *operation);
	double MSTDecodeDouble(unsigned char **pointer, unsigned char *endPointer, string *operation);
	void MSTJumpToNextToken(unsigned char **pointer, unsigned char *endPointer, unsigned long *tokenCount);
	MSTEColor *MSTDecodeColor(unsigned char **pointer, unsigned char *endPointer, string *operation);
	MSTECouple *MSTDecodeCouple(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount);
	MSTEArray * MSTDecodeArray(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount);
	MSTENaturalArray * MSTDecodeNaturalArray(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount);
	MSTEDictionary * MSTDecodeDictionary(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount, bool manageReference);
	MSTEString * MSTDecodeString(unsigned char **pointer, unsigned char *endPointer, string *operation);
    MSTEString * MSTDecodeWString(unsigned char **pointer, unsigned char *endPointer, string *operation);
	MSTENumber *MSTDecodeNumber(unsigned char **pointer, unsigned char *endPointer, short tokenType);
	void *MSTDecodeObject(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount);
	MSTEObject* MSTDecodeUserDefinedObject(unsigned char **pointer, unsigned char *endPointer, string *operation, unsigned short tokenType, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount);
	MSTEDate* MSTDecodeDate(long aDate);
    MSTEBool* MSTDecodeBool(bool aBool);
    MSTEObject* MSTDecodeRefObject(  unsigned char **pointer, vector<MSTEObject*> *decodedObjects, long ref);
    MSTEData* base64_decode(unsigned char **pointer, unsigned char *endPointer, string *operation);
    void* MSTDecodeRetainedObject(const char* data, bool verifyCRC);
    static unsigned int hexaCharacterToShortValue(unsigned char c)
	{
        if (c >= 48) {
            if (c <= 57) { //'0' to '9'
                return (unsigned int)(c - 48) ;
            }
            else if (c >= 65) {
                if (c <= 70) { //'A' to 'F'
                    return (unsigned int)(c - 55);
                }
                else if ((c >= 97) && (c <= 102)) { //'a' to 'f'
                    return (unsigned int)(c - 87) ;
                }
            }
        }
        throw"hexaCharacterToShortValue - not an hexadecimal character %c";
        return 0 ;
	}
    static inline bool is_base64(unsigned char c) {
        return (isalnum(c) || (c == '+') || (c == '/'));
    };
    
    
};

