//
//  MSTEDictionary.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEPrivate.h"

MSTEDictionary::MSTEDictionary() {
    
}

MSTEDictionary::MSTEDictionary(map<string,MSTEObject*> *aMap)
{
	sOmap = *aMap;
}

MSTEDictionary::MSTEDictionary(MSTEDictionary &dictionary) {
	sOmap = dictionary.sOmap;
    
}

MSTEDictionary::~MSTEDictionary() {
    
}

string MSTEDictionary::getClassName()
{
	return "MSTEDictionary";
}

MSTEObject* MSTEDictionary::getObjectDictionary(string key)
{
	MSTEObject* object = sOmap[key];
	return object;
}

void MSTEDictionary::setObjectDictionary(string key, MSTEObject* object)
{
	sOmap[key] = object;
}

map<string,MSTEObject*>* MSTEDictionary::getMap()
{
	return &sOmap;
}

unsigned char MSTEDictionary::getTokenType()
{
	return MSTE_TOKEN_TYPE_DICTIONARY;
}

unsigned long MSTEDictionary::size()
{
	return sOmap.size();
}

void MSTEDictionary::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeDictionary(this);
}

