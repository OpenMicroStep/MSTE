//
//  MSParent.h
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//



using namespace std;
#define MALE   false
#define FEMALE true

class MSPerson ;
class MSTEObject;
class MSSon;

class MSParent : public MSPerson {
private:
	
    map<string,MSTEObject*> * snapshot;
	
public:
	MSParent(MSTEString* aName, MSTEString* aFirstName, MSTEBool* aSex);
    MSParent(map<string,MSTEObject*> *aSnapshot);
    virtual ~MSParent();
    void setSon(MSSon *aSon);
    string getClassName();
    map<string,MSTEObject*>* getSnapshot();
    unsigned char getTokenType();
    unsigned char getSingleEncodingCode();
    void encodeWithMSTEncodeur(MSTEncodeur* e);
    
    
};