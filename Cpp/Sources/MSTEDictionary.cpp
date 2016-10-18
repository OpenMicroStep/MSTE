//
//  MSTEDictionary.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEDictionary.h"

MSTEDictionary::MSTEDictionary()
{
    
}

MSTEDictionary::MSTEDictionary(std::vector<std::string> someKeys, std::vector<std::shared_ptr<MSTEObject>> someValues)
{
    keys = someKeys;
    values = someValues;
}

MSTEDictionary::MSTEDictionary(std::map<std::string,std::shared_ptr<MSTEObject>> *aMap)
{
    std::map<std::string, std::shared_ptr<MSTEObject>>::iterator iter;
    
    for (iter = aMap->begin(); iter != aMap->end(); iter++)
    {
        keys.push_back(iter->first);
        values.push_back(iter->second);
    }
}

MSTEDictionary::~MSTEDictionary() {
    
}

std::string MSTEDictionary::getKeyDictionary(unsigned long idx)
{
    return keys[idx];
}

std::shared_ptr<MSTEObject> MSTEDictionary::getObjectDictionary(std::string key)
{
    unsigned long length = size();
    for(int i=0; i< length; i++)
        if (keys[i]==key)
            return values[i];
    return NULL;
}

std::shared_ptr<MSTEObject> MSTEDictionary::getObjectDictionary(unsigned long idx)
{
    return values[idx];
}

unsigned long MSTEDictionary::size()
{
	return keys.size();
}

void MSTEDictionary::addItem(std::string key, std::shared_ptr<MSTEObject> item)
{
    keys.push_back(key);
    values.push_back(item);
}

void MSTEDictionary::encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer)
{
    e->encodeDictionary(this, outputBuffer);
}

std::string MSTEDictionary::getClassName()
{
	return "MSTEDictionary";
}
