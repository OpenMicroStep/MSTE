//
//  MSTEObject.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//
#ifndef MSTE_OBJECT_H
#define MSTE_OBJECT_H

#include <string>

class MSTEncodeur;

class MSTEObject
{
public:
	// Constructor & destructor
	MSTEObject();
	virtual ~MSTEObject();
    
	// Common virtual methods
    virtual void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer) = 0;
	virtual std::string getClassName() = 0;
};

#endif // MSTE_OBJECT_H