//
//  MSTEncodeur.cpp
//  MSTEncodDecod
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//

#include "MSTEncodeur.h"

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

#include <memory>

MSTEncodeur::MSTEncodeur()
{
}

MSTEncodeur::~MSTEncodeur()
{
	// TODO Auto-generated destructor stub
}

std::unique_ptr<std::string> MSTEncodeur::encodeRootObject(std::shared_ptr<MSTEObject> o)
{
    // Initialize counters
    nbTokens = 1; // The root object
    lastKeyIndex=0;
    lastClassIndex = 0;
    lastReference = 0;
    
    std::string content;
    std::string result;
    
    // We encode the content first
    o->encodeWithMSTEncodeur(this, content);

    // We get the size of the arrays
    unsigned long lenClassesArray = classesArray.size();
    unsigned long lenKeysArray = keysArray.size();
    
    // MSTE version
    result.append("[\"MSTE");
    result.append(MSTE_CURRENT_VERSION);
    result.append("\",");
    
    // Tokens count
    unsigned long long ull = (5+lastKeyIndex+lastClassIndex+nbTokens);
    result.append(std::to_string(ull));
    result.append(",");
    
    // CRC
    result.append("\"CRC");
    unsigned long crcPosition = result.length();
    result.append("00000000\",");
    
    // Classes array length
    result.append(std::to_string(lenClassesArray));
    result.append(",");
    
    // Classes array
    for(int i=0; i < lenClassesArray; i++)
    {
        result.append("\"");
        result.append(classesArray[i]);
        result.append("\"");
        result.append(",");
    }
    
    // Keys array length
    result.append(std::to_string(lenKeysArray));
    result.append(",");
    
    // Keys array
    for(int i=0; i < lenKeysArray; i++)
    {
        result.append("\"");
        result.append(keysArray[i]);
        result.append("\"");
        result.append(",");
    }
    
    // Content
    result.append(content);
    
    // End of stream
    result.append("]");
    
    // Calculates the crc
    std::string crc = Crc32Calculator::calculateCRC32(result);
    result.replace(crcPosition, crc.length(), crc);
    
    return std::unique_ptr<std::string>(new std::string(result));
}

void MSTEncodeur::encodeTokenSeparator(std::string& outputBuffer)
{
    nbTokens++;
    outputBuffer.append(",");
}

void MSTEncodeur::encodeBool(MSTEBool* o, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(o->getBool() ? MSTE_TYPE_TRUE : MSTE_TYPE_FALSE));
}

void MSTEncodeur::encodeChar(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_CHAR));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string((int)c->getChar()));
}

void MSTEncodeur::encodeUnsignedChar(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_UNSIGNED_CHAR));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string((int)c->getUnsignedChar()));
}

void MSTEncodeur::encodeShort(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_SHORT));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getShort()));
}

void MSTEncodeur::encodeUnsignedShort(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_UNSIGNED_SHORT));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getUnsignedShort()));
}

void MSTEncodeur::encodeInt32(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_INT32));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getInt32()));
}

void MSTEncodeur::encodeUnsignedInt32(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_UNSIGNED_INT32));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getUnsignedInt32()));
}

void MSTEncodeur::encodeInt64(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_INT64));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getInt64()));
}

void MSTEncodeur::encodeUnsignedInt64(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_UNSIGNED_INT64));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getUnsignedInt64()));
}

void MSTEncodeur::encodeFloat(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_FLOAT));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getFloat()));
}

void MSTEncodeur::encodeDouble(MSTEBasicType* c, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_DOUBLE));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(c->getDouble()));
}

void MSTEncodeur::encodeReference(int idx, std::string& outputBuffer)
{
    outputBuffer.append(std::to_string(MSTE_TYPE_REFERENCE));
    encodeTokenSeparator(outputBuffer);
    outputBuffer.append(std::to_string(idx));
}

void MSTEncodeur::encodeNumber(MSTENumber* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_NUMBER));
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(c->getString());
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeString(MSTEString* c, std::string& outputBuffer)
{
    if(c->length() > 0)
    {
        int objectIndex = findObject(c);
        
        if (objectIndex == ITEM_NOT_FOUND)
        {
            registerObject(c);
            outputBuffer.append(std::to_string(MSTE_TYPE_STRING));
            encodeTokenSeparator(outputBuffer);
            outputBuffer.append("\"");
            outputBuffer.append(c->getEncodedString());
            outputBuffer.append("\"");
        }
        else
            encodeReference(objectIndex, outputBuffer);
    }
    else
        outputBuffer.append(std::to_string(MSTE_TYPE_EMPTY_STRING));
}

void MSTEncodeur::encodeWString(MSTEString* c, std::string& outputBuffer)
{
    if(c->wlength() > 0)
    {
        int objectIndex = findObject(c);
        
        if (objectIndex == ITEM_NOT_FOUND)
        {
            registerObject(c);
            outputBuffer.append(std::to_string(MSTE_TYPE_STRING));
            encodeTokenSeparator(outputBuffer);
            outputBuffer.append("\"");
            outputBuffer.append(c->getEncodedWString());
            outputBuffer.append("\"");
        }
        else
            encodeReference(objectIndex, outputBuffer);
    }
    else
        outputBuffer.append(std::to_string(MSTE_TYPE_EMPTY_STRING));
}

