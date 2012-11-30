//
//  MSTEDictionary.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include <map>
using namespace std;

class MSTEObject ;

class MSTEDictionary  : public MSTEObject{
    private :
	map<string,MSTEObject*> sOmap;
public:
	MSTEDictionary();
	MSTEDictionary(map<string,MSTEObject*> *aMap);
	MSTEDictionary(MSTEDictionary &dictionary);
	virtual ~MSTEDictionary();
	string getClassName();
	MSTEObject* getObjectDictionary(string key);
	void setObjectDictionary(string key, MSTEObject* object);
	map<string,MSTEObject*> *getMap();
	unsigned char getTokenType();
	unsigned long size();
	void encodeWithMSTEncodeur(MSTEncodeur* e);
};

