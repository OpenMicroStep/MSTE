package org.openmicrostep.mste;
//
//  MSTEEncoder.java
//
//
//
import java.util.ArrayList;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Set;
//import java.lang.reflect.*;
import java.util.Locale;

public class MSTEncoder {

private StringBuffer _content;
private StringBuffer _global;
private int _tokenCount;
private int _lastKeyIndex;
private int _lastClassIndex;
private int _lastReference;
private HashMap<String,Object> _keys;
private ArrayList<String> _keysArray;
private Hashtable<String,MSNode> _encodedObjects;
private HashMap<String,Integer> _classes;
private ArrayList<String> _classesArray;

final int MSTE_TOKEN_MUST_ENCODE						= -1;
final int MSTE_TOKEN_TYPE_NULL 							= 0;
final int MSTE_TOKEN_TYPE_TRUE							= 1;
final int MSTE_TOKEN_TYPE_FALSE							= 2;
final int MSTE_TOKEN_TYPE_INTEGER_VALUE					= 3;
final int MSTE_TOKEN_TYPE_REAL_VALUE					= 4;
final int MSTE_TOKEN_TYPE_STRING						= 5;
final int MSTE_TOKEN_TYPE_DATE							= 6;
final int MSTE_TOKEN_TYPE_COLOR							= 7;
final int MSTE_TOKEN_TYPE_DICTIONARY					= 8;
final int MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT	= 9;
final int MSTE_TOKEN_TYPE_CHAR							= 10;
final int MSTE_TOKEN_TYPE_UNSIGNED_CHAR					= 11;
final int MSTE_TOKEN_TYPE_SHORT							= 12;
final int MSTE_TOKEN_TYPE_UNSIGNED_SHORT				= 13;
final int MSTE_TOKEN_TYPE_INT32               			= 14;
final int MSTE_TOKEN_TYPE_INSIGNED_INT32      			= 15;
final int MSTE_TOKEN_TYPE_INT64               			= 16;
final int MSTE_TOKEN_TYPE_UNSIGNED_INT64      			= 17;
final int MSTE_TOKEN_TYPE_FLOAT               			= 18;
final int MSTE_TOKEN_TYPE_DOUBLE              			= 19;
final int MSTE_TOKEN_TYPE_ARRAY               			= 20;
final int MSTE_TOKEN_TYPE_NATURAL_ARRAY       			= 21;
final int MSTE_TOKEN_TYPE_COUPLE              			= 22;
final int MSTE_TOKEN_TYPE_BASE64_DATA         			= 23;
final int MSTE_TOKEN_TYPE_DISTANT_PAST        			= 24;
final int MSTE_TOKEN_TYPE_DISTANT_FUTURE      			= 25;
final int MSTE_TOKEN_TYPE_EMPTY_STRING        			= 26;
final int MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT   	= 27;
final int MSTE_TOKEN_TYPE_USER_CLASS        			= 50;

final int MSTE_TOKEN_LAST_DEFINED_TYPE = MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT;


// ========= constructors and destructors =========
public MSTEncoder() {}
public void finalize(){
	_content = null;
	_tokenCount = 0;
}

//=============Implements=============================
private void _encodeTokenSeparator(){
	_tokenCount++;
	_content.append(",");
}

private void _encodeTokenType(int tokenType){
	_content.append(tokenType);
}

private void encodeBool(Boolean b,  Boolean token){
	if (token){
		_encodeTokenSeparator();
		if (b){
			_encodeTokenType(MSTE_TOKEN_TYPE_TRUE);
		}
		else{
			_encodeTokenType(MSTE_TOKEN_TYPE_FALSE);
		}
	}
}

private void encodeBytes(byte[] tb, Boolean token){
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_BASE64_DATA);	
	}
	_encodeTokenSeparator();
	_content.append("\"");
	_content.append(encodeBase64(tb));
	_content.append("\"");
}
/*
private void encodeUnicodeString(String str, Boolean token) throws MSTEException {

	if (!str.equals(null)){
		if (token) {
			_encodeTokenSeparator();
			_encodeTokenType(MSTE_TOKEN_TYPE_STRING);	
		}
		_encodeTokenSeparator();
		_content.append("\"");
		int len = str.length();
		if (len>0){
			for (int i=0; i<len; i++){
				char c = str.charAt(i);
				switch ((int)c) {
					case 34 : 	//Double quote
						_content.append("\\\"");
						break;
					case 92 : 	//antislash
						_content.append("\\\\");
						break;
					case 47 : 	//slash
						_content.append("\\/");
						break;
					case 8 : 	//backspace
						_content.append("\\\b");
						break;
					case 12 : 	//formfeed
						_content.append("\\\f");
						break;
					case 10 : 	//newline
						_content.append("\\\n");
						break;
					case 13 : 	//carrage return
						_content.append("\\\r");
						break;
					case 9 : 	//tabulation
						_content.append("\\\t");
						break;
					default : 
						_content.append(c);
						break;
				}
			}			
		}
		_content.append("\"");
	}
	else{
		throw new MSTEException("encodeUnicodeString:withTokenType: no string to encode!");
	}
	
}
*/
private void encodeString(String str, Boolean token) throws MSTEException {
	if (!str.equals(null)){
		if (str.length()==0){
			_encodeTokenSeparator();
			_encodeTokenType(MSTE_TOKEN_TYPE_EMPTY_STRING);		
		}
		else{
			if (token) {
				_encodeTokenSeparator();
				_encodeTokenType(MSTE_TOKEN_TYPE_STRING);	
			}
			_encodeTokenSeparator();
			_content.append("\"");
			int len = str.length();		
			if (len>0){
				for (int i=0; i<len; i++){
					char c = str.charAt(i);
					switch ((int)c) {
						case 34 : 	//Double quote
							_content.append("\\\"");
							break;
						case 92 : 	//antislash
							_content.append("\\\\");
							break;
						case 47 : 	//slash
							_content.append("\\/");
							break;
						case 8 : 	//backspace
							_content.append("\\\b");
							break;
						case 12 : 	//formfeed
							_content.append("\\\f");
							break;
						case 10 : 	//newline
							_content.append("\\\n");
							break;
						case 13 : 	//carrage return
							_content.append("\\\r");
							break;
						case 9 : 	//tabulation
							_content.append("\\\t");
							break;
						default : 
							if ((c<32) || (c>127)) { //escape non printable ASCII characters with a 4 characters in UTF16 hexadecimal format (\UXXXX)
								byte b0 = (byte)((c & 0xF000)>>12);
								byte b1 = (byte)((c & 0x0F00)>>8);
								byte b2 = (byte)((c & 0x00F0)>>4);
								byte b3 = (byte)(c & 0x000F);
								_content.append("\\u");							
								_content.append(String.format("%X", b0));
								_content.append(String.format("%X", b1));
								_content.append(String.format("%X", b2));
								_content.append(String.format("%X", b3));							
							}
							else{
								_content.append(c);
							}
							break;
					}
				}			
			}
			_content.append("\"");
		}
	}
	else{
		throw new MSTEException("encodeString:withTokenType: no string to encode!");
	}
	
}


