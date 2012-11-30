//
//  MSTEBool.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

using namespace std ;

MSTEBool::MSTEBool() {
	// TODO Auto-generated constructor stub
    
}

MSTEBool::MSTEBool(bool tfBool) {
	aBool = tfBool;
    
}

MSTEBool::~MSTEBool() {
	// TODO Auto-generated destructor stub
}

string MSTEBool::getClassName()
{
	return "MSTEBool";
}

bool MSTEBool::getBool()
{
	return aBool;
}
unsigned char MSTEBool::getSingleEncodingCode()
{
	if(aBool==true)	return MSTE_TOKEN_TYPE_TRUE;
	else return MSTE_TOKEN_TYPE_FALSE;
}

unsigned char MSTEBool::getTokenType()
{
	if(aBool==true)	return MSTE_TOKEN_TYPE_TRUE;
	else return MSTE_TOKEN_TYPE_FALSE;
}

void MSTEBool::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeBool(this);
}
