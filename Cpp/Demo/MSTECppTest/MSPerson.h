//
//  MSPerson.h
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _PERSON_H
#define _PERSON_H

#include "MSTECustomClass.h"
#include <map>
#include <memory>

class MSPerson : public MSTECustomClassBase
{
public:
    // Constructors
    MSPerson();
    MSPerson(std::shared_ptr<MSTEUserClass>);

    // Cast operators
    operator std::unique_ptr<MSTEUserClass>();
    
    // Descriptors
    std::string description();
    
private:
    std::string name;
    std::string firstname;
    long birthday;
    static MSTECustomClassRegister<MSPerson> registre;
};

#endif // _PERSON_H