void MSTEncodeur::encodeLocalDate(MSTEDate* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_LOCAL_TIMESTAMP));
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(std::to_string(c->getLocalDate()));
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeUtcDate(MSTEDate* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_UTC_TIMESTAMP));
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(std::to_string(c->getUtcDate()));
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeColor(MSTEColor* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_COLOR));
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(std::to_string(c->getEncodedColor()));
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeData(MSTEData* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_BASE64_DATA));
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append("\"");
        outputBuffer.append(c->getEncodedData());
        outputBuffer.append("\"");
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeNaturalArray(MSTENaturalArray* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_NATURAL_ARRAY));
    
        unsigned long length = c->size();
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(std::to_string(length));
    
        for(int i=0; i < length; i++)
        {
            encodeTokenSeparator(outputBuffer);
            outputBuffer.append(std::to_string(c->getIntVector(i)));
        }
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeDictionary(MSTEDictionary* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);
        outputBuffer.append(std::to_string(MSTE_TYPE_DICTIONNARY));
    
        unsigned long size = c->size();
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(std::to_string(size));
    
        for(int i=0; i < size; i++)
        {
            encodeTokenSeparator(outputBuffer);
            outputBuffer.append("\"");
            outputBuffer.append(c->getKeyDictionary(i));
            outputBuffer.append("\"");
            encodeTokenSeparator(outputBuffer);
            c->getObjectDictionary(i)->encodeWithMSTEncodeur(this, outputBuffer);
        }
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeArray(MSTEArray* c, std::string& outputBuffer)
{
   int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);

        outputBuffer.append(std::to_string(MSTE_TYPE_ARRAY));
    
        unsigned long length = c->size();
        encodeTokenSeparator(outputBuffer);
        outputBuffer.append(std::to_string(length));
    
        for(int i=0; i < length; i++)
        {
            encodeTokenSeparator(outputBuffer);
            c->getObjectVector(i)->encodeWithMSTEncodeur(this, outputBuffer);
        }
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeCouple(MSTECouple* c, std::string& outputBuffer)
{
    int objectIndex = findObject(c);
    
    if (objectIndex == ITEM_NOT_FOUND)
    {
        registerObject(c);

        outputBuffer.append(std::to_string(MSTE_TYPE_COUPLE));
        encodeTokenSeparator(outputBuffer);
        c->getFirstMember()->encodeWithMSTEncodeur(this, outputBuffer);
        encodeTokenSeparator(outputBuffer);
        c->getSecondMember()->encodeWithMSTEncodeur(this, outputBuffer);
    }
    else
        encodeReference(objectIndex, outputBuffer);
}

void MSTEncodeur::encodeUserClass(MSTEUserClass* c, std::string& outputBuffer)
{
    if(c->getClassName().length()==0)
        throw "No class name";
    else
    {
        int objectIndex = findObject(c);
        
        if (objectIndex == ITEM_NOT_FOUND)
        {
            registerObject(c);
            outputBuffer.append(std::to_string(registerClass(c->getClassName())));
    
            unsigned long nbAttributes = c->getNbAttributes();
            encodeTokenSeparator(outputBuffer);
            outputBuffer.append(std::to_string(nbAttributes));
    
            for(int i = 0; i < nbAttributes; i++)
            {
                encodeTokenSeparator(outputBuffer);
                outputBuffer.append(std::to_string(registerKey(c->getAttributeName(i))));
                encodeTokenSeparator(outputBuffer);
                c->getAttributeValue(i)->encodeWithMSTEncodeur(this, outputBuffer);
            }
        }
        else
            encodeReference(objectIndex, outputBuffer);
    }
}

unsigned int MSTEncodeur::registerClass(std::string className)
{
    // Check if the class name is already stored
    std::vector<std::string>::iterator it = find(classesArray.begin(), classesArray.end(), className);
    
    if(it == classesArray.end())
    {
        // Class not referenced
        classesArray.push_back(className);
        classes.insert( std::pair<std::string, int>(className, MSTE_TYPE_USER_CLASS + lastClassIndex) );
        lastClassIndex++;
    }
    
    return classes[className];
}

unsigned int MSTEncodeur::registerKey(std::string keyName)
{
    // Check if the key name is already stored
    std::vector<std::string>::iterator it = find(keysArray.begin(), keysArray.end(), keyName);
    
    if(it == keysArray.end())
    {
        // Key not referenced
        keysArray.push_back(keyName);
        keys.insert( std::pair<std::string, int>(keyName, lastKeyIndex) );
        lastKeyIndex++;
    }
    
    return keys[keyName];
}

int MSTEncodeur::findObject(MSTEObject* item)
{
    if(encodedObjects.count(item) > 0)
        return encodedObjects[item];
    else
        return ITEM_NOT_FOUND;
}

void MSTEncodeur::registerObject(MSTEObject* item)
{
    encodedObjects.insert(std::pair<MSTEObject*, int>(item, lastReference));
    lastReference++;
}

