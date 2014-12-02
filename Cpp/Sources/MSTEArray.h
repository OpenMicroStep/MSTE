//
//  MSTEArray.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_ARRAY_H
#define _MSTE_ARRAY_H

#include <string>
#include <vector>
#include <memory>

#include "MSTEObject.h"
#include "MSTEncodeur.h"

class MSTEArray : public MSTEObject
{
public:
    // Constructors
	MSTEArray();
	MSTEArray(std::vector<std::shared_ptr<MSTEObject>> vector);
    
    // Destructor
	virtual ~MSTEArray();
    
    // Getters
    std::shared_ptr<MSTEObject> getObjectVector(int idx);
    void setObjectVector(std::shared_ptr<MSTEObject> object);
	std::vector<std::shared_ptr<MSTEObject>> getVector();
	unsigned long size();
    
    // Methods
    void addItem(std::shared_ptr<MSTEObject> item);
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

private :
    std::vector<std::shared_ptr<MSTEObject>> aVector;
};

#endif // _MSTE_ARRAY_H