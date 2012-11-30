//
//  MSTEObject.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//



using namespace std;

class MSTEncodeur ;
class MSTEObject ;

class MSTEObject {
private:
	//int tokenType;
	map<string,MSTEObject*> *snapshot;
public:
	MSTEObject();
    MSTEObject(map<string,MSTEObject*> *aSnapshot);
	virtual ~MSTEObject();
	virtual string getClassName();
    virtual map<string,MSTEObject*>* getSnapshot();
    
	virtual unsigned char getTokenType();
	unsigned char getSingleEncodingCode();
    
	virtual void encodeWithMSTEncodeur(MSTEncodeur* e);

    
};

