//
//  MSTDecodeur.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 24/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTDecodeur.h"

#include "MSTEBool.h"
#include "MSTEBasicType.h"
#include "MSTENumber.h"
#include "MSTEString.h"
#include "MSTEDate.h"
#include "MSTEColor.h"
#include "MSTEData.h"
#include "MSTENaturalArray.h"
#include "MSTEDictionary.h"
#include "MSTEArray.h"
#include "MSTECouple.h"
#include "MSTEUserClass.h"

#include "CRC32Calculator.h"

#include <iostream>

MSTDecodeur::MSTDecodeur()
{
}

MSTDecodeur::~MSTDecodeur()
{
}

std::shared_ptr<MSTEObject> MSTDecodeur::decodeString(const std::string& inputBuffer)
{
    if(inputBuffer.length()==0)
        throw "Empty buffer";
    else
    {
        // We flush the old data
        classes.clear();
        keys.clear();
        
        // We start at the begining of the buffer
        unsigned int currentPosition = 0;
        
        // We parse the beginning of array
        if(inputBuffer[currentPosition]!='[')
            throw "Buffer is not a json array";
        currentPosition++;
        
        // We parse the MSTE version
        MSTEVersion = decodeStringToken(inputBuffer, currentPosition);
        if(MSTEVersion != std::string("MSTE0102"))
           throw "Unsupported version of MSTE";
        
        // We parse the number of tokens
        nbTokens = std::stoi(decodeNumberToken(inputBuffer, currentPosition));
        
        // We parse the CRC
        std::string crc = decodeStringToken(inputBuffer, currentPosition);
        
        // TODO: check the CRC
        
        // We parse the classes
        int nbClasses = std::stoi(decodeNumberToken(inputBuffer, currentPosition));
        for(int i = 0; i < nbClasses; i++)
            classes.push_back(decodeStringToken(inputBuffer, currentPosition));
        
        // We parse the keys
        int nbKeys = std::stoi(decodeNumberToken(inputBuffer, currentPosition));
        for(int i = 0; i < nbKeys; i++)
            keys.push_back(decodeStringToken(inputBuffer, currentPosition));
        
        // We decode the root object
        return decodeObject(inputBuffer, currentPosition);
    }
    return NULL;
}

