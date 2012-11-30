//
//  MSTEncodeur.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
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
class MSTEWString;


#define MSTE_TOKEN_TYPE_NULL                0
#define MSTE_TOKEN_TYPE_TRUE                1
#define MSTE_TOKEN_TYPE_FALSE               2
#define MSTE_TOKEN_TYPE_INTEGER_VALUE       3
#define MSTE_TOKEN_TYPE_REAL_VALUE          4
#define MSTE_TOKEN_TYPE_STRING              5
#define MSTE_TOKEN_TYPE_DATE                6
#define MSTE_TOKEN_TYPE_COLOR               7
#define MSTE_TOKEN_TYPE_DICTIONARY          8
#define MSTE_TOKEN_TYPE_REFERENCED_OBJECT   9
#define MSTE_TOKEN_TYPE_CHAR                10
#define MSTE_TOKEN_TYPE_UNSIGNED_CHAR       11
#define MSTE_TOKEN_TYPE_SHORT               12
#define MSTE_TOKEN_TYPE_UNSIGNED_SHORT      13
#define MSTE_TOKEN_TYPE_INT32               14
#define MSTE_TOKEN_TYPE_UNSIGNED_INT32      15
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

#define MSTE_TOKEN_TYPE_USER_CLASS          50
#define MSTE_TOKEN_USER_CLASS_MARKER        254
#define MSTE_TOKEN_MUST_ENCODE              255


static const string base64_chars =
"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"abcdefghijklmnopqrstuvwxyz"
"0123456789+/";

class MSTEncodeur {
private:
	stringstream ss;
	stringstream ssGlobal;
	string ssStreamString;
	string ssGlobalString;
	string ssRes;
	string global;
	vector<string> keysArray;
	map<string,int> keys;
	vector<string> classesArray;
	map<string,int> classes;
	map<void*,int> encodedObject;
	int tokenCount;
	int lastKeyIndex;
	int lastClassIndex;
	int lastReference;
    
public:
	MSTEncodeur();
	virtual ~MSTEncodeur();
    
	void encodeTokenSeparator();
	void encodeBool(MSTEBool* o);
	void encodeInt(int o);
	void encodeUInt(unsigned int o);
	void encodeDouble(double o);
	void encodeChar(char o);
	void encodeUChar(unsigned char o);
	void encodeShort(short o);
	void encodeUShort(unsigned short o);
	void encodeLong(long o);
	void encodeULong(unsigned long o);
	void encodeLongLong(long long o);
	void encodeULongLong(unsigned long long o);
	void encodeGlobalULongLong (unsigned long long o);
	void encodeFloat(float o);
	void encodeString(MSTEString* o);
    void encodeWString(MSTEString* o);
	void encodeDate(MSTEDate* o);
	void encodeDistantPast(MSTEDate* o);
	void encodeDistantFuture(MSTEDate* o);
	void encodeBase64(MSTEData* o);
	static inline bool is_base64(unsigned char c) {
        return (isalnum(c) || (c == '+') || (c == '/'));
	}
    
    
	void encodeDictionary(MSTEDictionary* o);
    void encodeRootDictionary(MSTEDictionary* o);
	void encodeArray(MSTEArray* o);
	void encodeNaturalArray(MSTENaturalArray* o);
	void encodeCouple(MSTECouple* o);
	void encodeColor(MSTEColor* o);
	unsigned char shortValueToHexaCharacter(char16_t o);
	void encodeGlobalUnicodeString(string o);
    
	void encodeObject(MSTEObject* o);
	void encodeRootObject(MSTEObject* o);
	void encodeFinChaine();
	void clean();
};