//encodeUnsignedChar type UnsignedChar does not exist in Java

private void encodeChar(Byte b, Boolean token){	//char = byte en Java

	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_CHAR);	
	}
	_encodeTokenSeparator();
	_content.append(String.format("%d", b));
}

private void encodeUnsignedShort(Character c, Boolean token){ //UnsignedShort = char en Java

	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_UNSIGNED_SHORT);	
	}
	_encodeTokenSeparator();
	_content.append(String.format("%u", c));
}

private void encodeShort(Short s, Boolean token){
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_SHORT);	
	}
	_encodeTokenSeparator();
	_content.append(String.format("%d", s));	
}

//encodeUnsignedInt type UnsignedInt does not exist in Java

private void encodeInt(Integer i, Boolean token){
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_INT32);	
	}
	_encodeTokenSeparator();
	_content.append(String.format("%d", i));	
}

//encodeUnsignedLongLong type UnsignedLong does not exist in Java

private void encodeLongLong(Long l, Boolean token){
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_INT64);	
	}
	_encodeTokenSeparator();
	_content.append(String.format("%d", l));	
}

private void encodeFloat(Float f, Boolean token){
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_FLOAT);	
	}
	_encodeTokenSeparator();
	//_content.append(String.format("%f", f));
	_content.append(String.format(Locale.US,"%.15f", f));
}

private void encodeDouble(Double d, Boolean token){
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_DOUBLE);	
	}
	_encodeTokenSeparator();
	_content.append(String.format(Locale.US,"%.15f", d));	
}

