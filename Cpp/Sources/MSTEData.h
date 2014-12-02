//
//  MSTEData.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_DATA_H
#define _MSTE_DATA_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncodeur.h"

class MSTEData : public MSTEObject
{
public:
    // Constructors
	MSTEData();
	MSTEData(char* aData, unsigned long length);
    MSTEData(const char* aData, unsigned long length);
    
    // Destructor
	virtual ~MSTEData();

    // Getters
    char* getData();
    std::string getEncodedData();
    
    // Setters
    void setEncodedData(const char* aData, unsigned long length);
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

private :
    char* data;
    unsigned long length;
};

#endif // _MSTE_DATA_H
