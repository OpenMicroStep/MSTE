//
//  MSTEUserClass.h
//  MSTECppTest
//
//  Created by Julien PAPILLON on 21/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#ifndef _MSTE_USER_CLASS_H
#define _MSTE_USER_CLASS_H

#include <string>
#include <vector>

#include "MSTEObject.h"
#include "MSTEncoder.h"

class MSTEUserClass : public MSTEObject
{
public:
    // Constructors
    MSTEUserClass(std::string aClassName);
    MSTEUserClass(std::string aClassName, std::vector<std::string> someAttributeNames, std::vector<std::shared_ptr<MSTEObject>> someAttributeValues);
    
    // Destructor
    virtual ~MSTEUserClass();
    
    // Getters
    std::string getClassName();
    unsigned long getNbAttributes();
    std::vector<std::string> getAttributeNames();
    std::string getAttributeName(int idx);
    std::vector<std::shared_ptr<MSTEObject>> getAttributeValues();
    std::shared_ptr<MSTEObject> getAttributeValue(int idx);
	std::shared_ptr<MSTEObject> getAttributeValue(const std::string& name);
    
    // Setters
    void setClassName(std::string className);
    void addAttribute(std::string name, std::shared_ptr<MSTEObject> value);
    
    // Methods
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);
    
private:
    std::string className;
    std::vector<std::string> attributeNames;
    std::vector<std::shared_ptr<MSTEObject>> attributeValues;
};

#endif // _MSTE_USER_CLASS_H