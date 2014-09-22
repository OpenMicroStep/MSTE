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
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/sampletestJS.txt");
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/MSTEV0102_test1.txt");
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/MSTEV0102_test7.txt");
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/MSTEV0102_test8.txt");
		//testMSTEFile("/Users/Shared/Developer/MSTE/Java/Demo/MSTE_Person.txt");
		
		//testColor();
		String outFilename ="";
		String msteString = "";
		
	
		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode1.txt";
		msteString = "[\"MSTE0102\",6,\"CRC9B5A0F31\",0,0,1]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode2.txt";
		msteString = "[\"MSTE0102\",6,\"CRCB0775CF2\",0,0,2]";		
		testMSTEString(outFilename,msteString);
		
		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode3.txt";
		msteString = "[\"MSTE0102\",6,\"CRCA96C6DB3\",0,0,3]";		
		testMSTEString(outFilename,msteString);
		
		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode4.txt";
		msteString = "[\"MSTE0102\",6,\"CRCE62DFB74\",0,0,4]";		
		testMSTEString(outFilename,msteString);
		
		
		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode10To19.txt";
		msteString = "[\"MSTE0102\",94,\"CRC1BB6B687\",1,\"SimpleTypesContainer\",22,\"_char\",\"_float\",\"_byte\",\"_byteNumber\",\"_shortNumber\",\"_charNumber\",\"_floatNumber\",\"_longNumber\",\"_ushort\",\"_ushortNumber\",\"_int\",\"_ulong\",\"_uint\",\"_intNumber\",\"_short\",\"_double\",\"_bool\",\"_uintNumber\",\"_long\",\"_ulongNumber\",\"_doubleNumber\",\"_boolNumber\",50,22,0,10,-1,1,18,12.340000,2,12,1,3,20,10,4,20,-20,5,20,-10,6,20,-120.500000,7,20,-40,8,14,2,9,20,20,10,14,-3,11,16,4,12,16,3,13,20,-30,14,12,-2,15,19,125.750000000000000,16,1,17,20,30,18,16,-4,19,20,40,20,20,1230.500000000000000,21,2]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode20.txt";
		msteString = "[\"MSTE0102\",7,\"CRCBF421375\",0,0,20,12.34]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode21.txt";
		msteString = "[\"MSTE0102\",7,\"CRC09065CB6\",0,0,21,\"My beautiful string \\u00E9\\u00E8\"]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode22.txt";
		msteString = "[\"MSTE0102\",7,\"CRC093D5173\",0,0,22,978307200]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode23.txt";
		msteString = "[\"MSTE0102\",7,\"CRCFDED185D\",0,0,23,978307200.000000000000000]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode24.txt";
		msteString = "[\"MSTE0102\",7,\"CRCAB284946\",0,0,24,4034942921]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode25.txt";
		msteString = "[\"MSTE0102\",7,\"CRC4964EA3B\",0,0,25,\"YTF6MmUzcjR0NA==\"]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode26.txt";
		msteString = "[\"MSTE0102\",8,\"CRCD6330919\",0,0,26,1,256]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode30.txt";
		msteString = "[\"MSTE0102\",15,\"CRC891261B3\",0,2,\"key1\",\"key2\",30,2,0,21,\"First object\",1,21,\"Second object\"]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode31.txt";
		msteString = "[\"MSTE0102\",11,\"CRC1258D06E\",0,0,31,2,21,\"First object\",21,\"Second object\"]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode32.txt";
		msteString = "[\"MSTE0102\",10,\"CRCF8392337\",0,0,32,21,\"First member\",21,\"Second member\"]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode50.txt";
		msteString = "[\"MSTE0102\",59,\"CRCBB46D817\",1,\"Person\",6,\"firstname\",\"maried-to\",\"name\",\"birthday\",\"mother\",\"father\",31,3,50,4,0,21,\"Yves\",1,50,4,0,21,\"Claire\",1,9,1,2,21,\"Durand\",3,23,-207360000.000000000000000,2,9,5,3,23,-243820800.000000000000000,9,3,50,5,0,21,\"Lou\",4,9,3,2,9,5,3,23,552096000.000000000000000,5,9,1]";		
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCodeSup50.txt";
		msteString = "[\"MSTE0102\",34,\"CRC7403EC23\",2,\"Person\",\"SubPerson\",3,\"name\",\"firstname\",\"birthday\",31,2,50,3,0,21,\"Durand\",1,21,\"Yves\",2,23,-243820800.000000000000000,51,3,0,21,\"Dupond\",1,21,\"Ginette\",2,23,-207360000.000000000000000]";
		testMSTEString(outFilename,msteString);

		outFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTETestCode9.txt";
		msteString = "[\"MSTE0102\",11,\"CRC32766EEF\",0,0,31,2,21,\"multiple referenced object\",9,1]";
		testMSTEString(outFilename,msteString);


	
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
			
			p1.setMariedTo(p2);
		/*
			p1.setFather(null);
			p1.setMother(null);
		*/	
			p2.setName("Durand");
			p2.setFirstName("Claire");
			cal.set(1963, 5, 7); //year is as expected, month is zero based, date is as expected
			dt = cal.getTime();
			p2.setBirtday(dt);
		
			p2.setMariedTo(p1);
		/*
			p2.setFather(null);
			p2.setMother(null);
		*/
			p3.setName("Durand");
			p3.setFirstName("Lou");
			cal.set(1987, 6, 1); //year is as expected, month is zero based, date is as expected
			dt = cal.getTime();
			p3.setBirtday(dt);

			p3.setFather(p1);
			p3.setMother(p2);

		/*
			p3.setMariedTo(null);
			p3.setFather(p1);
			p3.setMother(p2);
		*/	
			MSTEncoder encoder = new MSTEncoder();
			res = encoder.encodeRootObject(lstPersons);
			String s = new String(res);
			//Write string mste
			String newFilename = "/Users/Shared/Developer/MSTE/Java/Demo/MSTE_Person.txt";
			FileWriter fstream2 = new FileWriter(newFilename);
		  	BufferedWriter out2 = new BufferedWriter(fstream2);
		  	out2.write(s);
		  	out2.close();
			System.out.println("Write MSTE String Person");

		//res = "[\"MSTE0101\",59,\"CRCC41DBEF3\",1,\"org.openmicrostep.mste.Person\",6,\"name\",\"firstName\",\"birthday\",\"maried-to\",\"father\",\"mother\",20,3,50,4,0,5,\"Durand\",1,5,\"Yves\",2,6,-1222131600,3,51,4, 0,9,2,1,5,\"Claire\",2,6,-1185667200,3,27,1,9,5,50,5,0,9,2,1,5,\"Lou\",2,6,-426214800,4,9,1,5,9,5]".getBytes();
		}catch (Exception e){
			System.out.println("Error in  testLstPersons : " + e.toString());
		}

	}


	private static void testMSTEString(String outFilename,String msteString){		
		MSTDecoder decoder = new MSTDecoder();
		MSTEncoder encoder = new MSTEncoder();
		try {
			byte[] res = null;
			StringBuffer strContent = new StringBuffer(msteString);
			
			System.out.println("Decoding 1... " + msteString);
			
			res = String.valueOf(strContent).getBytes();
			HashMap<String,String>nameSpace = new HashMap<String,String>();
			nameSpace.put("Person","org.openmicrostep.mste.Person");
			nameSpace.put("SubPerson","org.openmicrostep.mste.SubPerson");
			Object theObj = decoder.decodeObject(res,false,true,nameSpace);	
			System.out.println("Decode Ok Object Class =" + theObj.getClass().getName());
						
			//Write object
			FileWriter fstream = new FileWriter(outFilename);
  			BufferedWriter out = new BufferedWriter(fstream);
  			out.write(theObj.toString());
  			out.flush();
	
			out.newLine();
			out.write("Original MSTE String :");
			out.newLine();
			out.write(msteString);
			out.newLine();
			out.flush();
			
			System.out.println("Encoding 1... ");
			res = encoder.encodeRootObject(theObj);
			String s = new String(res);
			out.write(s);
			out.flush();
			
			out.newLine();
			System.out.println("Decoding 2 ... " + s) ;
			Object theObj2 = decoder.decodeObject(res,true,true,nameSpace);
			System.out.println("Encoding 2... ");
			res = encoder.encodeRootObject(theObj2);
			s = new String(res);
			out.write(s);
			out.flush();

			out.newLine();
			System.out.println("Decoding 3 ..." + s);
			Object theObj3 = decoder.decodeObject(res,true,true,nameSpace);
			System.out.println("Encoding 3... ");
			res = encoder.encodeRootObject(theObj3);
			s = new String(res);
			out.write(s);
			out.flush();
			
			out.close();
			
			
		}catch (Exception e){
			System.out.println("Error in  testMSTEString : " + e.toString());
		}
	}

	private static void testMSTEFile(String filename){
		
		MSTEncoder encoder = new MSTEncoder();
		MSTDecoder decoder = new MSTDecoder();
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
			//nameSpace.put("XVar","org.openmicrostep.mste.XVar");
			nameSpace.put("Person","org.openmicrostep.mste.Person");
			
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
 


