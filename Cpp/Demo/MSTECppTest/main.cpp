//
//  main.cpp
//  MSTEncodDecodCpp
//
//  Created by Melodie on 23/10/12.
//  Copyright (c) 2012 Melodie. All rights reserved.
//


// LAST VERSION 
#include <iostream>
#include <sstream>
#include "MSTE.h"

int main(int argc, const char * argv[])
{
    
    /* ---- Encoder ----- */
    MSTEncodeur* encodeur = new MSTEncodeur();
    /*MSTETest* test = new MSTETest();
    test->encodeWithMSTEncodeur(encodeur);*/
    

    /* ---- Decoder ----- */
    MSTDecodeur* decodeur = new MSTDecodeur();
    stringstream ss;

    ss<<"[\"MSTE0101\",45,\"CRC00000000\",1,\"MSTETest\",7,\"Arraaaayy\",\"blabla\",\"Array\",\"color\",\"datata\",\"date\",\"string\",50,6,0,20,2,7,2200083711,8,1,1,6,1351586383,2,20,3,14,12,1,9,2,3,9,2,4,23,\"bcOpbG9kaWU=\",5,9,4,6,5,\"SomeT\\u00E9ext\"]";
    
    //ss<<"[\"MSTE0101\",41,\"CRC00000000\",1,\"MSTETest\",6,\"Arraaaayy\",\"blabla\",\"Array\",\"color\",\"date\",\"string\",50,5,0,20,2,7,65791,8,1,1,6,1353584979,2,20,3,14,12,1,9,2,3,9,2,4,9,4,5,5,\"SomeT\\u00E9ext\"]";
    
    //ss<< "[\"MSTE0101\",58,\"CRC00000000\",1,\"MSTETest\",9,\"Arraaaayy\",\"blabla\",\"Array\",\"NatArraaaayy\",\"color\",\"datata\",\"date\",\"string\",\"wcouplle\",50,8,0,20,2,7,16711680,8,1,1,6,1351612171,2,20,3,14,12,1,9,2,3,21,2,72,3,4,9,2,5,23,\"bcOpbG9kaWU=\",6,9,7,7,5,\"\\u00E0\\u00E9\\u00E8\\u00E7\\u00F4\\u00E2\",8,22,9,5,9,6]";    
   
    //ss<<"[\"MSTE0101\",12,\"CRC00000000\",1,\"MSTETest\",1,\"blabla\",50,1,0,23,\"bcOpbG9kaWU=\"]";
    
    //ss<<"[\"MSTE0101\",15,\"CRC00000000\",1,\"MSTETest\",1,\"Array\",50,1,0,20,2,14,12,1]";
    
    //ss<<"[\"MSTE0101\",29,\"CRC00000000\",1,\"MSTETest\",3,\"Arraaaayy\",\"blabla\",\"Array\",50,2,0,20,2,7,2200083711,8,1,1,6,1351601742,2,20,3,14,12,1,9,2]";
    
    //ss<<"[\"MSTE0101\",33,\"CRC00000000\",1,\"MSTETest\",4,\"Arraaaayy\",\"blabla\",\"Array\",\"date\",50,3,0,20,2,7,2200083711,8,1,1,6,1351602121,2,20,3,14,12,1,9,2,3,9,6]";
    
    //ss<<"[\"MSTE0101\",33,\"CRC00000000\",1,\"MSTETest\",4,\"Arraaaayy\",\"blabla\",\"Array\",\"string\",50,3,0,20,2,7,2200083711,8,1,1,6,1351602501,2,20,3,14,12,1,9,6,3,5,\"SomeT\\u00E9ext\"]";

    //ss<<"[\"MSTE0101\",33,\"CRC00000000\",1,\"MSTETest\",4,\"Arraaaayy\",\"blabla\",\"Array\",\"color\",50,3,0,20,2,7,2200083711,8,1,1,6,1351602650,2,20,3,14,12,1,9,4,3,9,6]";
    
    //ss<<"[\"MSTE0101\",50,\"CRC00000000\",2,\"MSTETest\",\"MSParent\",8,\"Array\",\"blèàabla\",\"date\",\"mere\",\"firstname\",\"name\",\"sex\",\"pere\",50,5,0,20,1,7,16711680,1,5,\"\\u00E0\\u00E9\\u00E8\\u00E7\\u00F4\\u00E2\",2,6,1.35418e+09,3,51,3,4,5,\"martin\",5,5,\"juliette\",6,2,7,51,3,4,5,\"robert\",5,5,\"lucien\",6,1]";
    
    //ss<<"[\"MSTE0101\",46,\"CRC00000000\",2,\"MSTETest\",\"MSParent\",6,\"Array\",\"firstname\",\"name\",\"sex\",\"blèàabla\",\"date\",50,3,0,20,3,7,16711680,51,3,1,5,\"robert\",2,5,\"lucien\",3,1,51,3,1,5,\"martin\",2,5,\"juliette\",3,2,4,5,\"\\u00E0\\u00E9\\u00E8\\u00E7\\u00F4\\u00E2\",5,6,1353584979]";
    
    string str(ss.str());
    const char* cstr1 = str.c_str();

    MSTEObject* obj = (MSTEObject*)decodeur->MSTDecodeRetainedObject(cstr1 , false);
    MSTETest* essai = new MSTETest(obj->getSnapshot());
    essai->encodeWithMSTEncodeur(encodeur);
    
    return 0;
}