private void encodeIntValue(Object anObject, Boolean token) throws MSTEException{
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_INTEGER_VALUE);	
	}
	int tokenOrigin = getTokenType(anObject,true);
	Long l = new Long(0);
	switch (tokenOrigin){
		case MSTE_TOKEN_TYPE_CHAR:
			Byte bVal = (Byte)anObject;
			l = bVal.longValue();
			break;
		case MSTE_TOKEN_TYPE_UNSIGNED_SHORT:
			Character cVal = (Character)anObject;
			Integer codeCar = (Integer)Character.getNumericValue(cVal);
			l = codeCar.longValue();
			break;
		case MSTE_TOKEN_TYPE_SHORT:
			Short sVal = (Short)anObject;
			l = sVal.longValue();
			break;
		case MSTE_TOKEN_TYPE_INT32:
			Integer iVal = (Integer)anObject;
			l = iVal.longValue();
			break;
		case MSTE_TOKEN_TYPE_INT64:
			l = (Long)anObject;
			break;
		default:
			throw new MSTEException("encodeIntValue: not integer value for type MSTE_TOKEN_TYPE_INTEGER_VALUE !");
	}			
	_encodeTokenSeparator();
	_content.append(String.format("%d", l));	
}

private void encodeFloatValue(Object anObject, Boolean token) throws MSTEException{
	if (token) {
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_REAL_VALUE);	
	}
	int tokenOrigin = getTokenType(anObject,true);
	Double d = new Double(0);
	switch (tokenOrigin){
		case MSTE_TOKEN_TYPE_FLOAT:
			Float f = (Float)anObject;
			d = f.doubleValue();
			break;
		case MSTE_TOKEN_TYPE_DOUBLE:
			d = (Double)anObject;
			break;
		default:
			throw new MSTEException("encodeFloatValue: not float value for type MSTE_TOKEN_TYPE_REAL_VALUE !");
	}			
	_encodeTokenSeparator();
	_content.append(String.format(Locale.US,"%.15f", d));		
}


private void encodeArray(ArrayList anArray) throws MSTEException{
	_encodeTokenSeparator();
	_encodeTokenType(MSTE_TOKEN_TYPE_ARRAY);
	encodeInt(anArray.size(),false);
	Iterator it = anArray.iterator();
	while (it.hasNext()){
		Object o = (Object)it.next();
		encodeObject(o,false);
	}
}

private void encodeDate(java.util.Date d) {
	long t = d.getTime()/ 1000;	
	_encodeTokenSeparator();
	_encodeTokenType(MSTE_TOKEN_TYPE_DATE);
	_encodeTokenSeparator();
	_content.append(String.format("%d", t)); 
}

private void encodeColor(MSColor c) {
	_encodeTokenSeparator();
	_encodeTokenType(MSTE_TOKEN_TYPE_COLOR);
	_encodeTokenSeparator();
	//_content.append(c.toString());
	_content.append(String.valueOf(c.cssValue())); 
}

private void encodeCouple(MSCouple c) throws MSTEException{
	_encodeTokenSeparator();
	_encodeTokenType(MSTE_TOKEN_TYPE_COUPLE);	
	encodeObject(c.getFirstMember(),false);
	encodeObject(c.getSecondMember(),false);
}

private void encodeDictionary(HashMap aDictionary,Boolean isSnapshot) throws MSTEException{

	String theKey = "";
	ArrayList<Object> objects = new ArrayList<Object>();
	ArrayList<Object> keys = new ArrayList<Object>();
	Set tempKeys = aDictionary.keySet();
	Iterator it = tempKeys.iterator();
	if (isSnapshot){
		while (it.hasNext()) {
			theKey = (String)it.next();
			if (aDictionary.get(theKey)!=null){
				MSCouple o = (MSCouple)aDictionary.get(theKey);		
				keys.add(theKey);
				objects.add(o);
			}
		} 
	}
	else{
		_encodeTokenSeparator();
		_encodeTokenType(MSTE_TOKEN_TYPE_DICTIONARY);	
		//encodeInt(tempKeys.size() ,false);
		
		while (it.hasNext()) {
			theKey = (String)it.next();
			if (aDictionary.get(theKey)!=null){
				Object o = aDictionary.get(theKey);
				keys.add(theKey);
				objects.add(o);
			}
		} 		
	}
	int count = keys.size();
	encodeInt(count,false); 
	for (int i=0;i<count;i++){
		String stringKey = (String)keys.get(i);
		int keyReference = 0;
		if (!_keys.containsKey(stringKey)) {
			keyReference = ++_lastKeyIndex;
			_keys.put(stringKey, keyReference); 
			_keysArray.add(stringKey);
		} 
		keyReference = (Integer)_keys.get(stringKey);
		encodeInt(keyReference-1,false);
		if (isSnapshot){
			MSCouple o = (MSCouple) objects.get(i);
			Object weakReferenced = o.getSecondMember();
			if (weakReferenced!=null){
				encodeObject(o.getFirstMember(),isSnapshot);
			}
			else{
				encodeObject(o.getFirstMember(),isSnapshot);
			}
		}
		else{
			encodeObject(objects.get(i),isSnapshot);
		}
	}
	objects = null;
	keys = null;
	tempKeys = null;
}


