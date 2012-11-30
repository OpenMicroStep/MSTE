//
//  MSTETest.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 24/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//


#include "MSTE.h"

#include <iostream>

MSTETest::MSTETest() {
    snapshot = new map<string,MSTEObject*>;
    map<string, MSTEObject*>  mamap;
    char *prenom = "mélodie";
    
    MSTEString* nameFather = new MSTEString("robert");
    MSTEString* firstnameFather = new MSTEString("lucien");
    MSTEString* nameMother = new MSTEString("martin");
    MSTEString* firstnameMother = new MSTEString("juliette");
    MSTEString* firstnameSon = new MSTEString("lulu");
    MSTEBool* male = new MSTEBool(true);
    MSTEBool* female = new MSTEBool(false);    
    MSParent* pere = new MSParent(firstnameFather,nameFather,male);
    MSParent* mere = new MSParent(firstnameMother,nameMother,female);
    MSSon* fils = new MSSon(mere, pere,firstnameSon);

    
    MSTEDate* date = new MSTEDate(1);
    MSTEData* data = new MSTEData(prenom);
    MSTEColor* colo = new MSTEColor((float)0,(float)0,(float)255);
    MSTEString* strin = new MSTEString(L"àéèçôâ");
    MSTENumber* aNumber2 = new MSTENumber(12);    
    MSTEBool* aBool = new MSTEBool(true);
    
    vector<MSTEObject*> vec;
    vec.push_back(aNumber2);
    vec.push_back(aBool);
    vec.push_back(colo);
    
    vector<MSTEObject*> vecteur;
    vecteur.push_back(colo);
    vecteur.push_back(pere);
    vecteur.push_back(mere);

    vector<int> vect;
    vect.push_back(72);
    vect.push_back(3);
    
    MSTEArray* Array = new MSTEArray(&vec);
    MSTENaturalArray* NatArray = new MSTENaturalArray(&vect);
    MSTEArray* Arrayy = new MSTEArray(&vecteur);
    MSTECouple* wcouple = new MSTECouple(aBool,strin);

    
    mamap["string"] = strin;
    mamap["array"] = Array;
    mamap["array2"] = Arrayy;
    mamap["couple"] = wcouple;
    mamap["natArray"] = NatArray;
    mamap["data"] = data;
    mamap["date"] = date;
    mamap["pere"] = pere;
    mamap["mere"] = mere;
    mamap["fils"] = fils;
    MSTEDictionary* dico = new MSTEDictionary(&mamap);
    snapshot = dico->getMap();

}

MSTETest::MSTETest(map<string,MSTEObject*> *aSnapshot) {
    snapshot = aSnapshot;
}

MSTETest::~MSTETest() {
	// TODO Auto-generated destructor stub
    delete snapshot;
}

string MSTETest::getClassName()
{
	return "MSTETest";
}

map<string,MSTEObject*>* MSTETest::getSnapshot()
{
	return snapshot;
}

void MSTETest::encodeWithMSTEncodeur(MSTEncodeur* e)
{    
	e->encodeRootObject(this);
}

unsigned char MSTETest::getTokenType()
{
	return MSTE_TOKEN_USER_CLASS_MARKER;
}


