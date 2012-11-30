//
//  MSTEArray.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"
#include <iostream>

MSTEArray::MSTEArray() {
}

MSTEArray::MSTEArray(vector<MSTEObject*> *vector)
{
	aVector = *vector;
}

MSTEArray::MSTEArray(MSTEArray &array)
{
	aVector = array.aVector;
}

MSTEArray::~MSTEArray()
{
    
}

string MSTEArray::getClassName()
{
	return "MSTEArray";
}

MSTEObject* MSTEArray::getObjectVector(int idx)
{
	return aVector[idx];
}

unsigned char MSTEArray::getTokenType()
{
	return MSTE_TOKEN_TYPE_ARRAY;
}

void MSTEArray::setObjectVector(MSTEObject* object)
{
	aVector.push_back(object);
}

vector<MSTEObject*>* MSTEArray::getVector()
{
	return &aVector;
}


unsigned long MSTEArray::size()
{

    return aVector.size();
	
}

void MSTEArray::encodeWithMSTEncodeur(MSTEncodeur* e)
{
    
	e->encodeArray(this);
}