std::shared_ptr<MSTEObject> MSTDecodeur::decodeObject(const std::string& inputBuffer, unsigned int& currentPosition)
{
    int typeId = std::stoi(decodeNumberToken(inputBuffer, currentPosition));
    std::shared_ptr<MSTEObject> result;
    
    switch (typeId)
    {
        case MSTE_TYPE_NULL:
            result = NULL;
            break;
            
        case MSTE_TYPE_TRUE:
            result = std::make_shared<MSTEBool>(MSTEBool(true));
            break;
            
        case MSTE_TYPE_FALSE:
            result = std::make_shared<MSTEBool>(MSTEBool(false));
            break;
            
        case MSTE_TYPE_EMPTY_STRING:
            result = std::make_shared<MSTEString>();
            break;

        case MSTE_TYPE_EMPTY_DATA:
            result = std::make_shared<MSTEData>();
            break;

        case MSTE_TYPE_REFERENCE:
            result = objects[std::stoi(decodeNumberToken(inputBuffer, currentPosition))];
            break;
            
        case MSTE_TYPE_CHAR:
            result = decodeChar(inputBuffer, currentPosition);
            break;

        case MSTE_TYPE_UNSIGNED_CHAR:
            result = decodeUnsignedChar(inputBuffer, currentPosition);
            break;

        case MSTE_TYPE_SHORT:
            result = decodeShort(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_UNSIGNED_SHORT:
            result = decodeUnsignedShort(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_INT32:
            result = decodeInt32(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_UNSIGNED_INT32:
            result = decodeUnsignedInt32(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_INT64:
            result = decodeInt64(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_UNSIGNED_INT64:
            result = decodeUnsignedInt64(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_FLOAT:
            result = decodeFloat(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_DOUBLE:
            result = decodeDouble(inputBuffer, currentPosition);
            break;
            
        case MSTE_TYPE_NUMBER:
            result = decodeNumber(inputBuffer, currentPosition);
            objects.push_back(result);
            break;

        case MSTE_TYPE_STRING:
            result = decodeString(inputBuffer, currentPosition);
            objects.push_back(result);
            break;

        case MSTE_TYPE_LOCAL_TIMESTAMP:
            result = decodeLocalDate(inputBuffer, currentPosition);
            objects.push_back(result);
            break;

        case MSTE_TYPE_UTC_TIMESTAMP:
            result = decodeUtcDate(inputBuffer, currentPosition);
            objects.push_back(result);
            break;

        case MSTE_TYPE_COLOR:
            result = decodeColor(inputBuffer, currentPosition);
            objects.push_back(result);
            break;
            
        case MSTE_TYPE_BASE64_DATA:
            result = decodeData(inputBuffer, currentPosition);
            objects.push_back(result);
            break;
            
        case MSTE_TYPE_NATURAL_ARRAY:
            result = decodeNumber(inputBuffer, currentPosition);
            objects.push_back(result);
            break;
            
        case MSTE_TYPE_DICTIONNARY:
            result = std::make_shared<MSTEDictionary>();
            objects.push_back(result);
            decodeDictionary(inputBuffer, currentPosition, std::dynamic_pointer_cast<MSTEDictionary>(result));
            break;
            
        case MSTE_TYPE_ARRAY:
            result = std::make_shared<MSTEArray>();
            objects.push_back(result);
            decodeArray(inputBuffer, currentPosition, std::dynamic_pointer_cast<MSTEArray>(result));
            break;
            
        case MSTE_TYPE_COUPLE:
            result = std::make_shared<MSTECouple>();
            objects.push_back(result);
            decodeCouple(inputBuffer, currentPosition, std::dynamic_pointer_cast<MSTECouple>(result));
            break;
            
        default:
            if ((typeId >= MSTE_TYPE_USER_CLASS) && (typeId < MSTE_TYPE_USER_CLASS + classes.size()))
            {
                std::shared_ptr<MSTEUserClass> item(new MSTEUserClass(classes[typeId - MSTE_TYPE_USER_CLASS]));
                objects.push_back(item);
                decodeUserClass(inputBuffer, currentPosition, item);
                return item;
            }
            else
                throw "Invalid token type";
    }
    
    return result;
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeChar(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((char)decodeStringToken(inputBuffer, currentPosition)[0]);
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeUnsignedChar(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((unsigned char)decodeStringToken(inputBuffer, currentPosition)[0]);
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeShort(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((short)std::stol(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeUnsignedShort(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((unsigned short)std::stoul(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeInt32(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((long)std::stol(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeUnsignedInt32(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((unsigned long)std::stoul(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeInt64(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((long long)std::stoll(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeUnsignedInt64(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((unsigned long long)std::stoull(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeFloat(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((float)std::stof(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEBasicType> MSTDecodeur::decodeDouble(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEBasicType>((double)std::stod(decodeNumberToken(inputBuffer, currentPosition)));
}

// Complex types
std::shared_ptr<MSTENumber> MSTDecodeur::decodeNumber(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTENumber>(decodeNumberToken(inputBuffer, currentPosition));
}

std::shared_ptr<MSTEString> MSTDecodeur::decodeString(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEString>(decodeStringToken(inputBuffer, currentPosition));
}

std::shared_ptr<MSTEDate> MSTDecodeur::decodeLocalDate(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEDate>(std::stol(decodeNumberToken(inputBuffer, currentPosition)), Local);
}

std::shared_ptr<MSTEDate> MSTDecodeur::decodeUtcDate(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEDate>(std::stol(decodeNumberToken(inputBuffer, currentPosition)), Utc);
}

std::shared_ptr<MSTEColor> MSTDecodeur::decodeColor(const std::string& inputBuffer, unsigned int& currentPosition)
{
    return std::make_shared<MSTEColor>(std::stoul(decodeNumberToken(inputBuffer, currentPosition)));
}

std::shared_ptr<MSTEData> MSTDecodeur::decodeData(const std::string& inputBuffer, unsigned int& currentPosition)
{
    std::pair<char*,char*> delimiters = delimitatesStringToken(inputBuffer, currentPosition);
    std::shared_ptr<MSTEData> ret(new MSTEData());
    ret->setEncodedData(delimiters.first, (delimiters.second - delimiters.first) * sizeof(char));
    return ret;
}

std::shared_ptr<MSTENaturalArray> MSTDecodeur::decodeNaturalArray(const std::string& inputBuffer, unsigned int& currentPosition)
{
    std::shared_ptr<MSTENaturalArray> result(new MSTENaturalArray());
    
    unsigned long nbElements = std::stoul(decodeNumberToken(inputBuffer, currentPosition));
    
    for(unsigned long i = 0; i < nbElements; i++)
    {
        result->addItem(std::stoi(decodeNumberToken(inputBuffer, currentPosition)));
    }
    
    return result;
}

// Generic structures
std::shared_ptr<MSTEDictionary> MSTDecodeur::decodeDictionary(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTEDictionary> item)
{
    unsigned long nbElements = std::stoul(decodeNumberToken(inputBuffer, currentPosition));
    
    for(unsigned long i = 0; i < nbElements; i++)
    {
        std::string key = decodeStringToken(inputBuffer, currentPosition);
        std::shared_ptr<MSTEObject> value = decodeObject(inputBuffer, currentPosition);
        item->addItem(key, value);
    }
    
    return item;
}

std::shared_ptr<MSTEArray> MSTDecodeur::decodeArray(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTEArray> item)
{
    unsigned long nbElements = std::stoul(decodeNumberToken(inputBuffer, currentPosition));
    
    for(unsigned long i = 0; i < nbElements; i++)
    {
        std::shared_ptr<MSTEObject> value = decodeObject(inputBuffer, currentPosition);
        item->addItem(value);
    }
    
    return item;
}

std::shared_ptr<MSTECouple> MSTDecodeur::decodeCouple(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTECouple> item)
{
    item->setFirstMember(decodeObject(inputBuffer, currentPosition));
    item->setSecondMember(decodeObject(inputBuffer, currentPosition));
    return item;
}

// User classes
std::shared_ptr<MSTEUserClass> MSTDecodeur::decodeUserClass(const std::string& inputBuffer, unsigned int& currentPosition, std::shared_ptr<MSTEUserClass> item)
{
    unsigned long nbAttributes = std::stoul(decodeNumberToken(inputBuffer, currentPosition));
    
    for(unsigned long i = 0; i < nbAttributes; i++)
    {
        std::string keyName = keys[std::stoi(decodeNumberToken(inputBuffer, currentPosition))];
        std::shared_ptr<MSTEObject> keyValue = decodeObject(inputBuffer, currentPosition);
        item->addAttribute(keyName, keyValue);
    }
    
    return item;
}

std::pair<char*, char*> MSTDecodeur::delimitatesStringToken(const std::string& inputBuffer, unsigned int& currentPosition)
{
    bool endOfStringReached = false;
    char *stringBegining, *stringEnd;
    
    // We skip the non-blank characters
    jumpToNextNonBlankCharacter(inputBuffer, currentPosition);
    
    // We skip the first '"'
    if(inputBuffer[currentPosition] != '"')
        throw "Token is not a valid string.";
    currentPosition++;
    
    // We set the begining of the string
    stringBegining = (char*) (inputBuffer.data() + (currentPosition * sizeof(char)));
    
    while(!endOfStringReached)
    {
        switch(inputBuffer[currentPosition])
        {
            case '"':
                // End of string reached
                endOfStringReached = true;
                currentPosition++;
                break;
            case '\\':
                // Escaped character
                switch(inputBuffer[currentPosition+1])
                {
                    case 'u':
                    case 'U':
                        // Hexa character
                        if(!isxdigit(inputBuffer[currentPosition+2]) || !isxdigit(inputBuffer[currentPosition+3]) || !isxdigit(inputBuffer[currentPosition+4]) || !isxdigit(inputBuffer[currentPosition+5]))
                        throw "Invalid Hexadecimal sequence";
                        else currentPosition += 6;
                        break;
                    
                    // Escaped character
                    case 'r':
                    case 'n':
                    case 't':
                    case '\\':
                    case '"':
                    case 'b':
                    case 'f':
                        currentPosition += 2;
                        break;
                    default:
                        throw "Unrecognized character";
                        break;
                }
                break;
            default:
                // Normal character
                currentPosition++;
                break;
        }
    }
    stringEnd = (char*) (inputBuffer.data() + (currentPosition-2) * sizeof(char));
    
    // We skip the non-blank characters
    jumpToNextNonBlankCharacter(inputBuffer, currentPosition);
    
    // We check the next character is a separator
    if(isSeparator(inputBuffer[currentPosition]))
        currentPosition++;
    else
        throw "Invalid token";
    
    return std::pair<char*,char*>(stringBegining, stringEnd);
}

// Get the string token and validates the token
std::string MSTDecodeur::decodeStringToken(const std::string& inputBuffer, unsigned int& currentPosition)
{
    bool endOfStringReached = false;
    std::string result;
    
    // We skip the non-blank characters
    jumpToNextNonBlankCharacter(inputBuffer, currentPosition);
    
    // We skip the first '"'
    if(inputBuffer[currentPosition]!='"')
        throw "Token is not a valid string.";
    currentPosition++;
    
    while (!endOfStringReached)
    {
        unsigned char currentCharacter = inputBuffer[currentPosition];
        unsigned char nextCharacter;
        
        switch (currentCharacter)
        {
            case '"':
                // End of string reached
                endOfStringReached = true;
                currentPosition++;
                break;
            case '\\':
                // Escaped character
                nextCharacter = inputBuffer[currentPosition+1];
                switch(nextCharacter)
                {
                    case 'u':
                    case 'U':
                        // Hexa character
                        if(!isxdigit(inputBuffer[currentPosition+2]) || !isxdigit(inputBuffer[currentPosition+3]) || !isxdigit(inputBuffer[currentPosition+4]) || !isxdigit(inputBuffer[currentPosition+5]))
                            throw "Invalid Hexadecimal sequence";
                        else
                        {
                            char *number = new char[5];
                            number[0] = inputBuffer[currentPosition+2];
                            number[1] = inputBuffer[currentPosition+3];
                            number[2] = inputBuffer[currentPosition+4];
                            number[3] = inputBuffer[currentPosition+5];
                            number[4] = 0;
                            
                            long value = std::stol(number, NULL, 16);
                            delete number;
                            
                            result += (unsigned char) value;
                            currentPosition += 6;
                        }
                        break;

                    // Escaped character
                    case 'r':
                        result += '\r';
                        currentPosition += 2;
                        break;
                    case 'n':
                        result += '\n';
                        currentPosition += 2;
                        break;
                    case 't':
                        result += '\t';
                        currentPosition += 2;
                        break;
                    case '\\':
                        result += '\\';
                        currentPosition += 2;
                        break;
                    case '"':
                        result += '\"';
                        currentPosition += 2;
                        break;
                    case 'b':
                        result += '\b';
                        currentPosition += 2;
                        break;
                    case 'f':
                        result += '\f';
                        currentPosition += 2;
                        break;
                        
                    default:
                        throw "Unrecognized character";
                        break;
                }
                break;
            default:
                // Normal character
                result += currentCharacter;
                currentPosition++;
                break;
        }
    }

    // We skip the non-blank characters
    jumpToNextNonBlankCharacter(inputBuffer, currentPosition);
    
    // We check the next character is a separator
    if(isSeparator(inputBuffer[currentPosition]))
        currentPosition++;
    else
        throw "Invalid token";

    return result;
}

std::string MSTDecodeur::decodeNumberToken(const std::string& inputBuffer, unsigned int& currentPosition)
{
    bool endOfNumberReached = false;
    std::string result;
    
    // We skip the non-blank characters
    jumpToNextNonBlankCharacter(inputBuffer, currentPosition);

    while (!endOfNumberReached)
    {
        unsigned char currentCharacter = inputBuffer[currentPosition];
        switch (currentCharacter)
        {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
            case '.':
            case 'e':
            case 'E':
            case '-':
                // Valid character
                result += currentCharacter;
                currentPosition++;
                break;
            case ' ':
            case '\t':
            case '\n':
            case '\r':
            case ',':
            case ']':
                // End of token
                endOfNumberReached = true;
                break;
            default:
                throw "Invalid number";
                break;
        }
    }

    // We skip the non-blank characters
    jumpToNextNonBlankCharacter(inputBuffer, currentPosition);
    
    // We check the next character is a separator
    if(isSeparator(inputBuffer[currentPosition]))
        currentPosition++;
    else
        throw "Invalid token";
    
    return result;
}


void MSTDecodeur::jumpToNextNonBlankCharacter(const std::string& inputBuffer, unsigned int& currentPosition)
{
    while ((inputBuffer[currentPosition]==' ') || (inputBuffer[currentPosition]=='\t') || (inputBuffer[currentPosition]=='\n') || (inputBuffer[currentPosition]=='\r'))
        currentPosition++;
}

bool MSTDecodeur::isSeparator(unsigned char c)
{
    return (c==',')||(c==']'); // End of array is also a valid separator
}

