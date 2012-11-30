//
//  MSPerson.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//


#include "MSTE.h"

#include <iostream>

MSPerson::MSPerson()
{
    snapshot = new map<string,MSTEObject*>();
}
/*MSPerson::MSPerson(MSTEString* aName, MSTEString* aFirstName, bool aSex)
{
    name = aName;
    firstname = aFirstName;
    sex= aSex;
    
}*/

MSPerson::MSPerson(map<string,MSTEObject*> *aSnapshot) {
    snapshot = aSnapshot;
}

MSPerson::~MSPerson(){
    delete snapshot;
}

string MSPerson::getClassName()
{
    
	return "MSPerson";
}


void MSPerson::encodeWithMSTEncodeur(MSTEncodeur* e)
{
   
	e->encodeObject(this);
}

unsigned char MSPerson::getTokenType()
{
	return MSTE_TOKEN_USER_CLASS_MARKER;
}

unsigned char MSPerson::getSingleEncodingCode()
{

	 return MSTE_TOKEN_MUST_ENCODE;
}

map<string,MSTEObject*>* MSPerson::getSnapshot()
{
	return snapshot;
}