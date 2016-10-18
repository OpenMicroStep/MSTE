//
//  MSTEBool.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_BOOL_H
#define _MSTE_BOOL_H

#include <string>

#include "MSTEObject.h"
#include "MSTEncoder.h"

class MSTEBool : public MSTEObject
{
public:
    // Constructors
	MSTEBool();
    MSTEBool(bool tfBool);
    
    // Destructor
	virtual ~MSTEBool();
    
    // Getters
	bool getBool();
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();
    
private:
    bool aBool;
};

#endif // _MSTE_BOOL_H
