//
//  main.m
//  MSTEDemo
//
//  Created by Melodie on 28/01/13.
//  Copyright (c) 2013 Logitud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSTEncoder/MSTEncoder.h>
#import <MSTEncoder/MSTDecoder.h>


int main(int argc, const char * argv[])
{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init] ;
    
    //Encodage puis decodage    
    NSString *aString = @"unechainemélodie^^";
    NSNumber *aNumber = [NSNumber numberWithInt:12];
    NSNumber *aBool = [NSNumber numberWithBool:YES];
    NSArray *anArray = [NSArray arrayWithObjects:aString,aNumber,aBool,nil];
    
    NSData* aData=[anArray MSTEncodedBuffer];
    id encodeDecode=[aData MSTDecodedObjectAndVerifyCRC:YES];
    
    
 
    //Test decodage d'une chaine
    NSString *myString = @"[\"MSTE0101\",45,\"CRC00000000\",1,\"MSTETest\",7,\"Arraaaayy\",\"blabla\",\"Array\",\"color\",\"datata\",\"date\",\"string\",50,6,0,20,2,7,2200083711,8,1,1,6,1351586383,2,20,3,14,12,1,9,2,3,9,2,4,23,\"bcOpbG9kaWU=\",5,9,4,6,5,\"SomeT\\u00E9ext\"]";

    
    NSData *myData = [myString dataUsingEncoding:NSUTF8StringEncoding];
    id decode=[myData MSTDecodedObject];    

       
    NSLog(@"decodage après encodage %@", encodeDecode);
    NSLog(@"decodage autre chaine %@", decode);
    

    [pool release] ;
    return 0;
}

