//
//  MSTENumber.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

MSTENumber::MSTENumber() {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(char aChar) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = aChar;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(unsigned char aUChar) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue = aUChar;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(short aShort) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue = aShort;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(unsigned short aUShort) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue = aUShort;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(float aFloat) {
    floatValue = aFloat;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(unsigned int aUValue) {
    floatValue = 0;
    unsignedIntValue = aUValue;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(int aIntValue) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = aIntValue;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(long aLongValue) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = aLongValue;
    unsignedLongValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(unsigned long aULongValue) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    unsignedLongValue = aULongValue;
    longValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(long long aLLongValue) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    longValue = 0;
    unsignedLongValue = 0;
    longLongValue = aLLongValue;
    unsignedLongLongValue = 0;
    doubleValue = 0;
}

MSTENumber::MSTENumber(unsigned long long aULLongValue) {
	floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    unsignedLongValue = 0;
    longValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = aULLongValue;
    doubleValue = 0;
}

MSTENumber::MSTENumber(double aDoubleValue) {
    floatValue = 0;
    unsignedIntValue = 0;
    intValue = 0;
    charValue = 0;
    unsignedCharValue= 0;
    shortValue =0;
    unsignedShortValue =0;
    unsignedLongValue = 0;
    longValue = 0;
    longLongValue = 0;
    unsignedLongLongValue = 0;
    doubleValue = aDoubleValue;
}

MSTENumber::~MSTENumber() {
	// TODO Auto-generated destructor stub
}

string MSTENumber::getClassName()
{
	return "MSTENumber";
}

float MSTENumber::getFloat()
{
	return floatValue;
}

unsigned int MSTENumber::getUInt()
{
	return unsignedIntValue;
}

int MSTENumber::getInt()
{
	return intValue;
}

char MSTENumber::getChar()
{
	return charValue;
}

unsigned char MSTENumber::getUChar()
{
	return unsignedCharValue;
}

short MSTENumber::getShort()
{
	return shortValue;
}

unsigned short MSTENumber::getUShort()
{
	return unsignedShortValue;
}

long MSTENumber::getLong()
{
	return longValue;
}

unsigned long MSTENumber::getULong()
{
	return unsignedLongValue;
}

long long MSTENumber::getLongLong()
{
	return longLongValue;
}

unsigned long long MSTENumber::getULongLong()
{
	return unsignedLongLongValue;
}

double MSTENumber::getDouble()
{
	return doubleValue;
}

unsigned char MSTENumber::getSingleEncodingCode()
{
    if(charValue !=0)
    {
        return MSTE_TOKEN_TYPE_CHAR;
    }
    if(unsignedCharValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_CHAR;
    }
    if(shortValue !=0)
    {
        return MSTE_TOKEN_TYPE_SHORT;
    }
    if(unsignedShortValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_SHORT;
    }
    if(intValue != 0 )
    {
        return MSTE_TOKEN_TYPE_INT32;
    }
    if(unsignedIntValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_INT32;
    }
    if(longValue !=0)
    {
        return MSTE_TOKEN_TYPE_INT64;
    }
    if(unsignedLongValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_INT64;
    }
    if(longLongValue !=0)
    {
        return MSTE_TOKEN_TYPE_INT64;
    }
    if(unsignedLongLongValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_INT64;
    }
    if(floatValue !=0)
    {
        return MSTE_TOKEN_TYPE_FLOAT;
    }
    if(doubleValue!=0)
    {
        return MSTE_TOKEN_TYPE_DOUBLE;
    }
    return 0;
    
}

unsigned char MSTENumber::getTokenType()
{
    if(charValue !=0)
    {
        return MSTE_TOKEN_TYPE_CHAR;
    }
    if(unsignedCharValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_CHAR;
    }
    if(shortValue !=0)
    {
        return MSTE_TOKEN_TYPE_SHORT;
    }
    if(unsignedShortValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_SHORT;
    }
    if(intValue != 0 )
    {
        return MSTE_TOKEN_TYPE_INT32;
    }
    if(unsignedIntValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_INT32;
    }
    if(longValue !=0)
    {
        return MSTE_TOKEN_TYPE_INT64;
    }
    if(unsignedLongValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_INT64;
    }
    if(longLongValue !=0)
    {
        return MSTE_TOKEN_TYPE_INT64;
    }
    if(unsignedLongLongValue !=0)
    {
        return MSTE_TOKEN_TYPE_UNSIGNED_INT64;
    }
    if(floatValue !=0)
    {
        return MSTE_TOKEN_TYPE_FLOAT;
    }
    if(doubleValue!=0)
    {
        return MSTE_TOKEN_TYPE_DOUBLE;
    }
    return 0;
    
}

void MSTENumber::encodeWithMSTEncodeur(MSTEncodeur* e)
{
    
	if(charValue !=0)
	{
		e->encodeChar(charValue);
	}
	if(unsignedCharValue !=0)
	{
		e->encodeUChar(unsignedCharValue);
	}
	if(shortValue !=0)
	{
		e->encodeShort(shortValue);
	}
	if(unsignedShortValue !=0)
	{
		e->encodeUShort(unsignedShortValue);
	}
	if(intValue != 0 )
	{
		e->encodeInt(intValue);
	}
	if(unsignedIntValue !=0)
	{
		e->encodeUInt(unsignedIntValue);
	}
	if(longValue !=0)
	{
		e->encodeLong(longValue);
	}
	if(unsignedLongValue !=0)
	{
		e->encodeULong(unsignedLongValue);
	}
	if(longLongValue !=0)
	{
		e->encodeLongLong(longLongValue);
	}
	if(unsignedLongLongValue !=0)
	{
		e->encodeULongLong(unsignedLongLongValue);
	}
	if(floatValue !=0)
	{
		e->encodeFloat(floatValue);
	}
	if(doubleValue!=0)
	{
		e->encodeDouble(doubleValue);
	}
    
    
}
