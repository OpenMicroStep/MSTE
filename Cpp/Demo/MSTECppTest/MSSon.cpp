//
//  MSSon.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTE.h"


//#include "MSSon.h"

MSSon::MSSon(MSParent* aMother, MSParent* aFather, MSTEString* aFirstname)
{
    snapshot = new map<string,MSTEObject*>;
    map<string, MSTEObject*>  mamap;
    mamap["pere"] = aMother;
    mamap["mere"] = aFather;
    mamap["firstname"] = aFirstname;

    MSTEDictionary* dico = new MSTEDictionary(&mamap);
    snapshot = dico->getMap();

}

MSSon::MSSon(map<string,MSTEObject*> *aSnapshot) {
    snapshot = aSnapshot;
}

MSSon::~MSSon(){
    delete snapshot;
}

string MSSon::getClassName()
{
	return "MSSon";
}


void MSSon::encodeWithMSTEncodeur(MSTEncodeur* e)
{
	e->encodeObject(this);
}