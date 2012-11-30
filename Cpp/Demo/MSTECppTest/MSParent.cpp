//
//  MSParent.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTE.h"

#include <iostream>

MSParent::MSParent(MSTEString* aName, MSTEString* aFirstName, MSTEBool* aSex)
{
    snapshot = new map<string,MSTEObject*>;
    map<string, MSTEObject*>  mamap;
    mamap["name"] = aName;
    mamap["firstname"] = aFirstName;
    mamap["sex"] = aSex;
    //son = new MSSon();
    MSTEDictionary* dico = new MSTEDictionary(&mamap);
    snapshot = dico->getMap();
};

MSParent::MSParent(map<string,MSTEObject*> *aSnapshot) {
    snapshot = aSnapshot;
}

MSParent::~MSParent(){
    delete snapshot;
}

void MSParent::setSon(MSSon *aSon)
{
    snapshot->at("Son")= aSon;
}

string MSParent::getClassName()
{
	return "MSParent";
}

void MSParent::encodeWithMSTEncodeur(MSTEncodeur* e)
{
    
	e->encodeObject(this);
}

unsigned char MSParent::getTokenType()
{
	return MSTE_TOKEN_USER_CLASS_MARKER;
}

unsigned char MSParent::getSingleEncodingCode()
{
    
    return MSTE_TOKEN_MUST_ENCODE;
}

map<string,MSTEObject*>* MSParent::getSnapshot()
{
	return snapshot;
}