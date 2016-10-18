//
//  main.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//


// LAST VERSION
#define _ENCODE 1
#define _DECODE 2
#define _CONCAT_PERFS 3
#define _DECODE_AND_ENCODE 4
#define _CRC 5

#define PROGRAM _DECODE_AND_ENCODE

#include <string>
#include <iostream>
#include <chrono>

#include "../../Sources/MSTELib.h"
#include "../../Sources/RopeString.h"
#include "../../Sources/MSTECustomClass.h"
#include "MSPerson.h"
#include "../../Sources/CRC32Calculator.h"

int main(int argc, const char * argv[])
{
    std::string inputBuffer = "[\"MSTE0102\",59,\"CRCB43F574E\",1,\"Person\",6,\"name\",\"firstName\",\"birthday\",\"maried-to\",\"father\",\"mother\",31,3,50,4,0,21,\"Durand\",1,21,\"Yves\",2,22,-1222131600,3,50,4,0,9,2,1,21,\"Claire\",2,22,-1185667200,3,9,1,9,5,50,5,0,9,2,1,21,\"Lou\",2,22,-426214800,4,9,1,5,9,5]";
    
#if PROGRAM==_ENCODE
    std::shared_ptr<MSTEString> name(new MSTEString("Durand"));
    
    std::shared_ptr<MSTEUserClass> Yves(new MSTEUserClass("Person"));
    Yves->addAttribute("name", name);
    Yves->addAttribute("firstName", std::make_shared<MSTEString>("Yves"));
    Yves->addAttribute("birthday", std::make_shared<MSTEDate>(-1222131600, Local));
    
    std::shared_ptr<MSTEUserClass> Claire(new MSTEUserClass("Person"));
    Claire->addAttribute("name", name);
    Claire->addAttribute("firstName", std::make_shared<MSTEString>("Claire"));
    Claire->addAttribute("birthday", std::make_shared<MSTEDate>(-1185667200, Local));
    Claire->addAttribute("maried-to", Yves);
    Yves->addAttribute("maried-to", Claire);
    
    std::shared_ptr<MSTEUserClass> Lou(new MSTEUserClass("Person"));
    Lou->addAttribute("name", name);
    Lou->addAttribute("firstName", std::make_shared<MSTEString>("Lou"));
    Lou->addAttribute("birthday", std::make_shared<MSTEDate>(-426214800, Local));
    Lou->addAttribute("father", Yves);
    Lou->addAttribute("mother", Claire);
    
    std::shared_ptr<MSTEArray> myArray(new MSTEArray());
    myArray->addItem(Yves);
    myArray->addItem(Claire);
    myArray->addItem(Lou);
    
    MSTEncodeur encoder;
    std::cout << *(encoder.encodeRootObject(myArray)) << std::endl;

#endif // PROGRAM==_ENCODE
    
#if PROGRAM==_DECODE
    
    MSTDecodeur decoder;
    std::shared_ptr<MSTEArray> array = std::static_pointer_cast<MSTEArray>(decoder.decodeString(inputBuffer));
    
    if(!array) throw "NULL pointer";
    std::vector<std::shared_ptr<MSTEObject>> items = array->getVector();
    
    for (unsigned long i = 0; i < items.size(); i++)
    {
        std::shared_ptr<MSTEUserClass> usClass = std::dynamic_pointer_cast<MSTEUserClass>(items.at(i));
        std::cout << MSTECustomClassFactory::createInstance(usClass)->description() << std::endl << std::endl;
    }
    
#endif //PROGRAM==_DECODE
    
#if PROGRAM==_DECODE_AND_ENCODE
 
    MSTDecoder decoder;
    std::shared_ptr<MSTEObject> root = decoder.decodeString(inputBuffer);
    MSTEncodeur encoder;
    std::cout << *(encoder.encodeRootObject(root)) << std::endl;
#endif // PROGRAM==_DECODE_AND_ENCODE
    
#if PROGRAM==_CONCAT_PERFS
    //              PERFORMANCE TESTING
    // We concatenate the input buffer n times, and then put the result in a string
    std::chrono::system_clock::time_point testBegin, testEnd;
    
    const int nbTests = 10000;
    
    std::cout << "PERFORMANCE TESTS" << std::endl;
    

    /////////////////////////////////////////////
    std::cout << "1st Test : string operator +" << std::endl;
    std::string resultTest1;
    testBegin = std::chrono::system_clock::now();
    
    for(int i = 0; i < nbTests; i++)
        resultTest1 = resultTest1 + std::string(inputBuffer);
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";
    
    /////////////////////////////////////////////
    std::cout << "2nd Test : string operator += (without reserve)" << std::endl;
    std::string resultTest2;
    testBegin = std::chrono::system_clock::now();
    
    for(int i = 0; i < nbTests; i++)
        resultTest2 += std::string(inputBuffer);
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";

    /////////////////////////////////////////////
    std::cout << "3rd Test : string function append (without reserve)" << std::endl;
    std::string resultTest3;
    testBegin = std::chrono::system_clock::now();
    
    for(int i = 0; i < nbTests; i++)
        resultTest3.append(std::string(inputBuffer));
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";

    /////////////////////////////////////////////
    std::cout << "4th Test : string operator += (with reserve)" << std::endl;
    std::string resultTest4;
    unsigned long lengthTest4 = 0;
    testBegin = std::chrono::system_clock::now();
    
    // In our case, we cannot predict the exact size of the string, so we calculate it
    for(int i = 0; i < nbTests; i++)
        lengthTest4 += std::string(inputBuffer).length();
    resultTest4.reserve(lengthTest4);
    
    for(int i = 0; i < nbTests; i++)
        resultTest4 += std::string(inputBuffer);
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";

    /////////////////////////////////////////////
    std::cout << "5th Test : string function append (with reserve)" << std::endl;
    std::string resultTest5;
    unsigned long lengthTest5 = 0;
    testBegin = std::chrono::system_clock::now();
    
    // In our case, we cannot predict the exact size of the string, so we calculate it
    for(int i = 0; i < nbTests; i++)
        lengthTest5 += std::string(inputBuffer).length();
    resultTest5.reserve(lengthTest4);

    for(int i = 0; i < nbTests; i++)
        resultTest5.append(std::string(inputBuffer));
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";

    /////////////////////////////////////////////
    std::cout << "6th Test : stringstream" << std::endl;
    std::stringstream resultTest6;
    testBegin = std::chrono::system_clock::now();
    
    for(int i = 0; i < nbTests; i++)
        resultTest6 << std::string(inputBuffer);
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";
    
    /////////////////////////////////////////////
    std::cout << "7th Test : RopeString" << std::endl;
    RopeString resultTest7;
    testBegin = std::chrono::system_clock::now();
    
    for(int i = 0; i < nbTests; i++)
        resultTest7.append(std::string(inputBuffer));
    
    std::string * res7 = resultTest7.getString();
    
    testEnd = std::chrono::system_clock::now();
    std::cout << "\tDuration : " << std::chrono::duration<float, std::milli>(testEnd-testBegin).count() << "ms\n";

#endif // PROGRAM==_CONCAT_PERFS
    
#if PROGRAM==_CRC
    
    std::cout << Crc32Calculator::calculateCRC32(inputBuffer) << std::endl;
    
#endif // PROGRAM==_CRC

    return 0;
}

