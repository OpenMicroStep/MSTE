using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;

namespace MSTEClasses {
    public class MSTEEncoder {

        private bool InstanceFieldsInitialized = false;

        private void InitializeInstanceFields() {
            MSTE_TOKEN_LAST_DEFINED_TYPE = MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT;
        }


        private StringBuilder _content;
        private StringBuilder _global;
        private int _tokenCount;
        private int _lastKeyIndex;
        private int _lastClassIndex;
        private int _lastReference;
        private Dictionary<string, object> _keys;
        private List<string> _keysArray;
        //private Dictionary<string, MSNode> _encodedObjects;
        private Dictionary<int, object> _encodedObjects;
        private Dictionary<string, int> _classes;
        private List<string> _classesArray;

        const int MSTE_TOKEN_MUST_ENCODE = -1;
        const int MSTE_TOKEN_TYPE_NULL = 0;
        const int MSTE_TOKEN_TYPE_TRUE = 1;
        const int MSTE_TOKEN_TYPE_FALSE = 2;
        const int MSTE_TOKEN_TYPE_INTEGER_VALUE = 3;
        const int MSTE_TOKEN_TYPE_REAL_VALUE = 4;
        const int MSTE_TOKEN_TYPE_STRING = 5;
        const int MSTE_TOKEN_TYPE_DATE = 6;
        const int MSTE_TOKEN_TYPE_COLOR = 7;
        const int MSTE_TOKEN_TYPE_DICTIONARY = 8;
        const int MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT = 9;
        const int MSTE_TOKEN_TYPE_CHAR = 10;
        const int MSTE_TOKEN_TYPE_UNSIGNED_CHAR = 11;
        const int MSTE_TOKEN_TYPE_SHORT = 12;
        const int MSTE_TOKEN_TYPE_UNSIGNED_SHORT = 13;
        const int MSTE_TOKEN_TYPE_INT32 = 14;
        const int MSTE_TOKEN_TYPE_INSIGNED_INT32 = 15;
        const int MSTE_TOKEN_TYPE_INT64 = 16;
        const int MSTE_TOKEN_TYPE_UNSIGNED_INT64 = 17;
        const int MSTE_TOKEN_TYPE_FLOAT = 18;
        const int MSTE_TOKEN_TYPE_DOUBLE = 19;
        const int MSTE_TOKEN_TYPE_ARRAY = 20;
        const int MSTE_TOKEN_TYPE_NATURAL_ARRAY = 21;
        const int MSTE_TOKEN_TYPE_COUPLE = 22;
        const int MSTE_TOKEN_TYPE_BASE64_DATA = 23;
        const int MSTE_TOKEN_TYPE_DISTANT_PAST = 24;
        const int MSTE_TOKEN_TYPE_DISTANT_FUTURE = 25;
        const int MSTE_TOKEN_TYPE_EMPTY_STRING = 26;
        const int MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT = 27;
        const int MSTE_TOKEN_TYPE_USER_CLASS = 50;

        internal int MSTE_TOKEN_LAST_DEFINED_TYPE;


        // ========= constructors and destructors =========
        public MSTEEncoder() {
            if (!InstanceFieldsInitialized) {
                InitializeInstanceFields();
                InstanceFieldsInitialized = true;
            }
        }
        ~MSTEEncoder() {
            _content = null;
            _tokenCount = 0;
        }

        //=============Implements=============================
        private void _encodeTokenSeparator() {
            _tokenCount++;
            _content.Append(",");
        }

        private void _encodeTokenType(int tokenType) {
            _content.Append(tokenType);
        }

        private void encodeBool(bool b, bool token) {
            if (token) {
                _encodeTokenSeparator();
                if (b) {
                    _encodeTokenType(MSTE_TOKEN_TYPE_TRUE);
                }
                else {
                    _encodeTokenType(MSTE_TOKEN_TYPE_FALSE);
                }
            }
        }

        private void encodeBytes(sbyte[] tb, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_BASE64_DATA);
            }
            _encodeTokenSeparator();
            _content.Append("\"");
            _content.Append(encodeBase64(tb));
            _content.Append("\"");
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

