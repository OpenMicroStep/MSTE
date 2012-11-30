//
//  MSTEncodeur.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

#include <iostream>

static const char *hexa = "0123456789ABCDEF" ;

MSTEncodeur::MSTEncodeur() {
	tokenCount = 0;
	lastKeyIndex=0;
	lastClassIndex = 0;
	lastReference = 0;
    
}

MSTEncodeur::~MSTEncodeur() {
	// TODO Auto-generated destructor stub
}

void MSTEncodeur::encodeTokenSeparator()
{
	ss<<",";
	tokenCount++;
}

void MSTEncodeur::encodeBool(MSTEBool* o)
{
	encodeTokenSeparator();
	if(o->getBool()==true) ss<< MSTE_TOKEN_TYPE_TRUE;
	if(o->getBool()==false) ss<< MSTE_TOKEN_TYPE_FALSE ;
}


void MSTEncodeur::encodeInt(int o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_INT32;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeUInt(unsigned int o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_UNSIGNED_INT32  ;
	encodeTokenSeparator();
	ss << o;
}


void MSTEncodeur::encodeChar(char o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_CHAR ;
	encodeTokenSeparator();
	ss << o;
}


void MSTEncodeur::encodeUChar(unsigned char o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_UNSIGNED_CHAR ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeShort(short o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_SHORT ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeUShort(unsigned short o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_UNSIGNED_SHORT ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeLong(long o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_INT64 ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeULong(unsigned long o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_UNSIGNED_INT64  ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeLongLong(long long o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_INT64  ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeULongLong(unsigned long long o)
{
	//encodeTokenSeparator();
	//ss<<MSTE_TOKEN_TYPE_UNSIGNED_INT64  ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeGlobalULongLong(unsigned long long o)
{
	//ssGlobal<<MSTE_TOKEN_TYPE_UNSIGNED_INT64  ;
	//ssGlobal << ",";
	ssGlobal << o;
}

void MSTEncodeur::encodeFloat(float o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_FLOAT  ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeDouble(double o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_DOUBLE  ;
	encodeTokenSeparator();
	ss << o;
}

void MSTEncodeur::encodeDate(MSTEDate* o)
{
    
    if ((o->getDate()) >= o->getDistantFuture())
     {
         encodeDistantFuture(o);
     }
    if ((o->getDate())<= o->getDistantPast())
     {
         encodeDistantPast(o);
     }
	if(((o->getDate()) > o->getDistantPast()) && ((o->getDate()) < o->getDistantFuture()))
	{
		encodeTokenSeparator();
		ss<<MSTE_TOKEN_TYPE_DATE  ;
		encodeTokenSeparator();       
		ss << o->getSecondSince1970();        
	}
}

void MSTEncodeur::encodeDistantPast(MSTEDate* o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_DISTANT_PAST  ;
}

void MSTEncodeur::encodeDistantFuture(MSTEDate* o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_DISTANT_FUTURE  ;
}

void MSTEncodeur::encodeBase64(MSTEData* o)
{
    char const* bytes_to_encode = o->getData();
    
    unsigned long in_len = strlen(bytes_to_encode);
	string ret;
    int i = 0;
    int j = 0;
    unsigned char char_array_3[3];
    unsigned char char_array_4[4];
    
    while (in_len--) {
	    char_array_3[i++] = *(bytes_to_encode++);
	    if (i == 3) {
            char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
            char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
            char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
            char_array_4[3] = char_array_3[2] & 0x3f;
            
            for(i = 0; (i <4) ; i++)
                ret += base64_chars[char_array_4[i]];
            i = 0;
	    }
    }
    
    if (i)
    {
	    for(j = i; j < 3; j++)
            char_array_3[j] = '\0';
        
	    char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
	    char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
	    char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
	    char_array_4[3] = char_array_3[2] & 0x3f;
        
	    for (j = 0; (j < i + 1); j++)
            ret += base64_chars[char_array_4[j]];
        
	    while((i++ < 3))
            ret += '=';
        
    }
    encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_BASE64_DATA  ;
    encodeTokenSeparator();
    ss<<"\"";
    ss<<ret;
    ss<<"\"";
}

void MSTEncodeur::encodeWString(MSTEString* o)
{
	unsigned long len = o->wlength(); 
    int i;

    if(len==0) {
		encodeTokenSeparator();
		ss<<MSTE_TOKEN_TYPE_EMPTY_STRING;
		//throw "encodeString:withTokenType: no string to encode!";
	}
	else{
		encodeTokenSeparator();
		ss<<MSTE_TOKEN_TYPE_STRING;
		encodeTokenSeparator();
		ss<<"\"";
        for (i=0 ; i<len ; i++) {
            unsigned char c = o->getWString().at(i);

            switch(c){
                case 9 : { // \t
                    ss<<"\\";
                    ss<<"t";
                    break ;
                }
                case 10 : { // \n
                    ss<<"\\";
                    ss<<"n";
                    break ;
                }
                case 13 : { // \r
                    ss<<"\\";
                    ss<<"r";
                    break ;
                }
                case 34 : { // \"
                    ss<<"\\";
                    ss<<"\"";
                    break ;
                }
                case 92 : { // antislash
                    ss<<"\\";
                    ss<<"\\";
                    break ;
                }
                case 47 : { // antislash
                    ss<<"\\";
                    ss<<"/";
                    break ;
                }
                case 8 : { // antislash
                    ss<<"\\";
                    ss<<"b";
                    break ;
                }
                case 12 : { // antislash
                    ss<<"\\";
                    ss<<"f";
                    break ;
                }
                    
                default: {
                    if ((c < 32) || (c > 127)) { //escape non printable ASCII characters with a 4 characters in UTF16 hexadecimal format (\UXXXX)
                        
                        char16_t b0 = (char16_t)((c & 0xF000)>>12);
                        char16_t b1 = (char16_t)((c & 0x0F00)>>8);
                        char16_t b2 = (char16_t)((c & 0x00F0)>>4);
                        char16_t b3 = (char16_t)(c & 0x000F);
                        
                        ss<<"\\";
                        ss<<"u";
                        ss<<shortValueToHexaCharacter(b0);
                        ss<<shortValueToHexaCharacter(b1);
                        ss<<shortValueToHexaCharacter(b2);
                        ss<<shortValueToHexaCharacter(b3);

                        break;
                       
                        
                    }
                    else{
                        
                        ss<<c;
                    }
                    break ;
                }
                    
            }
        }
        
		ss<<"\"";
	}
    
}

void MSTEncodeur::encodeString(MSTEString* o)
{
	unsigned long len = o->length();
	int i;
    
	if(len==0) {
		encodeTokenSeparator();
		ss<<MSTE_TOKEN_TYPE_EMPTY_STRING;
		//throw "encodeString:withTokenType: no string to encode!";
	}
	else{
		encodeTokenSeparator();
		ss<<MSTE_TOKEN_TYPE_STRING;
		encodeTokenSeparator();
		ss<<"\"";
        for (i=0 ; i<len ; i++) {
            unsigned char c = o->getString().at(i);
                        
            switch(c){
                case 9 : { // \t
                    ss<<"\\";
                    ss<<"t";
                    break ;
                }
                case 10 : { // \n
                    ss<<"\\";
                    ss<<"n";
                    break ;
                }
                case 13 : { // \r
                    ss<<"\\";
                    ss<<"r";
                    break ;
                }
                case 34 : { // \"
                    ss<<"\\";
                    ss<<"\"";
                    break ;
                }
                case 92 : { // antislash
                    ss<<"\\";
                    ss<<"\\";
                    break ;
                }
                case 47 : { // antislash
                    ss<<"\\";
                    ss<<"/";
                    break ;
                }
                case 8 : { // antislash
                    ss<<"\\";
                    ss<<"b";
                    break ;
                }
                case 12 : { // antislash
                    ss<<"\\";
                    ss<<"f";
                    break ;
                }
                default: {
                    ss<<c;
                    break ;
                }
                    
            }
        }
        
		ss<<"\"";
	}
    
}


void MSTEncodeur::encodeGlobalUnicodeString(string o)
{
	unsigned long len = o.length();
	int i;
	if(len==0) {
		ssGlobal<<",";
		ssGlobal<<MSTE_TOKEN_TYPE_EMPTY_STRING;
	}
	else{
		ssGlobal<<",";
		ssGlobal<<"\"";
        for (i=0 ; i<len ; i++) {
            unsigned char c = o.at(i);
            switch(c){
                case 9 : { // \t
                    ssGlobal<<"\\";
                    ssGlobal<<"t";
                    break ;
                }
                case 10 : { // \n
                    ssGlobal<<"\\";
                    ssGlobal<<"n";
                    break ;
                }
                case 13 : { // \r
                    ssGlobal<<"\\";
                    ssGlobal<<"r";
                    break ;
                }
                case 34 : { // \"
                    ssGlobal<<"\\";
                    ssGlobal<<"\"";
                    break ;
                }
                case 92 : { // antislash
                    ssGlobal<<"\\";
                    ssGlobal<<"\\";
                    break ;
                }
                case 47 : { // antislash
                    ssGlobal<<"\\";
                    ssGlobal<<"/";
                    break ;
                }
                case 8 : { // antislash
                    ssGlobal<<"\\";
                    ssGlobal<<"b";
                    break ;
                }
                case 12 : { // antislash
                    ssGlobal<<"\\";
                    ssGlobal<<"f";
                    break ;
                }
                default: {
                    
                    ssGlobal<<c;
                    break ;
                }
                    
            }
        }
        
        ssGlobal<<"\"";
	}
    
}

unsigned char MSTEncodeur::shortValueToHexaCharacter(char16_t o)
{
    if (o < 16)
    {
         return hexa[o] ;
    }
    throw "ShortValueToHexaCharacter - not an hexadecimal value ";
    return 0 ;
}


void MSTEncodeur::encodeDictionary(MSTEDictionary* o)
{
	unsigned long len =  o->size();
	int keyReference;
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_DICTIONARY;
	//encodeTokenSeparator();
	encodeULongLong(len);
    
	map<string, MSTEObject*>::iterator iter;
    
	for (iter = o->getMap()->begin(); iter != o->getMap()->end(); iter++)
	{
		MSTEObject* object ;
		object = iter->second;
		string key = (*iter).first;
        
    	keyReference = keys[key];
	    if(keyReference==0)
	    {
	    	keyReference = ++lastKeyIndex;
	    	keys[key]=keyReference;
	    	keysArray.push_back(key);
	    }
        
		encodeULongLong(keyReference-1);
		encodeObject(object);
	}
    
}

void MSTEncodeur::encodeRootDictionary(MSTEDictionary* o)
{
	unsigned long len =  o->size();
	int keyReference;
	//encodeTokenSeparator();
	//ss<<MSTE_TOKEN_TYPE_DICTIONARY;
	//encodeTokenSeparator();
	encodeULongLong(len);
    
	map<string, MSTEObject*>::iterator iter;
    
	for (iter = o->getMap()->begin(); iter != o->getMap()->end(); iter++)
	{
		MSTEObject* object ;
		object = iter->second;
		string key = (*iter).first;
        
    	keyReference = keys[key];
	    if(keyReference==0)
	    {
	    	keyReference = ++lastKeyIndex;
	    	keys[key]=keyReference;
	    	keysArray.push_back(key);
            
	    }
        
		encodeULongLong(keyReference-1);
		encodeObject(object);
	}
    
}

void MSTEncodeur::encodeArray(MSTEArray* o)
{
	MSTEObject* object;
	int len = (int) o->size();
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_ARRAY;
	//encodeTokenSeparator();
	encodeULongLong(len);
    
	for(int i=0;i<len;i++)
	{
        object= o->getObjectVector(i);
        encodeObject(object);
	}
}

void MSTEncodeur::encodeNaturalArray(MSTENaturalArray* o)
{
	int ret;
	int len = (int) o->size();
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_NATURAL_ARRAY;
	//encodeTokenSeparator();
	encodeULongLong(len);
    
	for(int i=0;i<len;i++)
	{
        ret= o->getIntVector(i);
        encodeTokenSeparator();
        ss<<ret;
	}
}

void MSTEncodeur::encodeCouple(MSTECouple* o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_COUPLE;
	//encodeTokenSeparator();
    MSTEObject* firstMember = o->getFirstMember();
    MSTEObject* secondMember = o->getSecondMember();
	encodeObject(firstMember);
    //encodeTokenSeparator();
	encodeObject(secondMember);    
}



void MSTEncodeur::encodeColor(MSTEColor* o)
{
	encodeTokenSeparator();
	ss<<MSTE_TOKEN_TYPE_COLOR;
	//encodeTokenSeparator();
	encodeULongLong(o->rgba());
}


void MSTEncodeur::encodeObject(MSTEObject* o)
{
	int objectReference;
	string nomClasse = o->getClassName();
    
   
	unsigned char singleToken = o->getSingleEncodingCode();
    if (singleToken != MSTE_TOKEN_MUST_ENCODE)
    {
        
        encodeTokenSeparator();
        ss<<singleToken;
    }
    else
    {
        objectReference = encodedObject[o];

        if(objectReference != 0)
        {
            encodeTokenSeparator();
            ss<<MSTE_TOKEN_TYPE_REFERENCED_OBJECT;
            encodeTokenSeparator();
            ss<<(objectReference-1);
         }
        else
        {
            unsigned char tokenType = o->getTokenType();
            
            if (tokenType == MSTE_TOKEN_USER_CLASS_MARKER)
            {
                MSTEDictionary *snapshot = new MSTEDictionary(o->getSnapshot());
                
                if (!snapshot) throw "encodeObject: Specific user classes must implement MSTESnapshot to be encoded as a dictionary!";
                int classIndex = classes[nomClasse];
                if(classIndex==0)
                {
                    classIndex = ++lastClassIndex;
                    //classes.insert(pair<string, int> (nomClasse,classIndex));
                    
                    classes[nomClasse]=classIndex;
                    classesArray.push_back(nomClasse);
                    
          
                }
                objectReference = ++lastReference;
                encodedObject[o] = objectReference;
                
                encodeTokenSeparator();
                ss<< (classIndex + MSTE_TOKEN_TYPE_USER_CLASS - 1);
                encodeRootDictionary(snapshot);
            }
            else if (tokenType < MSTE_TOKEN_TYPE_USER_CLASS )
            {
                objectReference = ++lastReference;
                encodedObject[o] = objectReference;
                //encodeTokenSeparator();
                //ss<<tokenType;
                o->encodeWithMSTEncodeur(this);
            }
        }
    }
}



void MSTEncodeur::encodeRootObject(MSTEObject* o)
{
    //unsigned int *crcPointer ;
   
	encodeObject(o);
    unsigned long lenClassesArray = classesArray.size();
	unsigned long lenKeysArray = keysArray.size();
    ssGlobal<<"[\"MSTE0101\",";
	unsigned long long ull = (5+lastKeyIndex+lastClassIndex+tokenCount);
    
	encodeGlobalULongLong(ull);
	ssGlobal<<",\"CRC";
    
	ssGlobal<<"00000000\",";
    
	ssGlobal<<lenClassesArray;
    
	for(int i=0;i<lenClassesArray;i++)
	{
		encodeGlobalUnicodeString(classesArray[i]);
	}
	ssGlobal<<",";
	ssGlobal<<lenKeysArray;
    
	for(int j=0;j<lenKeysArray;j++)
	{
		encodeGlobalUnicodeString(keysArray[j]);
	}
    
	encodeFinChaine();
	ssStreamString = ss.str();
	ssGlobalString = ssGlobal.str();
	ssRes = ssGlobalString+ ssStreamString;
    //return ssRes;
    cout<<ssRes;
    
}


void MSTEncodeur::encodeFinChaine()
{
	ss<< "]";
}

void MSTEncodeur::clean()
{
	ss.clear();
	tokenCount =0;
	lastKeyIndex = 0;
}
