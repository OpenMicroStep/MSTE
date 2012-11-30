//
//  MSTETest.h
//  MSTEncodDecodCpp
//
//  Created by Melodie on 24/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//


using namespace std;

class MSTEncodeur ;
class MSTEObject ;

class MSTETest : public MSTEObject {
private:
	
	map<string,MSTEObject*>* snapshot;
public:
	MSTETest();
    MSTETest(map<string,MSTEObject*> *aSnapshot);
	virtual ~MSTETest();

    string getClassName();
	map<string,MSTEObject*>* getSnapshot();
    unsigned char getTokenType();
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);


    
};
