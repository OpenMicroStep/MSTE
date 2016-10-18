//
//  MSTENaturalArray.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_NATURAL_ARRAY_H
#define _MSTE_NATURAL_ARRAY_H

#include <string>
#include <vector>

#include "MSTEObject.h"
#include "MSTEncoder.h"

class MSTENaturalArray : public MSTEObject
{
public:
    // Constructors
	MSTENaturalArray();
    MSTENaturalArray(std::vector<int> *vector);
    
    // Destructor
	virtual ~MSTENaturalArray();

    // Getters
    int getIntVector (int idx);
    std::vector<int> *getVector();
    unsigned long size();
    
    // Methods
    void addItem(int item);
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();

private :
    std::vector<int> aVector;
};

#endif // _MSTE_NATURAL_ARRAY_H