//
//  MSTEDictionary.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_DICTIONNARY_H
#define _MSTE_DICTIONNARY_H

#include <string>
#include <vector>
#include <map>
#include <memory>

#include "MSTEObject.h"
#include "MSTEncodeur.h"
#include "MSTEString.h"

class MSTEDictionary  : public MSTEObject
{
public:
    // Constructors
	MSTEDictionary();
    MSTEDictionary(std::vector<std::string> someKeys, std::vector<std::shared_ptr<MSTEObject>> someValues);
    MSTEDictionary(std::map<std::string,std::shared_ptr<MSTEObject>> *aMap);

    // Destructor
    virtual ~MSTEDictionary();

    // Getters
    std::string getKeyDictionary(unsigned long idx);
    std::shared_ptr<MSTEObject> getObjectDictionary(std::string key);
    std::shared_ptr<MSTEObject> getObjectDictionary(unsigned long idx);
	unsigned long size();
    
    // Methods
    void addItem(std::string key, std::shared_ptr<MSTEObject> item);
    void encodeWithMSTEncodeur(MSTEncodeur* e, std::string& outputBuffer);

private :
    std::vector<std::string> keys;
    std::vector<std::shared_ptr<MSTEObject>> values;
};

#endif // _MSTE_DICTIONNARY_H