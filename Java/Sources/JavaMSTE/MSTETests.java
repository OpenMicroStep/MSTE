package org.openmicrostep.mste;
//
//  MSTETests.java
//
//  
//
import java.util.HashMap;
import java.util.Calendar;
import java.util.Date;
import java.util.ArrayList;
import java.io.*;

public class MSTETests{
	// ========= constructors and destructors =========
	public MSTETests() {}
	public void finalize(){}

	public static void main(String args[]){
 
		//testLstPersons();
	
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/MSTE0.txt");
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/MSTE1.txt");
		testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/sampletestJS.txt");
		
		//testColor();
	
	}

	private static void testColor(){
		try{
				
			MSRGBAColor aCol = new MSRGBAColor();
			//aCol.initWithRGB(125,125,125);
			//aCol.initWithRGB(0,0,0);
			//aCol.initWithRGB(255,255,255);
			//aCol.initWithRGB(255,255,256); //return error
			aCol.initWithString("73A3D4");
			
			MSRGBAColor aCol2 = new MSRGBAColor();
			aCol2.initWithColor(aCol);
			//aCol2.initWithCSSValue(aCol.cssValue());
		
			System.out.println("Color string value =" + aCol2.toString());
			System.out.println("Red="+aCol2.red());
			System.out.println("Green="+aCol2.green());
			System.out.println("Bleue="+aCol2.blue());
			System.out.println("Opacity="+aCol2.opacity());
			System.out.println("Transparency="+aCol2.transparency());
			System.out.println("Red Component="+aCol2.redComponent());
			System.out.println("Green Component="+aCol2.greenComponent());
			System.out.println("Blue Component="+aCol2.blueComponent());
			System.out.println("Alpha Component="+aCol2.alphaComponent());
			System.out.println("Cyan Component="+aCol2.cyanComponent());
			System.out.println("Magenta Component="+aCol2.magentaComponent());
			System.out.println("Yellow Component="+aCol2.yellowComponent());
			System.out.println("Black Component="+aCol2.blackComponent());
			System.out.println("RGBA Value="+aCol2.rgbaValue());
			System.out.println("Is pale color ?="+aCol2.isPaleColor());
			System.out.println("Luminance="+aCol2.luminance());
			System.out.println("Lighter color R="+aCol2.lighterColor().red() + " G=" + aCol2.lighterColor().green() + " B=" + aCol2.lighterColor().blue());
			System.out.println("Darker color R="+aCol2.darkerColor().red() + " G=" + aCol2.darkerColor().green() + " B=" + aCol2.darkerColor().blue());
			System.out.println("Lightest color R="+aCol2.lightestColor().red() + " G=" + aCol2.lightestColor().green() + " B=" + aCol2.lightestColor().blue());
			System.out.println("Darkest color R="+aCol2.darkestColor().red() + " G=" + aCol2.darkestColor().green() + " B=" + aCol2.darkestColor().blue());
			System.out.println("Matching Visible Color R="+aCol2.matchingVisibleColor().red() + " G=" + aCol2.matchingVisibleColor().green() + " B=" + aCol2.matchingVisibleColor().blue());
			System.out.println("Color With alpha R="+aCol2.colorWithAlpha(50).red() + " G=" + aCol2.colorWithAlpha(50).green() + " B=" + aCol2.colorWithAlpha(50).blue());
			System.out.println("Color Is Equal to color object ="+aCol2.isEqualToColorObject(aCol2));
			aCol2=(MSRGBAColor)aCol.darkerColor();
			System.out.println("Color compare to ="+aCol2.compareToColorObject(aCol));
					
			
		}catch (Exception e){
			System.out.println("Error in  testColor : " + e.toString());
		}
		
		
	}
	private static void testLstPersons(){
		Calendar cal = Calendar.getInstance();
		Date dt;
		byte[] res = null;
		try {
			ArrayList<Person> lstPersons = new ArrayList<Person>();
			Person p1 = new Person();
			lstPersons.add(p1);
			Person p2 = new Person();
			lstPersons.add(p2);
			Person p3 = new Person();
			lstPersons.add(p3);

			p1.setName("Durand");
			p1.setFirstName("Yves");
			cal.set(1962, 3, 11); //year is as expected, month is zero based, date is as expected
			dt = cal.getTime();
			p1.setBirtday(dt);
		/*	
			p1.setMariedTo(p2);
			p1.setFather(null);
			p1.setMother(null);
		*/	
			p2.setName("Durand");
			p2.setFirstName("Claire");
			cal.set(1963, 5, 7); //year is as expected, month is zero based, date is as expected
			dt = cal.getTime();
			p2.setBirtday(dt);
		/*
			p2.setMariedTo(p1);
			p2.setFather(null);
			p2.setMother(null);
		*/
			p3.setName("Durand");
			p3.setFirstName("Lou");
			cal.set(1987, 6, 1); //year is as expected, month is zero based, date is as expected
			dt = cal.getTime();
			p3.setBirtday(dt);
		/*
			p3.setMariedTo(null);
			p3.setFather(p1);
			p3.setMother(p2);
		*/	
			MSTEEncoder encoder = new MSTEEncoder();
			res = encoder.encodeRootObject(lstPersons);

		//res = "[\"MSTE0101\",59,\"CRCC41DBEF3\",1,\"org.openmicrostep.mste.Person\",6,\"name\",\"firstName\",\"birthday\",\"maried-to\",\"father\",\"mother\",20,3,50,4,0,5,\"Durand\",1,5,\"Yves\",2,6,-1222131600,3,51,4, 0,9,2,1,5,\"Claire\",2,6,-1185667200,3,27,1,9,5,50,5,0,9,2,1,5,\"Lou\",2,6,-426214800,4,9,1,5,9,5]".getBytes();
		}catch (Exception e){
			System.out.println("Error in  testLstPersons : " + e.toString());
		}

	}

