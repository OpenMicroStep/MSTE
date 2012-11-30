//
//  MSPerson.h
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

using namespace std;
#define MALE   false
#define FEMALE true

class MSTEObject ;

class MSPerson : public MSTEObject {
private:
	/*MSTEString* name;
    MSTEString* firstname;
    bool sex;*/
    map<string,MSTEObject*> * snapshot;
  
	
public:
    MSPerson();
	//MSPerson(MSTEString* aName, MSTEString* aFirstName, aSex);
    MSPerson(map<string,MSTEObject*> *aSnapshot);
    virtual ~MSPerson();
    virtual string getClassName();
    map<string,MSTEObject*>* getSnapshot();
    virtual unsigned char getTokenType();
    virtual unsigned char getSingleEncodingCode();
    virtual void encodeWithMSTEncodeur(MSTEncodeur* e);
    
};