//
//  MSTDecoder.h
//  MSTEncodDecodCpp
//
//  Created by Melodie on 24/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#ifndef _MSTE_DECODER_H
#define _MSTE_DECODER_H

#include <string>
#include <vector>
#include <memory>

#include "MSTE.h"

// Root class
class MSTEObject;

// Basic types
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

// Root class
class MSTEObject;

// Basic types
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

class MSTDecoder : public MSTE
{
public:
    // Constructor
	MSTDecoder();
    
    // Destructor
	virtual ~MSTDecoder();
    
    // Main method
    std::shared_ptr<MSTEObject> decodeString(const std::string& inputBuffer);
   
protected:
    std::shared_ptr<MSTEObject> decodeObject(const std::string& inputBuffer, unsigned int& currentPosition);
    
    // Basic Types
    std::shared_ptr<MSTEBasicType> decodeChar(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeUnsignedChar(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeShort(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeUnsignedShort(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeInt32(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeUnsignedInt32(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeInt64(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeUnsignedInt64(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeFloat(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEBasicType> decodeDouble(const std::string& inputBuffer, unsigned int& currentPosition);

    // Complex types
    std::shared_ptr<MSTENumber>         decodeNumber(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEString>         decodeString(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEDate>           decodeLocalDate(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEDate>           decodeUtcDate(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEColor>          decodeColor(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTEData>           decodeData(const std::string& inputBuffer, unsigned int& currentPosition);
    std::shared_ptr<MSTENaturalArray>   decodeNaturalArray(const std::string& inputBuffer, unsigned int& currentPosition);
    
    // Generic structures
    std::shared_ptr<MSTEDictionary>     decodeDictionary(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTEDictionary> item);
    std::shared_ptr<MSTEArray>          decodeArray(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTEArray> item);
    std::shared_ptr<MSTECouple>         decodeCouple(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTECouple> item);
    
    // User classes
    std::shared_ptr<MSTEUserClass>      decodeUserClass(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTEUserClass> item);

private :
    std::string decodeStringToken(const std::string& inputBuffer, unsigned int& currentPosition);
    std::pair<char*,char*> delimitatesStringToken(const std::string& inputBuffer, unsigned int& currentPosition);
    std::string decodeNumberToken(const std::string& inputBuffer, unsigned int& currentPosition);

    void jumpToNextNonBlankCharacter(const std::string& inputBuffer, unsigned int& currentPosition);
    bool isSeparator(unsigned char c);
    
    std::string MSTEVersion;
    unsigned int nbTokens;
    std::vector<std::string> classes;
    std::vector<std::string> keys;
    std::vector<std::shared_ptr<MSTEObject>> objects;
};

#endif // _MSTE_DECODEUR_H
