//
//  MSTEObject.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"
#include <iostream>

MSTEObject::MSTEObject() {
    snapshot = new map<string,MSTEObject*>;
}

MSTEObject::MSTEObject(map<string,MSTEObject*> *aSnapshot) {
    snapshot = aSnapshot;
}

MSTEObject::~MSTEObject() {
	// TODO Auto-generated destructor stub
    delete snapshot;
}

string MSTEObject::getClassName()
{
    return "MSTEObject";
}

unsigned char MSTEObject::getTokenType()
{
	return MSTE_TOKEN_USER_CLASS_MARKER;
}

map<string,MSTEObject*>* MSTEObject::getSnapshot()
{
    return snapshot;
}

void MSTEObject::encodeWithMSTEncodeur(MSTEncodeur* e)
{
    //e->encodeObject(this);
    throw "objet non encodable";
}


unsigned char MSTEObject::getSingleEncodingCode()
{
	return MSTE_TOKEN_MUST_ENCODE;
}
