//
//  MSTDecodeur.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 24/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"
#include <iostream>


MSTDecodeur::MSTDecodeur() {
	// TODO Auto-generated constructor stub
        
}

MSTDecodeur::~MSTDecodeur() {
	// TODO Auto-generated destructor stub
    //delete decodedObjects;
}


unsigned char MSTDecodeur::MSTDecodeUnsignedChar(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    unsigned long result = strtoull((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeUnsignedChar - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
    	if (result>MSByteMax) throw  "@MSTDecodeUnsignedChar - out of range (%llu)";
    }
    else throw "@MSTDecodeUnsignedChar - %@ (no termination)" + *operation;
	return (unsigned char) result;
}

char MSTDecodeur::MSTDecodeChar(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    long result = strtoll((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeChar - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
    	if ((result>MSCharMax) || (result<MSCharMin)) throw  "@MSTDecodeChar - out of range (%lld)";
    }
    else throw "@MSTDecodeChar - %@ (no termination)" + *operation;
	return (char) result;
}

unsigned short  MSTDecodeur::MSTDecodeUnsignedShort(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    unsigned long result = strtoull((const char *)s, &stopCar, 10) ;
    
    
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeUnsignedShort - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
    	if (result>MSUShortMax) throw  "@MSTDecodeUnsignedShort - out of range (%llu)";
    }
   // else throw "@MSTDecodeUnsignedShort - %@ (no termination)" + *operation;
	return (unsigned short) result;
}

short  MSTDecodeur::MSTDecodeShort(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    long result = strtoll((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeShort - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
    	if ((result>MSShortMax) || (result<MSShortMin)) throw  "@MSTDecodeShort - out of range (%llu)";
    }
    else throw "@MSTDecodeShort - %@ (no termination)" + *operation;
	return (short) result;
    
}

unsigned int  MSTDecodeur::MSTDecodeUnsignedInt(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    unsigned long result = strtoull((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeUnsignedInt - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
    	if (result>MSUIntMax) throw  "@MSTDecodeUnsignedInt - out of range (%llu)";
    }
    else throw "@MSTDecodeUnsignedInt - %@ (no termination)" + *operation;
    return (unsigned int) result;
}
int  MSTDecodeur::MSTDecodeInt(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    long result = strtoll((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeInt - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
    	if ((result>MSIntMax)|| (result<MSIntMin)) throw  "@MSTDecodeInt - out of range (%llu)";
    }
    else throw "@MSTDecodeInt - %@ (no termination)" + *operation;
	return (int) result;
}
unsigned long  MSTDecodeur::MSTDecodeUnsignedLong(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    unsigned long result = strtoull((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeUnsignedLong - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else throw "@MSTDecodeUnsignedLong - %@ (no termination)" + *operation;
	return (unsigned long) result;
    
}
long  MSTDecodeur::MSTDecodeLong(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    long result = strtoll((const char *)s, &stopCar, 10) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeLong - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else throw "@MSTDecodeLong - %@ (no termination)" + *operation;
	return (long) result;
}
float  MSTDecodeur::MSTDecodeFloat(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    float result = strtof((const char *)s, &stopCar) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeFloat - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else throw "@MSTDecodeFloat - %@ (no termination)" + *operation;
	return result;
}

double  MSTDecodeur::MSTDecodeDouble(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    char *stopCar;
    double result = strtod((const char *)s, &stopCar) ;
    if ((unsigned char *)stopCar > endPointer) throw "@MSTDecodeDouble - %@ (exceed buffer end)" + *operation;
    if ((unsigned char *)stopCar > s) {
        *pointer = (unsigned char *)stopCar ;
    }
    else throw "@MSTDecodeDouble - %@ (no termination)" + *operation;
	return result;
}

void MSTDecodeur::MSTJumpToNextToken(unsigned char **pointer, unsigned char *endPointer, unsigned long *tokenCount)
{
    unsigned char *s = (unsigned char *)*pointer ;
    
    bool separatorFound = false ;
    bool nextFound = false ;
    while (!separatorFound && (endPointer-s)) {
        
        if (*s != (unsigned char)',') { s++ ;  }
        else if (*s == (unsigned char)',') { s++ ; separatorFound = true ;  (*tokenCount)++ ; }
        else throw "MSTDecodeRetainedObject - Bad format (unexpected character before token separator)" ;
    }
    if (!separatorFound) throw "MSTDecodeRetainedObject - Bad format (no token separator)" ;
    
    while (!nextFound && (endPointer-s)) {
        if (*s == (unsigned char)' ') { s++ ; }
        nextFound = (*s != (unsigned char)' ') ;
    }
    if (!separatorFound) throw "MSTDecodeRetainedObject - Bad format (no next token)" ;
    
    *pointer = s ;
}

MSTEColor* MSTDecodeur::MSTDecodeColor(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    unsigned int rgbaValue = MSTDecodeUnsignedInt(&s, endPointer, operation) ;
    MSTEColor *ret = new MSTEColor(rgbaValue) ;

    *pointer = s ;

    return ret;
    
}

MSTECouple * MSTDecodeur::MSTDecodeCouple(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount)
{
    unsigned char *s = (unsigned char *)*pointer ;
    MSTEObject* firstMember;
    MSTEObject* secondMember;
    MSTECouple * ret = new MSTECouple();
    decodedObjects->push_back(ret);    

    firstMember = (MSTEObject*) MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount) ;    
    MSTJumpToNextToken(&s, endPointer, tokenCount) ;
    secondMember = (MSTEObject*) MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount) ;   
    
    ret = new MSTECouple(firstMember, secondMember);    
    
    *pointer = s ;
    
    return ret;
}

MSTEArray * MSTDecodeur::MSTDecodeArray(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount)
{
    unsigned char *s = (unsigned char *)*pointer ;
   	unsigned long count = MSTDecodeUnsignedLong(&s, endPointer, operation) ;
    
    MSTEArray * ret = new MSTEArray();
    decodedObjects->push_back(ret);
    
    if (count) {
        unsigned int i ;
        
        for (i = 0 ; i < count ; i++) {
            MSTEObject* object;
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            object = (MSTEObject*) MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount) ;
                        
            ret->setObjectVector(object);            
        }
    }
    
    *pointer = s ;
    return ret;
}

MSTENaturalArray * MSTDecodeur::MSTDecodeNaturalArray(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount)
{
    unsigned char *s = (unsigned char *)*pointer ;
   	unsigned long count = MSTDecodeUnsignedLong(&s, endPointer, operation) ;
    
    MSTENaturalArray * ret = new MSTENaturalArray();
    decodedObjects->push_back(ret);
    
    if (count) {
        unsigned int i ;
        
        for (i = 0 ; i < count ; i++) {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            int natural = MSTDecodeInt(&s, endPointer, operation) ;
            
            ret->setIntVector(natural);
        }
    }
    
    *pointer = s ;
    return ret;
}

MSTEDictionary * MSTDecodeur::MSTDecodeDictionary(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount, bool manageReference)
{
    unsigned char *s = (unsigned char *)*pointer ;
    unsigned long count = MSTDecodeUnsignedLong(&s, endPointer, operation) ;
       
    
    MSTEDictionary* ret = new MSTEDictionary();
    if (manageReference) {
    	decodedObjects->push_back(ret);
    }
    
    if (count!=0) {
    	unsigned int i ;
        
        for (i = 0 ; i < count ; i++) {
        	unsigned int keyReference ;
            MSTEObject* object;
            string key ;
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            keyReference = MSTDecodeUnsignedInt(&s, endPointer, operation) ;
          
            key = keys->at(keyReference) ;
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            
            object = (MSTEObject*) MSTDecodeObject(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount) ;
            
            ret->setObjectDictionary(key,object);
        }
    }
    *pointer = s ;
    return ret ;
}

MSTEString * MSTDecodeur::MSTDecodeString(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *start = (unsigned char *)*pointer ;
    unsigned char *s = start ;
    bool endStringFound = false ;
    short state = MSTE_DECODING_STRING_START ;
    string ret ="" ;
    MSTEString * result;
    
    while ((s < endPointer) && !endStringFound) {
        unsigned char character = *s ;
        
        switch (state) {
            case MSTE_DECODING_STRING_START:
            {                
                if ((unsigned char)character == (unsigned char)'"') { s++ ; state = MSTE_DECODING_STRING ; break ; }
                throw "_MSTDecodeString - %@ (wrong starting character : %c)" ;
                break ;
            }
            case MSTE_DECODING_STRING :
            {
                if ((unsigned char)character == (unsigned char)'\\') { s++ ;state = MSTE_DECODING_STRING_ESCAPED_CAR ; break ; }
                if ((unsigned char)character == (unsigned char)'"') { s++ ; state = MSTE_DECODING_STRING_STOP ; endStringFound = true ; break ; }
                
                ret += (unsigned char)character; //adding visible ascii character to unicode string
                s++ ; //pass to next character
                break ;
            }
            case MSTE_DECODING_STRING_ESCAPED_CAR :
            {
            	unsigned char character = (unsigned char)character ;
                if (character == (unsigned char)'r') {
                    ret += (unsigned char)0x000d ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'n')
                {
                    ret += (unsigned char)0x000a ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'t')
                {
                    ret += (unsigned char)0x0009 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'\\')
                {
                    ret += (unsigned char)0x005c ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'"')
                {
                    ret += (unsigned char)0x0022 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'/')
                {
                    ret += (unsigned char)0x002F ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'b')
                {
                    ret += (unsigned char)0x0008 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'f')
                {
                    ret += (unsigned char)0x0012 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (unsigned char)'u')
                {
                    //UTF16 value on 4 hexadecimal characters expected
                	unsigned char s0, s1, s2, s3 ;
                    
                    if ((endPointer-s)<5) throw "_MSTDecodeString - %@ (too short UTF16 character expected)" ;
                    
                    s0 = (unsigned char)s[1] ;
                    s1 = (unsigned char)s[2] ;
                    s2 = (unsigned char)s[3] ;
                    s3 = (unsigned char)s[4] ;
                    
                    if (!MSUnicharIsHexa(s0) ||
                        !MSUnicharIsHexa(s1) ||
                        !MSUnicharIsHexa(s2) ||
                        !MSUnicharIsHexa(s3))  throw "MSTDecodeString - %@ (bad hexadecimal character for UTF16)" ;
                    else {
                        unsigned short b0 = hexaCharacterToShortValue(s0) ;
                        unsigned short  b1 = hexaCharacterToShortValue(s1) ;
                        unsigned short  b2 = hexaCharacterToShortValue(s2) ;
                        unsigned short  b3 = hexaCharacterToShortValue(s3) ;
                        ret += (unsigned char)((b0<<12) + (b1<<8) + (b2<<4) + b3) ; //unicode character to unicode string
                        s += 5 ;
                        state = MSTE_DECODING_STRING ;
                    }
                    break ;
                }
                else {
                    throw "MSTDecodeString - %@ (unexpected escaped character : %c)" ;
                    break ;
                }
            }
            default: {
                throw"MSTDecodeString - %@ (unknown state)" ;
            }
        }
    }
    
    *pointer = s ;
    result = new MSTEString(ret);
    
    return  result ;
}

MSTEString * MSTDecodeur::MSTDecodeWString(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *start = (unsigned char *)*pointer ;
    unsigned char *s = start ;
    bool endStringFound = false ;
    short state = MSTE_DECODING_STRING_START ;
    wstring ret;

    MSTEString * result;

    
    while ((s < endPointer) && !endStringFound) {
        unsigned char character = *s ;
        
        switch (state) {
            case MSTE_DECODING_STRING_START:
            {
                if ((char16_t)character == (char16_t)'"') { s++ ; state = MSTE_DECODING_STRING ; break ; }
                throw "_MSTDecodeString - %@ (wrong starting character : %c)" ;
                break ;
            }
            case MSTE_DECODING_STRING :
            {   
                if ((char16_t)character == (char16_t)'\\') { s++ ; state = MSTE_DECODING_STRING_ESCAPED_CAR ; break ; }
                if ((char16_t)character == (char16_t)'"') { s++ ; state = MSTE_DECODING_STRING_STOP ; endStringFound = true ; break ; }
                
                ret += (char16_t)character; //adding visible ascii character to unicode string
                s++ ; //pass to next character
                break ;
            }
            case MSTE_DECODING_STRING_ESCAPED_CAR :
            {                
               //char16_t character = (char16_t)character ;

                if (character == (char16_t)'r') {
                    ret += (char16_t)0x000d ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'n')
                {
                    ret += (char16_t)0x000a ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'t')
                {
                    ret += (char16_t)0x0009 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'\\')
                {
                    ret += (char16_t)0x005c ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'"')
                {
                    ret += (char16_t)0x0022 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'/')
                {
                    ret += (char16_t)0x002F ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'b')
                {
                    ret += (char16_t)0x0008 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'f')
                {
                   
                    ret += (char16_t)0x0012 ;
                    s++ ;
                    state = MSTE_DECODING_STRING ;
                    break ;
                }
                else if (character == (char16_t)'u')
                {
                    //UTF16 value on 4 hexadecimal characters expected
                	char16_t s0, s1, s2, s3 ;
                                                            
                    if ((endPointer-s)<5) throw "_MSTDecodeString - %@ (too short UTF16 character expected)" ;
                    
                    s0 = (char16_t)s[1] ;
                    s1 = (char16_t)s[2] ;
                    s2 = (char16_t)s[3] ;
                    s3 = (char16_t)s[4] ;
                    
                    if (!MSUnicharIsHexa(s0) ||
                        !MSUnicharIsHexa(s1) ||
                        !MSUnicharIsHexa(s2) ||
                        !MSUnicharIsHexa(s3))  throw "MSTDecodeString - %@ (bad hexadecimal character for UTF16)" ;
                    else {
                        unsigned short b0 = hexaCharacterToShortValue(s0) ;
                        unsigned short  b1 = hexaCharacterToShortValue(s1) ;
                        unsigned short  b2 = hexaCharacterToShortValue(s2) ;
                        unsigned short  b3 = hexaCharacterToShortValue(s3) ;
                        ret += (unsigned char)((b0<<12) + (b1<<8) + (b2<<4) + b3) ; //unicode character to unicode string
                        s += 5 ;
                        state = MSTE_DECODING_STRING ;
                    }
                    break ;
                }
                else {
                    throw "MSTDecodeString - %@ (unexpected escaped character : %c)" ;
                    break ;
                }
            }
            default: {
                throw"MSTDecodeString - %@ (unknown state)" ;
            }
                
        }
    }
    
    *pointer = s ;
   
    result = new MSTEString(ret);
    
    return  result ;
}


MSTENumber *MSTDecodeur::MSTDecodeNumber(unsigned char **pointer, unsigned char *endPointer, short tokenType)
{
    unsigned char *s = (unsigned char *)*pointer ;
    MSTENumber* ret;
    string sNumb = "MSTDecodeNumber";
    
    switch (tokenType) {
        case MSTE_TOKEN_TYPE_INTEGER_VALUE : {
            ret= new MSTENumber(MSTDecodeInt(&s, endPointer, &sNumb)) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_REAL_VALUE :
        case MSTE_TOKEN_TYPE_DOUBLE : {
            ret= new MSTENumber(MSTDecodeDouble(&s, endPointer, &sNumb));
            break ;
        }
        case MSTE_TOKEN_TYPE_CHAR : {
            ret= new MSTENumber(MSTDecodeChar(&s, endPointer, &sNumb));
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_CHAR : {
            ret= new MSTENumber(MSTDecodeUnsignedChar(&s, endPointer, &sNumb)) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_SHORT : {
            ret= new MSTENumber(MSTDecodeShort(&s, endPointer, &sNumb));
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_SHORT : {
            ret= new MSTENumber(MSTDecodeUnsignedShort(&s, endPointer, &sNumb));
            break ;
        }
        case MSTE_TOKEN_TYPE_INT32 : {
            ret= new MSTENumber(MSTDecodeInt(&s, endPointer, &sNumb)) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_INT32 : {
        	ret= new MSTENumber(MSTDecodeUnsignedInt(&s, endPointer, &sNumb)) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_INT64 : {
        	ret= new MSTENumber(MSTDecodeLong(&s, endPointer, &sNumb)) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_UNSIGNED_INT64 : {
        	ret= new MSTENumber(MSTDecodeUnsignedLong(&s, endPointer, &sNumb)) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_FLOAT : {
        	ret= new MSTENumber(MSTDecodeFloat(&s, endPointer, &sNumb)) ;
            break ;
        }
        default: {
            throw"_MSTDecodeNumber - unknown tokenType" ;
        }
    }
    
    *pointer = s ;
    return ret ;
}

MSTEDate* MSTDecodeur::MSTDecodeDate(long aDate)
{
    
    MSTEDate* date = new MSTEDate(difftime(aDate, time(NULL)));
    return date;
    
}

MSTEBool* MSTDecodeur::MSTDecodeBool(bool aBool)
{
    MSTEBool* mBool = new MSTEBool(aBool);
    return mBool;
    
}


MSTEObject* MSTDecodeur::MSTDecodeRefObject( unsigned char **pointer, vector<MSTEObject*> *decodedObjects, long ref)
{
    unsigned char *s = (unsigned char *)*pointer ;
    MSTEObject* object;
    
    object = (decodedObjects->at(ref));
    
    *pointer = s ;
    return object;
}

MSTEData* MSTDecodeur::base64_decode(unsigned char **pointer, unsigned char *endPointer, string *operation)
{
    unsigned char *s = (unsigned char *)*pointer ;
    MSTEString* stri = MSTDecodeString(pointer,endPointer,operation) ;
    string encoded_string = stri->getString();
  
    unsigned long in_len = encoded_string.size();
    int i = 0;
    int j = 0;
    int in_ = 0;
    unsigned char char_array_4[4], char_array_3[3];
    string ret;
    
    while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
        char_array_4[i++] = encoded_string[in_]; in_++;
        if (i ==4) {
            for (i = 0; i <4; i++)
                char_array_4[i] = base64_chars.find(char_array_4[i]);
            
            char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
            char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
            char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];
            
            for (i = 0; (i < 3); i++)
                ret += char_array_3[i];
                i = 0;
        }
    }
    
    if (i) {
        for (j = i; j <4; j++)
            char_array_4[j] = 0;
        
        for (j = 0; j <4; j++)
            char_array_4[j] = base64_chars.find(char_array_4[j]);
        
        char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
        char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
        char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];
        
        for (j = 0; (j < i - 1); j++) ret += char_array_3[j];
    }
    
    char *cstr = new char[ret.length() + 1];
    strcpy(cstr, ret.c_str());
    
    MSTEData * data = new MSTEData(cstr);    
   
   
    *pointer = s ;
    
    return data;
}


void* MSTDecodeur::MSTDecodeObject(unsigned char **pointer, unsigned char *endPointer, string *operation, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount)
{
    
    unsigned char *s = (unsigned char *)*pointer ;
    MSTEObject* ret = new MSTEObject() ;
    string tType = "token type";
    string sDecod = "MSTDecodeObject";
    unsigned short tokenType = MSTDecodeUnsignedShort(&s, endPointer, &tType ) ;

    switch (tokenType) {
        case MSTE_TOKEN_TYPE_TRUE : {
            ret = MSTDecodeBool(true);
            s++;
            break ;
        }
        case MSTE_TOKEN_TYPE_FALSE : {
            ret = MSTDecodeBool(false);
            s++;
            break ;
        }
        case MSTE_TOKEN_TYPE_INTEGER_VALUE :
        case MSTE_TOKEN_TYPE_REAL_VALUE :
        {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeNumber(&s, endPointer, tokenType) ;
            decodedObjects->push_back(ret);
            break ;
        }
        case MSTE_TOKEN_TYPE_CHAR :
        case MSTE_TOKEN_TYPE_UNSIGNED_CHAR :
        case MSTE_TOKEN_TYPE_SHORT :
        case MSTE_TOKEN_TYPE_UNSIGNED_SHORT :
        case MSTE_TOKEN_TYPE_INT32 :
        case MSTE_TOKEN_TYPE_UNSIGNED_INT32 :
        case MSTE_TOKEN_TYPE_INT64 :
        case MSTE_TOKEN_TYPE_UNSIGNED_INT64 :
        case MSTE_TOKEN_TYPE_FLOAT :
        case MSTE_TOKEN_TYPE_DOUBLE :
        {
            //no reference on simple types
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeNumber(&s, endPointer, tokenType);
            decodedObjects->push_back(ret);
            break ;
        }
        case MSTE_TOKEN_TYPE_STRING : {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeWString(&s, endPointer, &sDecod) ;            
            decodedObjects->push_back(ret);                      
            break ;
        }
        case MSTE_TOKEN_TYPE_DATE : {
            long seconds ;
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            seconds = MSTDecodeLong(&s, endPointer,&sDecod) ;
            ret= MSTDecodeDate(seconds);
            decodedObjects->push_back(ret);
            break ;
        }
        case MSTE_TOKEN_TYPE_DICTIONARY : {
           
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeDictionary(&s, endPointer, &sDecod, decodedObjects, classes, keys, tokenCount, true) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_REFERENCED_OBJECT : {
            long objectReference =0;
            
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            
            objectReference = MSTDecodeLong(&s, endPointer, &sDecod) ;
            ret = decodedObjects->at(objectReference);
            //ret = MSTDecodeRefObject(&s, decodedObjects, objectReference);

            break ;
        }
        case MSTE_TOKEN_TYPE_COLOR : {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeColor(&s, endPointer, &sDecod) ;
            decodedObjects->push_back(ret);
            
            
            break ;
        }
        case MSTE_TOKEN_TYPE_ARRAY : {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeArray(&s, endPointer, &sDecod, decodedObjects, classes, keys, tokenCount) ;
            
            break ;
        }
        case MSTE_TOKEN_TYPE_NATURAL_ARRAY : {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeNaturalArray(&s, endPointer, &sDecod, decodedObjects,  classes, keys, tokenCount) ;
            
            break ;
        }
        case MSTE_TOKEN_TYPE_COUPLE : {
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            ret = MSTDecodeCouple(&s, endPointer, &sDecod, decodedObjects, classes, keys, tokenCount) ;
            break ;
        }
        case MSTE_TOKEN_TYPE_BASE64_DATA : {
            
            MSTJumpToNextToken(&s, endPointer, tokenCount) ;
            
            ret = base64_decode(&s, endPointer, &sDecod) ;
            decodedObjects->push_back(ret);
            
            
            break ;
        }
        case MSTE_TOKEN_TYPE_DISTANT_PAST : {
            ret = __theDistantPast;
            s++;
            break ;
        }
        case MSTE_TOKEN_TYPE_DISTANT_FUTURE : {
        	ret = __theDistantFuture ;
            s++;
            break ;
        }
        case MSTE_TOKEN_TYPE_EMPTY_STRING : {
             break ;
        }
        default :
        {
            if (tokenType >= MSTE_TOKEN_TYPE_USER_CLASS) {
                
                
                MSTJumpToNextToken(&s, endPointer, tokenCount) ;
                ret = MSTDecodeUserDefinedObject(&s, endPointer,&sDecod, tokenType, decodedObjects, classes, keys, tokenCount) ;
            }
            else throw "MSTDecodeObject - unknown tokenType : %u";
            break ;
        }
    }
    
    *pointer = s ;
    return ret ;
}

MSTEObject* MSTDecodeur::MSTDecodeUserDefinedObject(unsigned char **pointer, unsigned char *endPointer, string *operation, unsigned short tokenType, vector<MSTEObject*> *decodedObjects, vector<string> *classes, vector<string> *keys, unsigned long *tokenCount)
{
    unsigned char *s = (unsigned char *)*pointer ;
    MSTEObject * ret ;
    int classIndex = tokenType - MSTE_TOKEN_TYPE_USER_CLASS ;

    if ((classIndex >=0) && (classIndex < (int)(classes->size()))) {
        string className = classes->at(classIndex);
        if (className!="") {
            MSTEDictionary *dictionary ;
            decodedObjects->push_back(ret);
            
            dictionary = MSTDecodeDictionary(&s, endPointer, operation, decodedObjects, classes, keys, tokenCount, false) ;
                                    
            ret =  new MSTEObject(dictionary->getMap());
            
        }
        else throw "_MSTDecodeUserDefinedObject - unable to find user class %@ in current system" ;
    }
    else throw "_MSTDecodeUserDefinedObject - unable to find user class at index";
    
    *pointer = s ;
    return ret ;
}


void* MSTDecodeur::MSTDecodeRetainedObject(const char* data, bool verifyCRC)
{
    unsigned long len = strlen(data);
     
    if (len > 26) { //minimum header size : ["MSTE0101",3,"CRC00000000" ...]
        unsigned char *s = (unsigned char *) data;
        unsigned char *end = (unsigned char *)s+len-1 ;
        unsigned char *crcPtr = NULL ;
        char crc[9] ;
        unsigned int crcInt = 0;
        unsigned long tokenNumber, classesNumber, keysNumber =0 ;
        vector<string> *decodedClasses = new vector<string>() ;
        vector<string> *decodedKeys = new vector<string>()  ;
        short state = MSTE_DECODING_ARRAY_START ;
        void* object;
        vector<MSTEObject*> *decodedObjects = new vector<MSTEObject*>();

        
        unsigned long myTokenCount = 0 ;
        
        while ((s < (end+1))) {
          
            
            switch (state) {
                case MSTE_DECODING_ARRAY_START: {
                
                    if (*s == (unsigned char)' ') { s++ ; break ; }
                    if (*s == (unsigned char)'[') { s++ ; state = MSTE_DECODING_VERSION_START ; break ; }
                    throw "MSTDecodeRetainedObject - Bad header format (array start)";
                }
                case MSTE_DECODING_VERSION_START : {
                  
                    if (*s == (unsigned char)' ') { s++ ; break ; }
                    if (*s == (unsigned char)'"') { s++ ; state = MSTE_DECODING_VERSION_HEADER ; break ; }
                    
                    throw "MSTDecodeRetainedObject - Bad header format (start)" ;
                }
                case MSTE_DECODING_VERSION_HEADER : {
                    
                    if (((end-s) < 4) || (s[0] != (unsigned char)'M') || (s[1] != (unsigned char)'S') || (s[2] != (unsigned char)'T') || (s[3] != (unsigned char)'E')) {
                        throw "MSTDecodeRetainedObject - Bad header format (MSTE marker)" ; }
                    s += 4 ;
                    state = MSTE_DECODING_VERSION_VALUE ;
                    break ;
                }
                case MSTE_DECODING_VERSION_VALUE : {
                    //if (((end-s) < 4) || !MSUnicharIsIsoDigit(s[0])|| !MSUnicharIsIsoDigit(s[1])|| !MSUnicharIsIsoDigit(s[2])|| !MSUnicharIsIsoDigit(s[3])) {
                    //    throw "MSTDecodeRetainedObject - Bad header version" ; }
                    
                    s += 4 ;
                    state = MSTE_DECODING_VERSION_END ;
                    break ;
                }
                case MSTE_DECODING_VERSION_END : {
                    
                    if (*s == (unsigned char)'"') { s++ ; state = MSTE_DECODING_VERSION_NEXT_TOKEN ; }
                    else throw "MSTDecodeRetainedObject - Bad header format (version end)" ;
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
                    
                    MSTJumpToNextToken(&s, end, &myTokenCount) ;
                    switch (state) {
                      
                        case MSTE_DECODING_VERSION_NEXT_TOKEN:
                            state = MSTE_DECODING_TOKEN_NUMBER_VALUE ; break ;
                        case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN:
                            state = MSTE_DECODING_CRC_START ; break ;
                        case MSTE_DECODING_CRC_NEXT_TOKEN:
                            state = MSTE_DECODING_CLASSES_NUMBER_VALUE ;break ;
                        case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN:
                            
                            if (classesNumber) state = MSTE_DECODING_CLASS_NAME ;
                            else state = MSTE_DECODING_KEYS_NUMBER_VALUE ;
                            break ;
                        case MSTE_DECODING_CLASS_NEXT_TOKEN:
                            if (classesNumber > (decodedClasses->size())) state = MSTE_DECODING_CLASS_NAME ;
                            else state = MSTE_DECODING_KEYS_NUMBER_VALUE ;
                            
                            break ;
                        case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN:
                            
                            if (keysNumber) state = MSTE_DECODING_KEY_NAME ;
                            else state = MSTE_DECODING_ROOT_OBJECT ; break ;
                        case MSTE_DECODING_KEY_NEXT_TOKEN:
                      
                            if (keysNumber > decodedKeys->size()) state = MSTE_DECODING_KEY_NAME ;
                            else state = MSTE_DECODING_ROOT_OBJECT ;
                            break ;
                        default:
                           throw "MSTDecodeRetainedObject - state unchanged!!!!" ;
                    }
                    break ;
                }
                case MSTE_DECODING_TOKEN_NUMBER_VALUE : {
                    string tokenNumb = "token number";
                    tokenNumber = MSTDecodeUnsignedLong(&s, end, &tokenNumb) ;
                    state = MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_CRC_START : {
                    if (*s == (unsigned char)'"') { s++ ;  state = MSTE_DECODING_CRC_HEADER ; break ; }
                    throw "MSTDecodeRetainedObject - Bad header format (CRC start)" ;
                }
                case MSTE_DECODING_CRC_HEADER : {
                    if (((end-s) < 3) || (s[0] != (unsigned char)'C') || (s[1] != (unsigned char)'R') || (s[2] != (unsigned char)'C')) { //CRC
                    throw "MSTDecodeRetainedObject - Bad header format (CRC marker)" ; }
                    s += 3 ;
                    state = MSTE_DECODING_CRC_VALUE ;
                    break ;
                }
                case MSTE_DECODING_CRC_VALUE : {
                    
                    short j ;
                    if ((end-s) < 8) {throw "MSTDecodeRetainedObject - Bad header format (CRC value)" ; }
                    crcPtr = s ;
                    for (j=0; j<8; j++) {
                        unsigned short localCRC ;
                        crc[j] = s[j] ;
                        
                        localCRC = hexaCharacterToShortValue((unsigned char)crc[j]) ;
                        crcInt = (crcInt<<4) ;
                        crcInt += (unsigned int)localCRC ;
                    }
                    crc[8] = 0 ; //zero terminated hexa CRC string
                    s += 8 ;
                    state = MSTE_DECODING_CRC_END ;
                    break ;
                }
                case MSTE_DECODING_CRC_END : {
                    if (*s == (unsigned char)'"') { s++ ; state = MSTE_DECODING_CRC_NEXT_TOKEN ; }
                    else throw "MSTDecodeRetainedObject - Bad header format (CRC end)" ;
                    break ;
                }
                case MSTE_DECODING_CLASSES_NUMBER_VALUE : {
                    string classNumber = "classes number";
                    classesNumber=MSTDecodeUnsignedLong(&s, end, &classNumber) ;
                    state = MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_CLASS_NAME : {
                    string cName = "class name";
                    
                    MSTEString* className = MSTDecodeString(&s, end, &cName ) ;
                                                       
                    decodedClasses->push_back(className->getString());
                                                            
                    state = MSTE_DECODING_CLASS_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_KEYS_NUMBER_VALUE : {
                    string keyNumb = "keys number";
                    keysNumber = MSTDecodeUnsignedLong(&s, end, &keyNumb ) ;                   
                    state = MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_KEY_NAME : {
                    string kName = "key name";
                    MSTEString* key = MSTDecodeString(&s, end, &kName) ;
                    
                    decodedKeys->push_back(key->getString()) ;
                    state = MSTE_DECODING_KEY_NEXT_TOKEN ;
                    break ;
                }
                case MSTE_DECODING_ROOT_OBJECT : {                          
                    string root = "root object";                 
                    object = MSTDecodeObject(&s, end, &root, decodedObjects, decodedClasses, decodedKeys, &myTokenCount) ;                    
                    state = MSTE_DECODING_ARRAY_END ;
                    break ;
                }
                case MSTE_DECODING_ARRAY_END : {
                    if (*s != (unsigned char)']') { s++ ; break ; }
                    if (*s == (unsigned char)']') { state = MSTE_DECODING_GLOBAL_END ; break ; }
                    throw "MSTDecodeRetainedObject - Bad format (array end)" ;
                }
                case MSTE_DECODING_GLOBAL_END : {
                    if (*s == (unsigned char)' ') { s++ ; break ; }
                    if (s==end) {
                        if (verifyCRC) {
                            crcPtr[0] = crcPtr[1] = crcPtr[2] = crcPtr[3] = crcPtr[4] = crcPtr[5] = crcPtr[6] = crcPtr[7] = (unsigned char)'0';
                            //if (crcInt != [data longCRC]) throw "MSTDecodeRetainedObject - CRC Verification failed" ;
                        }
                        
                        myTokenCount += 1 ;
                        if (tokenNumber != myTokenCount) throw "MSTDecodeRetainedObject - Wrong token number" ;
                        s++ ;
                        break ;
                    }
                    throw "MSTDecodeRetainedObject - Bad format (character after array end)" ;
                }
                default : {
                    //never go here
                    throw "MSTDecodeRetainedObject - unknown state" ;
                }
            }
        }
        delete decodedObjects;
        delete decodedKeys;
        delete decodedClasses;
        return object ;
    }
    return 0 ;
}
