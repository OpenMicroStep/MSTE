//
//  MSTEArray.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEArray.h"
#include <memory>

MSTEArray::MSTEArray()
{
}

MSTEArray::MSTEArray(std::vector<std::shared_ptr<MSTEObject>> vector)
{
	aVector = vector;
}

MSTEArray::~MSTEArray()
{
    
}

std::shared_ptr<MSTEObject> MSTEArray::getObjectVector(int idx)
{
	return aVector[idx];
}

void MSTEArray::setObjectVector(std::shared_ptr<MSTEObject> object)
{
	aVector.push_back(object);
}

std::vector<std::shared_ptr<MSTEObject>> MSTEArray::getVector()
{
	return aVector;
}

unsigned long MSTEArray::size()
{
    return aVector.size();
}

void MSTEArray::addItem(std::shared_ptr<MSTEObject> item)
{
    aVector.push_back(item);
}

void MSTEArray::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeArray(this, outputBuffer);
}
