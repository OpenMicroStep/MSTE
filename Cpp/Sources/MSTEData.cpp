//
//  MSTEData.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"
#include<iostream>

MSTEData::MSTEData() {
	data = 0;
}

MSTEData::MSTEData(char* aData)
{
	data = aData;
}

MSTEData::MSTEData(MSTEData & msteData)
{
	data = msteData.data;
}

MSTEData::~MSTEData() {
    
}

string MSTEData::getClassName()
{
	return "MSTEData";
}

char* MSTEData::getData()
{
	return data;
}

unsigned char MSTEData::getTokenType()
{
	return MSTE_TOKEN_TYPE_BASE64_DATA;
}


void MSTEData::encodeWithMSTEncodeur(MSTEncodeur* e)
{
    e->encodeBase64(this);
}