//
//  MSTEArray.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include <vector>

using namespace std;

class MSTEObject ;

class MSTEArray : public MSTEObject{
    private :
	vector<MSTEObject*> aVector;
public:
	MSTEArray();
	MSTEArray(vector<MSTEObject*> *vector);
	MSTEArray(MSTEArray &array);
	virtual ~MSTEArray();
	string getClassName();
	MSTEObject* getObjectVector(int idx);
	unsigned char getTokenType();
	void setObjectVector(MSTEObject* object);
	vector<MSTEObject*> *getVector();
	virtual unsigned long size();
	virtual void encodeWithMSTEncodeur(MSTEncodeur* e);
};

