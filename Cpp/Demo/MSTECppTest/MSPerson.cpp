//
//  MSPerson.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 28/11/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSPerson.h"
#include "MSTELib.h"

MSTECustomClassRegister<MSPerson> MSPerson::registre("Person");

MSPerson::MSPerson()
{
}

MSPerson::MSPerson(std::shared_ptr<MSTEUserClass> o)
{
    unsigned long nbAttributes = o->getNbAttributes();
    
    for(unsigned long i = 0; i < nbAttributes; i++)
    {
        std::string attributeName = o->getAttributeName((int)i);
        
        if(attributeName=="name")
            name = std::dynamic_pointer_cast<MSTEString>(o->getAttributeValue((int) i))->getString();
        else if (attributeName=="firstName")
            firstname =std::dynamic_pointer_cast<MSTEString>(o->getAttributeValue((int) i))->getString();
        else if (attributeName=="birthday")
            birthday = std::dynamic_pointer_cast<MSTEDate>(o->getAttributeValue((int) i))->getLocalDate();
    }
}

// Cast operators
MSPerson::operator std::unique_ptr<MSTEUserClass>()
{
    std::unique_ptr<MSTEUserClass> myUserClass(new MSTEUserClass("Person"));
    myUserClass->addAttribute("name", std::make_shared<MSTEString>(name));
    myUserClass->addAttribute("firstName", std::make_shared<MSTEString>(firstname));
    myUserClass->addAttribute("birthday", std::make_shared<MSTEDate>(birthday, Local));
    return myUserClass;
}

// Descriptors
std::string MSPerson::description()
{
    std::string result;
    result.append("I'm a person");
    result.append("\nName : ");
    result.append(name);
    result.append("\nFirst Name : ");
    result.append(firstname);
    
    return result;
}
