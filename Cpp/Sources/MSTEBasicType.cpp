//
//  MSTEChar.cpp
//  MSTECppTest
//
//  Created by Julien PAPILLON on 20/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#include "MSTEBasicType.h"

MSTEBasicType::MSTEBasicType(char value)
{
    valueType = MSTE_TYPE_CHAR;
    charValue = value;
}

MSTEBasicType::MSTEBasicType(unsigned char value)
{
    valueType = MSTE_TYPE_UNSIGNED_CHAR;
    unsignedCharValue = value;
}

MSTEBasicType::MSTEBasicType(short value)
{
    valueType = MSTE_TYPE_SHORT;
    shortValue = value;
}

MSTEBasicType::MSTEBasicType(unsigned short value)
{
    valueType = MSTE_TYPE_UNSIGNED_SHORT;
    unsignedShortValue = value;
}

MSTEBasicType::MSTEBasicType(int value)
{
    valueType = MSTE_TYPE_INT32;
    int32Value = value;
}

MSTEBasicType::MSTEBasicType(unsigned int value)
{
    valueType = MSTE_TYPE_UNSIGNED_INT32;
    unsignedInt32Value = value;
}

MSTEBasicType::MSTEBasicType(long value)
{
    valueType = MSTE_TYPE_INT64;
    int64Value = value;
}

MSTEBasicType::MSTEBasicType(unsigned long value)
{
    valueType = MSTE_TYPE_UNSIGNED_INT64;
    unsignedInt64Value = value;
}

MSTEBasicType::MSTEBasicType(long long value)
{
    valueType = MSTE_TYPE_INT64;
    int64Value = value;
}

MSTEBasicType::MSTEBasicType(unsigned long long value)
{
    valueType = MSTE_TYPE_UNSIGNED_INT64;
    unsignedInt64Value = value;
}

MSTEBasicType::MSTEBasicType(float value)
{
    valueType = MSTE_TYPE_FLOAT;
    floatValue = value;
}

MSTEBasicType::MSTEBasicType(double value)
{
    valueType = MSTE_TYPE_DOUBLE;
    doubleValue = value;
}

MSTEBasicType::~MSTEBasicType()
{
    
}

// Getters
char MSTEBasicType::getChar()
{
    return charValue;
}

unsigned char MSTEBasicType::getUnsignedChar()
{
    return unsignedCharValue;
}

short MSTEBasicType::getShort()
{
    return shortValue;
}

unsigned short MSTEBasicType::getUnsignedShort()
{
    return unsignedShortValue;
}

int MSTEBasicType::getInt32()
{
    return int32Value;
}

unsigned int MSTEBasicType::getUnsignedInt32()
{
    return unsignedInt32Value;
}

long long MSTEBasicType::getInt64()
{
    return int64Value;
}

unsigned long long MSTEBasicType::getUnsignedInt64()
{
    return unsignedInt64Value;
}

float MSTEBasicType::getFloat()
{
    return floatValue;
}

double MSTEBasicType::getDouble()
{
    return doubleValue;
}

// Methods
void MSTEBasicType::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    switch (valueType) {
        case MSTE_TYPE_CHAR:
            e->encodeChar(this, outputBuffer);
        case MSTE_TYPE_UNSIGNED_CHAR:
            e->encodeUnsignedChar(this, outputBuffer);
        case MSTE_TYPE_SHORT:
            e->encodeShort(this, outputBuffer);
        case MSTE_TYPE_UNSIGNED_SHORT:
            e->encodeUnsignedShort(this, outputBuffer);
        case MSTE_TYPE_INT32:
            e->encodeInt32(this, outputBuffer);
        case MSTE_TYPE_UNSIGNED_INT32:
            e->encodeUnsignedInt32(this, outputBuffer);
        case MSTE_TYPE_INT64:
            e->encodeInt64(this, outputBuffer);
        case MSTE_TYPE_UNSIGNED_INT64:
            e->encodeUnsignedInt64(this, outputBuffer);
        case MSTE_TYPE_FLOAT:
            e->encodeFloat(this, outputBuffer);
        case MSTE_TYPE_DOUBLE:
            e->encodeDouble(this, outputBuffer);
        default:
            throw "Unknown type";
            break;
    }
}

std::string MSTEBasicType::getClassName()
{
	return "MSTEBasicType";
}
