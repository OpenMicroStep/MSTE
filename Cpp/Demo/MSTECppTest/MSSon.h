//
//  MSSon.h
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

class MSSon : public MSPerson{
private:
    MSTEString* firstname;
    MSParent* mother;
    MSParent* father;
    map<string, MSTEObject*> * snapshot;
	
public:
	MSSon(MSParent* aMother, MSParent* aFather, MSTEString* aFirstname);
    MSSon(map<string,MSTEObject*> *aSnapshot);
    virtual ~MSSon();
    string getClassName();
    map<string, MSTEObject*> * getSnapshot;

    void encodeWithMSTEncodeur(MSTEncodeur* e);
    
};