        private void encodeString(string str, bool token) {
            if (!str.Equals(null)) {
                if (str.Length == 0) {
                    _encodeTokenSeparator();
                    _encodeTokenType(MSTE_TOKEN_TYPE_EMPTY_STRING);
                }
                else {
                    if (token) {
                        _encodeTokenSeparator();
                        _encodeTokenType(MSTE_TOKEN_TYPE_STRING);
                    }
                    _encodeTokenSeparator();
                    _content.Append("\"");
                    int len = str.Length;
                    if (len > 0) {
                        for (int i = 0; i < len; i++) {
                            char c = str[i];
                            switch ((int)c) {
                                case 34: //Double quote
                                    _content.Append("\\\"");
                                    break;
                                case 92: //antislash
                                    _content.Append("\\\\");
                                    break;
                                case 47: //slash
                                    _content.Append("\\/");
                                    break;
                                case 8: //backspace
                                    _content.Append("\\\b");
                                    break;
                                case 12: //formfeed
                                    _content.Append("\\\f");
                                    break;
                                case 10: //newline
                                    _content.Append("\\\n");
                                    break;
                                case 13: //carrage return
                                    _content.Append("\\\r");
                                    break;
                                case 9: //tabulation
                                    _content.Append("\\\t");
                                    break;
                                default:
                                    if ((c < 32) || (c > 127)) { //escape non printable ASCII characters with a 4 characters in UTF16 hexadecimal format (\UXXXX)
                                        sbyte b0 = (sbyte)((c & 0xF000) >> 12);
                                        sbyte b1 = (sbyte)((c & 0x0F00) >> 8);
                                        sbyte b2 = (sbyte)((c & 0x00F0) >> 4);
                                        sbyte b3 = (sbyte)(c & 0x000F);
                                        _content.Append("\\u");
                                        _content.Append(string.Format("{0:X}", b0));
                                        _content.Append(string.Format("{0:X}", b1));
                                        _content.Append(string.Format("{0:X}", b2));
                                        _content.Append(string.Format("{0:X}", b3));
                                    }
                                    else {
                                        _content.Append(c);
                                    }
                                    break;
                            }
                        }
                    }
                    _content.Append("\"");
                }
            }
            else {
                throw new MSTEException("encodeString:withTokenType: no string to encode!");
            }

        }

