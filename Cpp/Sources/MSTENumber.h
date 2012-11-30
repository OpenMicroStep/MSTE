//
//  MSTENumber.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;

class MSTEObject ;

class MSTENumber  : public MSTEObject{
    private :
	char charValue;
	unsigned char unsignedCharValue;
	short shortValue;
	unsigned short unsignedShortValue;
    float floatValue;
    unsigned int unsignedIntValue;
    int intValue ;
    long longValue;
    unsigned long unsignedLongValue;
    long long longLongValue;
    unsigned long long unsignedLongLongValue;
    double doubleValue;
    
public:
	MSTENumber();
	MSTENumber(char aChar);
	MSTENumber(unsigned char aUChar);
	MSTENumber(short aShort);
	MSTENumber(unsigned short aUShort);
	MSTENumber(float aFloat);
	MSTENumber(unsigned int aUValue);
	MSTENumber(int aIntValue);
	MSTENumber(long aLongValue);
	MSTENumber(unsigned long aULongValue);
	MSTENumber(long long aLLongValue);
	MSTENumber(unsigned long long aULLongValue);
	MSTENumber(double aDoubleValue);
	virtual ~MSTENumber();
     
	float getFloat();
	unsigned int getUInt();
	signed int getInt();
	char getChar();
	unsigned char getUChar();
	short getShort();
	unsigned short getUShort();
	long getLong();
	unsigned long getULong();
	long long getLongLong();
	unsigned long long getULongLong();
	double getDouble();
    
	unsigned char getSingleEncodingCode();
    unsigned char getTokenType();
    
	string getClassName();
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);
};
