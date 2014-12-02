//
//  MSTEUserClass.cpp
//  MSTECppTest
//
//  Created by Julien PAPILLON on 21/11/2014.
//  Copyright (c) 2014 Melodie. All rights reserved.
//

#include "MSTEUserClass.h"

MSTEUserClass::MSTEUserClass(std::string aClassName)
{
    className = aClassName;
}

MSTEUserClass::MSTEUserClass(std::string aClassName, std::vector<std::string> someAttributeNames, std::vector<std::shared_ptr<MSTEObject>> someAttributeValues)
{
    className = aClassName;
    attributeNames = someAttributeNames;
    attributeValues = someAttributeValues;
}

// Destructor
MSTEUserClass::~MSTEUserClass()
{
    
}

// Getters
std::string MSTEUserClass::getClassName()
{
    return className;
}

unsigned long MSTEUserClass::getNbAttributes()
{
    return attributeNames.size();
}

std::vector<std::string> MSTEUserClass::getAttributeNames()
{
    return attributeNames;
}

std::string MSTEUserClass::getAttributeName(int idx)
{
    return attributeNames[idx];
}

std::vector<std::shared_ptr<MSTEObject>> MSTEUserClass::getAttributeValues()
{
    return attributeValues;
}

std::shared_ptr<MSTEObject> MSTEUserClass::getAttributeValue(int idx)
{
    return attributeValues[idx];
}

void MSTEUserClass::setClassName(std::string className)
{
    this->className = className;
}

void MSTEUserClass::addAttribute(std::string name, std::shared_ptr<MSTEObject> value)
{
    attributeNames.push_back(name);
    attributeValues.push_back(value);
}

// Methods
void MSTEUserClass::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeUserClass(this, outputBuffer);
}