        private void encodeChar(sbyte? b, bool token) { //char = byte en Java

            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_CHAR);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:D}", b));
        }

        private void encodeUnsignedShort(char? c, bool token) { //UnsignedShort = char en Java

            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_UNSIGNED_SHORT);
            }
            _encodeTokenSeparator();
            //JAVA TO C# CONVERTER TODO TASK: The following line has a Java format specifier which cannot be directly translated to .NET:
            //ORIGINAL LINE: _content.append(String.format("%u", c));
            _content.Append(string.Format("%u", c));
        }

        private void encodeShort(short? s, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_SHORT);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:D}", s));
        }


        private void encodeInt(int? i, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_INT32);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:D}", i));
        }

        private void encodeLongLong(long? l, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_INT64);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:D}", l));
        }

        private void encodeFloat(float? f, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_FLOAT);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:F}", f));
        }

        private void encodeDouble(double? d, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_DOUBLE);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:F15}", d));
        }

        private void encodeIntValue(object anObject, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_INTEGER_VALUE);
            }
            int tokenOrigin = getTokenType(anObject, true);
            MSTE.logEvent("encodeIntValue tokenOrigin " + tokenOrigin);
            long? l = new long?(0);
            switch (tokenOrigin) {
                case MSTE_TOKEN_TYPE_CHAR:
                    sbyte? bVal = (sbyte?)anObject;
                    l = (long)bVal;
                    break;
                case MSTE_TOKEN_TYPE_UNSIGNED_SHORT:
                    char cVal = (char)anObject;
                    int? codeCar = (int?)Char.GetNumericValue(cVal);
                    l = (long)codeCar;
                    break;
                case MSTE_TOKEN_TYPE_SHORT:
                    short? sVal = (short?)anObject;
                    l = (long)sVal;
                    break;
                case MSTE_TOKEN_TYPE_INT32:
                    int? iVal = (int?)anObject;
                    l = (long)iVal;
                    break;
                case MSTE_TOKEN_TYPE_INT64:
                    l = (long?)anObject;
                    break;
                default:
                    throw new MSTEException("encodeIntValue: not integer value for type MSTE_TOKEN_TYPE_INTEGER_VALUE !");
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:D}", l));
        }

        private void encodeFloatValue(object anObject, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_REAL_VALUE);
            }
            int tokenOrigin = getTokenType(anObject, true);
            double? d = new double?(0);
            switch (tokenOrigin) {
                case MSTE_TOKEN_TYPE_FLOAT:
                    float? f = (float?)anObject;
                    d = (double)f;
                    break;
                case MSTE_TOKEN_TYPE_DOUBLE:
                    d = (double?)anObject;
                    break;
                default:
                    throw new MSTEException("encodeFloatValue: not float value for type MSTE_TOKEN_TYPE_REAL_VALUE !");
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0:F15}", d));
        }

        private void encodeArray(List<object> anArray) {
            _encodeTokenSeparator();
            _encodeTokenType(MSTE_TOKEN_TYPE_ARRAY);
            encodeInt(anArray.Count, false);
            foreach (object o in anArray) {
                encodeObject(o, false);
            }
        }

        private void encodeDate(DateTime d) {
            _encodeTokenSeparator();
            _encodeTokenType(MSTE_TOKEN_TYPE_DATE);
            _encodeTokenSeparator();
            _content.Append(UnixEpoch.getEpochTim(d));
        }

        private void encodeColor(MSColor c) {
            _encodeTokenSeparator();
            _encodeTokenType(MSTE_TOKEN_TYPE_COLOR);
            _encodeTokenSeparator();
            _content.Append(c.ToString());
        }

        private void encodeCouple(MSCouple c) {
            _encodeTokenSeparator();
            _encodeTokenType(MSTE_TOKEN_TYPE_COUPLE);
            encodeObject(c.FirstMember, false);
            encodeObject(c.SecondMember, false);
        }

        private void encodeDictionary(Dictionary<string, object> aDictionary, bool isSnapshot) {

            string theKey = "";
            List<object> objects = new List<object>();
            List<object> keys = new List<object>();
            // come from user class 
            if (isSnapshot) {
                foreach (var oDict in aDictionary) {
                    theKey = oDict.Key;
                    MSTE.logEvent("encodeDictionary key= " + theKey);
                    if (aDictionary[theKey] != null) {
                        MSCouple o = (MSCouple)aDictionary[theKey];
                        keys.Add(theKey);
                        objects.Add(o);
                        MSTE.logEvent("encodeDictionary value= " + o);
                    }
                }
            }
            else {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_DICTIONARY);
                //encodeInt(aDictionary.Count, false);

                foreach (var oDict in aDictionary) {
                    theKey = oDict.Key;
                    if (aDictionary[theKey] != null) {
                        object o = aDictionary[theKey];
                        keys.Add(theKey);
                        objects.Add(o);
                    }
                }
            }

            // write size of dict
            int count = keys.Count;
            encodeInt(count, false);

            for (int i = 0; i < count; i++) {
                string stringKey = (string)keys[i];
                int keyReference = 0;
                if (!_keys.ContainsKey(stringKey)) {
                    keyReference = ++_lastKeyIndex;
                    _keys[stringKey] = keyReference;
                    _keysArray.Add(stringKey);
                }
                keyReference = (int)_keys[stringKey];
                encodeInt(keyReference - 1, false);
                if (isSnapshot) {
                    MSCouple o = (MSCouple)objects[i];
                    object weakReferenced = o.SecondMember;
                    if (weakReferenced != null) {
                        encodeObject(o.FirstMember, isSnapshot);
                    }
                    else {
                        encodeObject(o.FirstMember, isSnapshot);
                    }
                }
                else {
                    encodeObject(objects[i], isSnapshot);
                }
            }

            objects = null;
            keys = null;
        }

        private void encodeObject(object anObject, bool isSnapshot) {
            int classIndex = 0;
            int objectReference = 0;

            int singleToken = getTokenType(anObject, isSnapshot);
            MSTE.logEvent("encodeObject object type = " + singleToken);
            if (singleToken == MSTE_TOKEN_MUST_ENCODE) {
                throw new MSTEException("encodeObject:unknow token type !");
            }

            // Base type 
            if (singleToken != MSTE_TOKEN_TYPE_USER_CLASS) {
                if (singleToken != MSTE_TOKEN_TYPE_NULL) {
                    objectReference = getObjectReference(anObject);
                    if (objectReference < 0) {
                        objectReference = ++_lastReference;
                        addObjectReference(anObject, objectReference);
                        encodeWithTokenType(anObject, singleToken);
                    }
                    else {
                        _encodeTokenSeparator();
                        _encodeTokenType(MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT);
                        encodeInt(objectReference - 1, false);
                    }
                }
            }
            // User type 
            else {
                objectReference = getObjectReference(anObject);
                if (objectReference > 0) {
                    _encodeTokenSeparator();
                    _encodeTokenType(MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT);
                    encodeInt(objectReference - 1, false);
                }
                else {
                    MSTE.logEvent("encodeObject 1");
                    Dictionary<string, object> dictSnapshot = null;
                    
                    MethodInfo method;
                    try {
                        method = anObject.GetType().GetMethod(MSTEIMethods.SNAP);
                    }
                    catch (Exception e) {
                        throw new MSTEException("encodeObject:unknow Exception : " + e.ToString());
                    }

                    try {
                        dictSnapshot = (Dictionary<string, object>)method.Invoke(anObject, null);
                    }
                    catch (Exception e) {
                        throw new MSTEException("encodeObject:unknow IllegalArgumentException : " + e.ToString());
                    }

                    string aClassName = anObject.GetType().Name;
                    if (_classes.ContainsKey(aClassName)) {
                        classIndex = _classes[aClassName];
                    }
                    else {
                        classIndex = ++_lastClassIndex;
                        _classes[aClassName] = classIndex;
                        _classesArray.Add(aClassName);
                    }
                    objectReference = ++_lastReference;
                    addObjectReference(anObject, objectReference);
                    _encodeTokenSeparator();
                    _encodeTokenType(MSTE_TOKEN_TYPE_USER_CLASS + 2 * (classIndex - 1));
                    encodeDictionary(dictSnapshot, true);
                }
            }
        }

        public Dictionary<string, object> encodeRootObject(object anObject) {
            Dictionary<string, object> dRes = new Dictionary<string, object>();
            _content = new StringBuilder();
            _tokenCount = 0;
            _lastKeyIndex = 0;
            _lastReference = 0;
            _lastClassIndex = 0;
            _keysArray = new List<string>();
            _keys = new Dictionary<string, object>();
            _encodedObjects = new Dictionary<int, object>();

            _classes = new Dictionary<string, int>();
            _classesArray = new List<string>();

            _global = new StringBuilder();

            encodeObject(anObject, false);

            //MSTE header
            _global.Append("[\"MSTE0101\",");
            _global.Append(5 + _lastKeyIndex + _lastClassIndex + _tokenCount);
            _global.Append(",\"CRC");
            _global.Append("00000000\",");

            //Classes list
            _global.Append(_classesArray.Count);
            foreach (string s in _classesArray) {
                _global.Append(",");
                _encodeGlobalUnicodeString(s);
            } 

            //Keys list
            _global.Append(",");
            _global.Append(_keysArray.Count);
            foreach (string s in _keysArray) {
                _global.Append(",");
                _encodeGlobalUnicodeString(s);
            }

            // global content
            _global.Append(_content);
            _global.Append("]");

            string aCRC = MSCRC32.getCRC(_global.ToString()).ToUpper();
            int posCRC = _global.ToString().IndexOf("CRC");
            _global.Remove(posCRC + 3, 8);
            _global.Insert(posCRC + 3, aCRC);
            //_global.Replace(posCRC + 3, posCRC + 11, aCRC);
            MSTE.logEvent("Chaine apres CRC = " + _global.ToString());
            dRes.Add("msteString", _global.ToString());

            //return _global
            sbyte[] b = null;
            try {
                b = MSTE.stringToSbyteArray(_global.ToString());
                MSTE.logEvent("Result = " + b);
            }
            catch (Exception) {
                throw new MSTEException("encodeRootObject:unable to convert in US-ASCII !");
            }
            dRes.Add("msteBytes", b);
            return dRes;
        }

        private void _encodeGlobalUnicodeString(string str) {
            if (!str.Equals(null)) {
                int len = str.Length;
                _global.Append("\"");
                if (len > 0) {
                    for (int i = 0; i < len; i++) {
                        char c = str[i];
                        switch ((int)c) {
                            case 9: { //\t
                                _global.Append("\\");
                                _global.Append("t");
                                break;
                            }
                            case 10: { //\n
                                _global.Append("\\");
                                _global.Append("n");
                                break;
                            }
                            case 13: { //\r
                                _global.Append("\\");
                                _global.Append("r");
                                break;
                            }
                            case 22: { //\"
                                _global.Append("\\");
                                _global.Append("\"");
                                break;
                            }
                            case 34: { // \"
								_global.Append("\\");
								_global.Append("\"");
								break;
                            }
                            case 92: { // antislash
								_global.Append("\\");
								_global.Append("\\");
                                break;
                            }
                            case 47: { // slash
								_global.Append("\\");
								_global.Append("/");
                                break;
                            }
                            default: {
                                _global.Append(c);
                                break;
                            }
                        }
                    }
                }
                _global.Append("\"");
            }
        }
        private int getTokenType(object anObject, bool isSnapshot) {

            if (anObject == null) {
                return MSTE_TOKEN_TYPE_NULL;
            }
            else if (anObject is bool?) {
                if ((bool)anObject) {
                    return MSTE_TOKEN_TYPE_TRUE;
                }
                else {
                    return MSTE_TOKEN_TYPE_FALSE;
                }
            }
            else if (anObject is sbyte[]) {
                return MSTE_TOKEN_TYPE_BASE64_DATA;
            }
            else if (anObject is string) {
                string str = anObject.ToString();
                if (str.Length > 0) {
                    return MSTE_TOKEN_TYPE_STRING;
                }
                else {
                    return MSTE_TOKEN_TYPE_EMPTY_STRING;
                }
            }
            else if (anObject is sbyte?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_CHAR;
                }
                else {
                    return MSTE_TOKEN_TYPE_INTEGER_VALUE;
                }
            }
            else if (anObject is char?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_UNSIGNED_SHORT;
                }
                else {
                    return MSTE_TOKEN_TYPE_INTEGER_VALUE;
                }
            }
            else if (anObject is short?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_SHORT;
                }
                else {
                    return MSTE_TOKEN_TYPE_INTEGER_VALUE;
                }
            }
            else if (anObject is int?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_INT32;
                }
                else {
                    return MSTE_TOKEN_TYPE_INTEGER_VALUE;
                }
            }
            else if (anObject is long?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_INT64;
                }
                else {
                    return MSTE_TOKEN_TYPE_INTEGER_VALUE;
                }
            }
            else if (anObject is float?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_FLOAT;
                }
                else {
                    return MSTE_TOKEN_TYPE_REAL_VALUE;
                }
            }
            else if (anObject is double?) {
                if (isSnapshot) {
                    return MSTE_TOKEN_TYPE_DOUBLE;
                }
                else {
                    return MSTE_TOKEN_TYPE_REAL_VALUE;
                }
            }
            else if (anObject is IList) {
                return MSTE_TOKEN_TYPE_ARRAY;
            }
            else if (anObject is DateTime) {
                return MSTE_TOKEN_TYPE_DATE;
            }
            else if (anObject is MSColor) {
                return MSTE_TOKEN_TYPE_COLOR;
            }
            else if (anObject is IDictionary) {
                return MSTE_TOKEN_TYPE_DICTIONARY;
            }
            else if (anObject is MSCouple) {
                return MSTE_TOKEN_TYPE_COUPLE;
            }
            else {
                return MSTE_TOKEN_TYPE_USER_CLASS;
            }

            //if (anObject is MSTE) {
            //    
            //}
            //return MSTE_TOKEN_MUST_ENCODE;
        }

        private void encodeWithTokenType(object anObject, int tokenType) {

            switch (tokenType) {
                case MSTE_TOKEN_TYPE_NULL:
                    _encodeTokenSeparator();
                    _encodeTokenType(tokenType);
                    break;
                case MSTE_TOKEN_TYPE_TRUE:
                    encodeBool((bool)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_FALSE:
                    encodeBool((bool)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_BASE64_DATA:
                    encodeBytes((sbyte[])anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_STRING:
                    //encodeUnicodeString((String)anObject, true);
                    encodeString((string)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_EMPTY_STRING:
                    _encodeTokenSeparator();
                    _encodeTokenType(tokenType);
                    break;
                case MSTE_TOKEN_TYPE_CHAR:
                    encodeChar((sbyte?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_UNSIGNED_SHORT:
                    encodeUnsignedShort((char?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_SHORT:
                    encodeShort((short?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_INT32:
                    encodeInt((int?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_INT64:
                    encodeLongLong((long?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_INTEGER_VALUE:
                    encodeIntValue(anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_REAL_VALUE:
                    encodeFloatValue(anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_FLOAT:
                    encodeFloat((float?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_DOUBLE:
                    encodeDouble((double?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_ARRAY:
                    encodeArray((List<object>)anObject);
                    break;
                case MSTE_TOKEN_TYPE_DATE:
                    encodeDate((DateTime)anObject);
                    break;
                case MSTE_TOKEN_TYPE_COLOR:
                    encodeColor((MSColor)anObject);
                    break;
                case MSTE_TOKEN_TYPE_DICTIONARY:
                    encodeDictionary((Dictionary<string,object>)anObject, false);
                    break;
                case MSTE_TOKEN_TYPE_COUPLE:
                    encodeCouple((MSCouple)anObject);
                    break;
                default:
                    throw new MSTEException("encodeWithTokenType:unknow token type !");

            }
        }


        private int getObjectReference(object anObject) {

            int @ref = -1;
            if (_encodedObjects.ContainsValue(anObject)) {
                @ref = _encodedObjects.SingleOrDefault(x => x.Value == anObject).Key;
            }
            return @ref;
        }

        private void addObjectReference(object anObject, int @ref) {

            //string objHashCode = Convert.ToString(anObject.GetHashCode());
            //MSNode node = new MSNode();
            //node.FirstMember = anObject;
            //node.Reference = @ref;
            //_encodedObjects[objHashCode] = node;
            _encodedObjects[@ref] = anObject;

        }

        private const string base64code = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "abcdefghijklmnopqrstuvwxyz" + "0123456789" + "+/";

        private static sbyte[] zeroPad(int length, sbyte[] bytes) {
            sbyte[] padded = new sbyte[length]; // initialized to zero by JVM
            Array.Copy(bytes, 0, padded, 0, bytes.Length);
            return padded;
        }

        private string encodeBase64(sbyte[] bArray) {
            string encoded = "";

            int paddingCount = (3 - (bArray.Length % 3)) % 3;

            bArray = zeroPad(bArray.Length + paddingCount, bArray);

            for (int i = 0; i < bArray.Length; i += 3) {
                int j = ((bArray[i] & 0xff) << 16) + ((bArray[i + 1] & 0xff) << 8) + (bArray[i + 2] & 0xff);
                encoded = encoded + base64code[(j >> 18) & 0x3f] + base64code[(j >> 12) & 0x3f] + base64code[(j >> 6) & 0x3f] + base64code[j & 0x3f];
            }

            return encoded;

        }

    }

}
