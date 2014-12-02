//
//  MSTENumber.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_NUMBER_H
#define _MSTE_NUMBER_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncodeur.h"

// TODO : add type checking
class MSTENumber  : public MSTEObject
{
public:
    // Constructors
	MSTENumber();
    MSTENumber(std::string);
    
    // Destructor
	virtual ~MSTENumber();
    
    // Getters
    std::string getString();
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);
    
private :
    std::string value;
};

#endif // _MSTE_NUMBER_H