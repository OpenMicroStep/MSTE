//
//  MSTECouple.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

MSTECouple::MSTECouple()
{
	couple1 = new MSTEObject();
	couple2 = new MSTEObject();
    
}

MSTECouple::MSTECouple(MSTEObject* firstMember,MSTEObject* secondMember)
{
	couple1 = firstMember;
	couple2 = secondMember;
    
}

MSTECouple::MSTECouple(MSTECouple &aCouple)
{
	couple1 = aCouple.couple1;
    couple2 = aCouple.couple2;
}

MSTECouple::~MSTECouple(){
    delete couple1;
    delete couple2;
}


string MSTECouple::getClassName()
{
	return "MSTECouple";
}

unsigned char MSTECouple::getTokenType()
{
	return MSTE_TOKEN_TYPE_COUPLE;
}


MSTEObject* MSTECouple::getFirstMember()
{

    return couple1;

}

MSTEObject* MSTECouple::getSecondMember()
{
    
    return couple2;
    
}

void MSTECouple::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeCouple(this);
}