	private static void testMSTEFile(String filename){
		
		MSTEEncoder encoder = new MSTEEncoder();
		MSTEDecoder decoder = new MSTEDecoder();
		byte[] res = null;
		try {
			//*************************************************************************************
			//First encode object from text file
			int ch;
			File file = new File(filename);
			StringBuffer strContent = new StringBuffer("");
			FileInputStream fin = null;
			fin = new FileInputStream(file);
			while( (ch = fin.read()) != -1)
			        strContent.append((char)ch);
			res = String.valueOf(strContent).getBytes();

			HashMap<String,String>nameSpace = new HashMap<String,String>();
			nameSpace.put("XVar","org.openmicrostep.mste.XVar");
			Object theObj = decoder.decodeObject(res,true,true,nameSpace);

			//Write object
			String newFilename = filename.replace(".txt","_object1.txt");
			FileWriter fstream = new FileWriter(newFilename);
		  	BufferedWriter out = new BufferedWriter(fstream);
		  	out.write(theObj.toString());
		  	out.close();
			System.out.println("Write object 1");
			//********************** end first encode ***********************************************************

			//**********************************************************************************************
			//Decode object to file text
			res = encoder.encodeRootObject(theObj);
			String s = new String(res);
			//Write string mste
			newFilename = filename.replace(".txt","_MSTEString1.txt");
			FileWriter fstream2 = new FileWriter(newFilename);
		  	BufferedWriter out2 = new BufferedWriter(fstream2);
		  	out2.write(s);
		  	out2.close();
			System.out.println("Write MSTE String V1");
			//************** End decode object *********************************************************

			//*****************************************************************************************
			//Re-encode from second file text generate
			Object theObj2 = decoder.decodeObject(res,true,true,nameSpace);
			//Write object
			System.out.println("decode obj2");
			newFilename = filename.replace(".txt","_object2.txt");
			FileWriter fstream3 = new FileWriter(newFilename);
		  	BufferedWriter out3 = new BufferedWriter(fstream3);
		  	out3.write(theObj2.toString());
		  	out3.close();
			System.out.println("Write object 2");
			//*****End reencode ****************************************************************************

			//****************************
			//encode second object to text file 
			res = encoder.encodeRootObject(theObj2);
			//Write string mste
			newFilename = filename.replace(".txt","_MSTEString2.txt");
			FileWriter fstream4 = new FileWriter(newFilename);
		  	BufferedWriter out4 = new BufferedWriter(fstream4);
		  	out4.write(s);
		  	out4.close();
			System.out.println("Write MSTE String V2");
			//**********************************************************************************

		}catch (Exception e){
			System.out.println("Error in  testMSTEFile : " + e.toString());
		}
		
	}

}
 