private void encodeObject(Object anObject, Boolean isSnapshot) throws MSTEException  {
	Integer classIndex = 0;
	int objectReference = 0;
	
	int singleToken = getTokenType(anObject,isSnapshot);
	if (singleToken == MSTE_TOKEN_MUST_ENCODE) {
		throw new MSTEException("encodeObject:unknow token type !");
	}
	
	if (singleToken != MSTE_TOKEN_TYPE_USER_CLASS) {
		encodeWithTokenType(anObject,singleToken);
		if (singleToken != MSTE_TOKEN_TYPE_NULL){
			objectReference = ++_lastReference ;
			addObjectReference(anObject,objectReference);
		}
	}
	else{
		objectReference = getObjectReference(anObject);
		if (objectReference>0){
			_encodeTokenSeparator();
			_encodeTokenType(MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT);
			encodeInt(objectReference-1,false);				
		}
		else{
			
			//HashMap dictSnapshot = anObject.getSnapshot();
			HashMap dictSnapshot = null;
			if (anObject instanceof MSTEEncoderInterface){
/*				
				java.lang.reflect.Method method;
				try {
					method = anObject.getClass().getMethod("getSnapshot");					
				} catch (SecurityException e) {
					  throw new MSTEException("encodeObject:unknow SecurityException : " + e.toString());
				} catch (NoSuchMethodException e) {
					  throw new MSTEException("encodeObject:unknow NoSuchMethodException : " + e.toString());
				}
				
				try {
					dictSnapshot = (HashMap)method.invoke(anObject);
				} catch (IllegalArgumentException e) {
					throw new MSTEException("encodeObject:unknow IllegalArgumentException : " + e.toString());
				} catch (IllegalAccessException e) {
					throw new MSTEException("encodeObject:unknow IllegalAccessException : " + e.toString());
				} catch (InvocationTargetException e) {
					throw new MSTEException("encodeObject:unknow InvocationTargetException : " + e.toString());
				}
*/				
				dictSnapshot=(HashMap)((MSTEEncoderInterface)anObject).getSnapshot();
			}

			String aClassName = anObject.getClass().getName();
			classIndex = _classes.get(aClassName);
			if (_classes.containsKey(aClassName)){
				classIndex = _classes.get(aClassName);
			}
			else{
				classIndex = ++_lastClassIndex ;
				_classes.put(aClassName,classIndex);
				_classesArray.add(aClassName);
			}			
			objectReference = ++_lastReference ;
			addObjectReference(anObject,objectReference);
			_encodeTokenSeparator();
			_encodeTokenType(MSTE_TOKEN_TYPE_USER_CLASS + 2*(classIndex-1));
			encodeDictionary(dictSnapshot,true);
						
		}	
	}	
}


public byte[] encodeRootObject(Object anObject) throws MSTEException  {
	_content = new StringBuffer();
	_tokenCount = 0;
	_lastKeyIndex = 0;
	_lastReference = 0;
	_lastClassIndex = 0;
	_keysArray = new ArrayList<String>();
	_keys = new HashMap<String,Object>();
	_encodedObjects = new Hashtable<String,MSNode>();

	_classes = new HashMap<String,Integer>() ;
	_classesArray = new ArrayList<String>();	
	
	_global = new StringBuffer(); 
	
	encodeObject(anObject,false);
	
	//MSTE header
	_global.append("[\"MSTE0101\",");
	_global.append(5 + _lastKeyIndex + _lastClassIndex + _tokenCount);
	_global.append(",\"CRC");
	_global.append("00000000\",");
	
	//Classes list
	_global.append(_classesArray.size());
	Iterator<String> itClass = _classesArray.iterator();
 	while(itClass.hasNext()){
		_global.append(",");
		_encodeGlobalUnicodeString(itClass.next());
 	}
	
	//Keys list
	_global.append(",");
	_global.append(_keysArray.size());
	Iterator<String> itKeys = _keysArray.iterator();
 	while(itKeys.hasNext()){
		_global.append(",");
		_encodeGlobalUnicodeString(itKeys.next());
 	}
	
	_global.append(_content);
	_global.append("]");
	
	String aCRC = MSCRC32.getCRC(_global.toString());	
	int posCRC = _global.indexOf("CRC");
	_global.replace(posCRC+3,posCRC+11,aCRC);
	byte[] b = null ;
	try{
		b = _global.toString().getBytes();		
	}catch (Exception e){
		throw new MSTEException("encodeRootObject:unable to convert in US-ASCII !");
	}
	
	return b;
}

