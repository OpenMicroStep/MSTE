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
#include "MSTEncoder.h"

// TODO : add type checking
class MSTENumber  : public MSTEObject
{
public:
    // Constructors
	MSTENumber();
    MSTENumber(std::string);
	
	template<typename T> MSTENumber(T val);
    
    // Destructor
	virtual ~MSTENumber();
    
    // Getters
    std::string getString();
	template<typename T> operator T();
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();
    
private :
    std::string value;
};

#endif // _MSTE_NUMBER_H