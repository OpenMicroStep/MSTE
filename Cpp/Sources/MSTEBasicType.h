//
//  MSTEChar.h
//  MSTECppTest
//
//  Created by Julien PAPILLON on 20/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#ifndef _MSTE_BASIC_TYPE_H
#define _MSTE_BASIC_TYPE_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncodeur.h"

class MSTEBasicType : public MSTEObject
{
public:
    // Constructors
    MSTEBasicType(char);
    MSTEBasicType(unsigned char);
    MSTEBasicType(short);
    MSTEBasicType(unsigned short);
    MSTEBasicType(int);
    MSTEBasicType(unsigned int);
    MSTEBasicType(long);
    MSTEBasicType(unsigned long);
    MSTEBasicType(long long);
    MSTEBasicType(unsigned long long);
    MSTEBasicType(float);
    MSTEBasicType(double);
    
    // Destructors
    virtual ~MSTEBasicType();
    
    // Getters
    char getChar();
    unsigned char getUnsignedChar();
    short getShort();
    unsigned short getUnsignedShort();
    int getInt32();
    unsigned int getUnsignedInt32();
    long long getInt64();
    unsigned long long getUnsignedInt64();
    float getFloat();
    double getDouble();
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

private:
    char charValue;
    unsigned char unsignedCharValue;
    short shortValue;
    unsigned short unsignedShortValue;
    int int32Value;
    unsigned int unsignedInt32Value;
    long long int64Value;
    unsigned long long unsignedInt64Value;
    float floatValue;
    double doubleValue;
    
    char valueType;
};

#endif // _MSTE_CHAR_H
