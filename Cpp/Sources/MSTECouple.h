//
//  MSTECouple.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_COUPLE_H
#define _MSTE_COUPLE_H

#include <memory>

#include "MSTEObject.h"
#include "MSTEncoder.h"

class MSTECouple : public MSTEObject
{
public:
    // Constructors
    MSTECouple();
    MSTECouple(std::shared_ptr<MSTEObject> firstMember,std::shared_ptr<MSTEObject> secondMember);

    // Destructor
    ~MSTECouple();

    // Getters
    std::shared_ptr<MSTEObject> getFirstMember();
	std::shared_ptr<MSTEObject> getSecondMember();
    
    // Setters
    void setFirstMember(std::shared_ptr<MSTEObject> item);
    void setSecondMember(std::shared_ptr<MSTEObject> item);

    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

	std::string getClassName();

private :
    std::shared_ptr<MSTEObject> couple1;
    std::shared_ptr<MSTEObject> couple2;
};

#endif // _MSTE_COUPLE_H