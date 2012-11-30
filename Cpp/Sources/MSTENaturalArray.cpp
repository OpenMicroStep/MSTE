//
//  MSTENaturalArray.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

MSTENaturalArray::MSTENaturalArray() {
    
}

MSTENaturalArray::MSTENaturalArray(vector<int> *vector)
{
	aVector = *vector;
}

MSTENaturalArray::MSTENaturalArray(MSTENaturalArray &array)
{
	aVector = array.aVector;
}

MSTENaturalArray::~MSTENaturalArray() {
	// TODO Auto-generated destructor stub
}


string MSTENaturalArray::getClassName()
{
	return "MSTENaturalArray";
}

int MSTENaturalArray::getIntVector(int idx)
{
	return aVector[idx];
}

unsigned char MSTENaturalArray::getTokenType()
{
	return MSTE_TOKEN_TYPE_NATURAL_ARRAY;
}

void MSTENaturalArray::setIntVector( int value)
{
	aVector.push_back(value);
}

vector<int>* MSTENaturalArray::getVector()
{
	return &aVector;
}

void MSTENaturalArray::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeNaturalArray(this);
}

unsigned long MSTENaturalArray::size()
{
    
    return aVector.size();
	
}