private void _encodeGlobalUnicodeString(String str){
	if (!str.equals(null)){
		int len = str.length();
		_global.append("\"");
		if (len>0){
			for (int i=0; i<len; i++){
				char c = str.charAt(i);
				switch ((int)c) {
					case 9 : {	//\t
						_global.append("\\");
						_global.append("t");
						break;
					}
					case 10 : {	//\n
						_global.append("\\");
						_global.append("n");
						break;
					}
					case 13 : {	//\r
						_global.append("\\");
						_global.append("r");
						break;
					}
					case 34 : {	//\"
						_global.append("\\");
						_global.append('"');
						break;
					}
					case 92 : {	//antislash
						_global.append("\\");
						_global.append("\\");
						break;
					}
					case 47 : {	//slash
						_global.append("\\");
						_global.append("/");
						break;
					}
					default : {
						_global.append(c);						
						break;
					}
				}
			}			
		}	
		_global.append("\"");		
	}
}
private int getTokenType(Object anObject, Boolean isSnapshot){

	if (anObject == null){return MSTE_TOKEN_TYPE_NULL;}	

	if (anObject instanceof Boolean) {
		if ((Boolean)anObject) {return MSTE_TOKEN_TYPE_TRUE;}else{return MSTE_TOKEN_TYPE_FALSE;}
	}
	if (anObject instanceof byte[]) {return MSTE_TOKEN_TYPE_BASE64_DATA;}
	if (anObject instanceof String) {
		String str = anObject.toString() ;
		if (str.length()>0) {
			return MSTE_TOKEN_TYPE_STRING;
		}
		else{
			return MSTE_TOKEN_TYPE_EMPTY_STRING;
		}
	}
	if (anObject instanceof Byte){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_CHAR;}
			else {return MSTE_TOKEN_TYPE_INTEGER_VALUE;}
	}
	if (anObject instanceof Character){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_UNSIGNED_SHORT;}
			else {return MSTE_TOKEN_TYPE_INTEGER_VALUE;}
	}
	if (anObject instanceof Short){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_SHORT;}
			else {return MSTE_TOKEN_TYPE_INTEGER_VALUE;}
	}
	if (anObject instanceof Integer){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_INT32;}
			else {return MSTE_TOKEN_TYPE_INTEGER_VALUE;}
	}
	if (anObject instanceof Long){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_INT64;}
			else {return MSTE_TOKEN_TYPE_INTEGER_VALUE;}
	}			
	if (anObject instanceof Float){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_FLOAT;}
			else {return MSTE_TOKEN_TYPE_REAL_VALUE;}
	}
	if (anObject instanceof Double){
		if (isSnapshot) {return MSTE_TOKEN_TYPE_DOUBLE;}
			else {return MSTE_TOKEN_TYPE_REAL_VALUE;}
	}		
		
	if (anObject instanceof java.util.AbstractCollection){return MSTE_TOKEN_TYPE_ARRAY;}
	if (anObject instanceof java.util.Date){return MSTE_TOKEN_TYPE_DATE;}
	if (anObject instanceof MSColor){return MSTE_TOKEN_TYPE_COLOR;}
	if (anObject instanceof java.util.Map){return MSTE_TOKEN_TYPE_DICTIONARY;}
	if (anObject instanceof MSCouple){return MSTE_TOKEN_TYPE_COUPLE;}
	
	if (anObject instanceof MSTEEncoderInterface){return MSTE_TOKEN_TYPE_USER_CLASS;}
	
	return MSTE_TOKEN_MUST_ENCODE;
}

