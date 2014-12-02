//
//  MSTENaturalArray.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTENaturalArray.h"

MSTENaturalArray::MSTENaturalArray()
{
}

MSTENaturalArray::MSTENaturalArray(std::vector<int> *vector)
{
	aVector = *vector;
}

MSTENaturalArray::~MSTENaturalArray()
{

}


int MSTENaturalArray::getIntVector(int idx)
{
	return aVector[idx];
}

std::vector<int>* MSTENaturalArray::getVector()
{
	return &aVector;
}

unsigned long MSTENaturalArray::size()
{
    
    return aVector.size();
    
}

void MSTENaturalArray::addItem(int item)
{
    aVector.push_back(item);
}

void MSTENaturalArray::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeNaturalArray(this, outputBuffer);
}

