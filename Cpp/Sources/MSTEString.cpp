//
//  MSTEString.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"
#include <iostream>

MSTEString::MSTEString() {
	chaine = "";
    wchaine = L"";
}

MSTEString::MSTEString(string aString)
{
	chaine = aString;
    wchaine = L"";
}

MSTEString::MSTEString(wstring aWString)
{
    chaine = "";
	wchaine = aWString;
}

MSTEString::MSTEString(MSTEString & msteString)
{
	chaine = msteString.chaine;
    wchaine = msteString.wchaine;
}

MSTEString::~MSTEString() {
	// TODO Auto-generated destructor stub
}

string MSTEString::getClassName()
{
	return "MSTEString";
}

string MSTEString::getString()
{
	return chaine;
}

wstring MSTEString::getWString()
{
	return wchaine;
}

unsigned char MSTEString::getTokenType()
{
	return MSTE_TOKEN_TYPE_STRING;
}

unsigned char MSTEString::getSingleEncodingCode()
{
	if(chaine.length()==0)	return MSTE_TOKEN_TYPE_EMPTY_STRING;
	else return MSTE_TOKEN_MUST_ENCODE;
}

unsigned long MSTEString::length()
{
	return chaine.length();
}

unsigned long MSTEString::wlength()
{
	return wchaine.length();
}

void MSTEString::encodeWithMSTEncodeur(MSTEncodeur* e)
{
    if(chaine != "")
    {
        e->encodeString(this);
    }
    else
    {
        e->encodeWString(this);
    }
}