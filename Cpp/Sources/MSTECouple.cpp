//
//  MSTECouple.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTECouple.h"
#include <memory>

MSTECouple::MSTECouple()
{
    couple1 = NULL;
    couple2 = NULL;
}

MSTECouple::MSTECouple(std::shared_ptr<MSTEObject> firstMember, std::shared_ptr<MSTEObject> secondMember)
{
	couple1 = firstMember;
	couple2 = secondMember;
    
}

MSTECouple::~MSTECouple()
{
}

std::shared_ptr<MSTEObject> MSTECouple::getFirstMember()
{

    return couple1;
}

std::shared_ptr<MSTEObject> MSTECouple::getSecondMember()
{
    
    return couple2;
}

void MSTECouple::setFirstMember(std::shared_ptr<MSTEObject> item)
{
    couple1 = item;
}

void MSTECouple::setSecondMember(std::shared_ptr<MSTEObject> item)
{
    couple2 = item;
}

void MSTECouple::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeCouple(this, outputBuffer);
}

std::string MSTECouple::getClassName()
{
	return "MSTECouple";
}
