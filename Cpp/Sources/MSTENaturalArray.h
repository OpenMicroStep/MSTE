//
//  MSTENaturalArray.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include <vector>
using namespace std;

class MSTEArray ;

class MSTENaturalArray : public MSTEArray {
    private :
	vector<int> aVector;
public:
	MSTENaturalArray();
	MSTENaturalArray(vector<int> *vector);
	MSTENaturalArray(MSTENaturalArray &array);
	virtual ~MSTENaturalArray();
	string getClassName();
	int getIntVector (int idx);
	void setIntVector (int value);
	vector<int> *getVector();
    unsigned long size();
	unsigned char getTokenType();
    
	void encodeWithMSTEncodeur(MSTEncodeur* e);
};