private void encodeWithTokenType(Object anObject, int tokenType) throws MSTEException {

	switch (tokenType){
		case MSTE_TOKEN_TYPE_NULL:
			_encodeTokenSeparator();
			_encodeTokenType(tokenType);
			break;
		case MSTE_TOKEN_TYPE_TRUE:
			encodeBool((Boolean)anObject, true);
			break;
		case MSTE_TOKEN_TYPE_FALSE:
			encodeBool((Boolean)anObject, true);
			break;
		case MSTE_TOKEN_TYPE_BASE64_DATA:
			encodeBytes((byte[])anObject, true);
			break;
		case MSTE_TOKEN_TYPE_STRING:
			//encodeUnicodeString((String)anObject, true);
			encodeString((String)anObject, true);
			break;
		case MSTE_TOKEN_TYPE_EMPTY_STRING:
			_encodeTokenSeparator();
			_encodeTokenType(tokenType);
			break;
		case MSTE_TOKEN_TYPE_CHAR:
			encodeChar((Byte) anObject, true);
			break;
		case MSTE_TOKEN_TYPE_UNSIGNED_SHORT:
			encodeUnsignedShort((Character) anObject, true);
			break;
		case MSTE_TOKEN_TYPE_SHORT:
			encodeShort((Short) anObject, true);
			break;
		case MSTE_TOKEN_TYPE_INT32:
			encodeInt((Integer) anObject, true);
			break;
		case MSTE_TOKEN_TYPE_INT64:
			encodeLongLong((Long) anObject, true);
			break;
		case MSTE_TOKEN_TYPE_INTEGER_VALUE:
			encodeIntValue(anObject,true);
			break;
		case MSTE_TOKEN_TYPE_REAL_VALUE:
			encodeFloatValue(anObject,true);
			break;
		case MSTE_TOKEN_TYPE_FLOAT:
			encodeFloat((Float) anObject, true);
			break;
		case MSTE_TOKEN_TYPE_DOUBLE:
			encodeDouble((Double)anObject, true);
			break;
		case MSTE_TOKEN_TYPE_ARRAY:
			encodeArray((ArrayList) anObject);
			break;
		case MSTE_TOKEN_TYPE_DATE:
			encodeDate((java.util.Date) anObject);
			break;
		case MSTE_TOKEN_TYPE_COLOR:
			encodeColor((MSColor) anObject);
			break; 
		case MSTE_TOKEN_TYPE_DICTIONARY:
			encodeDictionary((HashMap) anObject,false);
			break; 
		case MSTE_TOKEN_TYPE_COUPLE:
			encodeCouple((MSCouple) anObject);
			break;
		default:
			throw new MSTEException("encodeWithTokenType:unknow token type !");
			
	}
}


private int getObjectReference(Object anObject){
	
	int ref = -1;
	String objHashCode = String.valueOf(anObject.hashCode());
	if (_encodedObjects.containsKey(objHashCode)){
		MSNode node = (MSNode)_encodedObjects.get(objHashCode);
		if (anObject==node.getFirstMember()){
			ref=node.getReference();
		}
	} 
	return ref;
}

private void addObjectReference(Object anObject, int ref){
	
	String objHashCode = String.valueOf(anObject.hashCode());
	MSNode node = new MSNode();
	node.setFirstMember(anObject);
	node.setReference(ref);
	_encodedObjects.put(objHashCode,node);
	
}

private static final String base64code = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            + "abcdefghijklmnopqrstuvwxyz" + "0123456789" + "+/";

private static byte[] zeroPad(int length, byte[] bytes) {
	        byte[] padded = new byte[length]; // initialized to zero by JVM
	        System.arraycopy(bytes, 0, padded, 0, bytes.length);
	        return padded;
	    }

private String encodeBase64(byte[] bArray){
	String encoded = "";
	
	int paddingCount = (3 - (bArray.length % 3)) % 3;
	       
	bArray = zeroPad(bArray.length + paddingCount, bArray);

	for (int i = 0; i < bArray.length; i += 3) {
		int j = ((bArray[i] & 0xff) << 16) +
	           	((bArray[i + 1] & 0xff) << 8) + 
	            (bArray[i + 2] & 0xff);
	     encoded = encoded + base64code.charAt((j >> 18) & 0x3f) +
	        	base64code.charAt((j >> 12) & 0x3f) +
	            base64code.charAt((j >> 6) & 0x3f) +
	            base64code.charAt(j & 0x3f);
	}

	return encoded;

}

}
