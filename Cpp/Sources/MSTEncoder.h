//
//  MSTEncodeur.h
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef MSTE_ENCODEUR_H
#define MSTE_ENCODEUR_H

#include <sstream>
#include <vector>
#include <map>
#include <memory>
#include "MSTE.h"

// Root class
class MSTEObject;

// Basic types
class MSTENull;
class MSTEBool;
class MSTEBasicType;

// Complex types
class MSTEString;
class MSTENumber;
class MSTEDate;
class MSTEColor;
class MSTEData;
class MSTENaturalArray;

// Generic structures
class MSTEDictionary;
class MSTEArray;
class MSTECouple;

// User classes
class MSTEUserClass;

class MSTEncodeur : MSTE
{
public:
    // Constructor
	MSTEncodeur();
    
    // Destructor
	virtual ~MSTEncodeur();
    
    // Main methods
    std::unique_ptr<std::string> encodeRootObject(std::shared_ptr<MSTEObject>);
    
    /************************************************/
    /*          Encoding functions                  */
    /************************************************/
    
    // Special items
    void encodeTokenSeparator(std::string&);
    
    // Basic types
	void encodeNull(MSTENull*, std::string&);
    void encodeBool(MSTEBool*, std::string&);
    void encodeChar(MSTEBasicType*, std::string&);
    void encodeUnsignedChar(MSTEBasicType*, std::string&);
    void encodeShort(MSTEBasicType*, std::string&);
    void encodeUnsignedShort(MSTEBasicType*, std::string&);
    void encodeInt32(MSTEBasicType*, std::string&);
    void encodeUnsignedInt32(MSTEBasicType*, std::string&);
    void encodeInt64(MSTEBasicType*, std::string&);
    void encodeUnsignedInt64(MSTEBasicType*, std::string&);
    void encodeFloat(MSTEBasicType*, std::string&);
    void encodeDouble(MSTEBasicType*, std::string&);
    void encodeReference(int, std::string&);
    
    // Complex types
    void encodeNumber(MSTENumber*, std::string&);
    void encodeString(MSTEString*, std::string&);
    void encodeWString(MSTEString*, std::string&);
    void encodeLocalDate(MSTEDate*, std::string&);
    void encodeUtcDate(MSTEDate*, std::string&);
    void encodeColor(MSTEColor*, std::string&);
    void encodeData(MSTEData*, std::string&);
    void encodeNaturalArray(MSTENaturalArray*, std::string&);
    
    // Generic structures
    void encodeDictionary(MSTEDictionary*, std::string&);
    void encodeArray(MSTEArray*, std::string&);
    void encodeCouple(MSTECouple*, std::string&);
    
    // User classes
    void encodeUserClass(MSTEUserClass*, std::string&);
    
private:
    const int ITEM_NOT_FOUND = -1;
    
    // Utility functions
    unsigned int registerClass(std::string);
    unsigned int registerKey(std::string);
    int findObject(MSTEObject*);
    void registerObject(MSTEObject*);

    // Keys names
    std::vector<std::string> keysArray;
    std::map<std::string,int> keys;
    
    // Classes names
    std::vector<std::string> classesArray;
    std::map<std::string,int> classes;
    
    // Encoded objects
    std::map <MSTEObject*, unsigned int> encodedObjects;
    
    int nbTokens;
    int lastKeyIndex;
    int lastClassIndex;
    int lastReference;
};

#endif // MSTE_ENCODEUR_H
