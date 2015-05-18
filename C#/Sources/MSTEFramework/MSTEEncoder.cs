using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;

namespace MSTEFramework {
    public class MSTEEncoder: MSTE {

        private bool InstanceFieldsInitialized = false;

        private void InitializeInstanceFields() {
            MSTE_TOKEN_LAST_DEFINED_TYPE = MSTE_TOKEN_TYPE_COUPLE;
        }

        private StringBuilder _content;
        private StringBuilder _global;
        private int _tokenCount;
        private int _lastKeyIndex;
        private int _lastClassIndex;
        private int _lastReference;
        private Dictionary<string, object> _keys;
        private List<string> _keysArray;
        private Dictionary<int, object> _encodedObjects;
        private Dictionary<string, int> _classes;
        private List<string> _classesArray;

        internal int MSTE_TOKEN_LAST_DEFINED_TYPE;


        // ========= constructors and destructors =========
        public MSTEEncoder() 
        {
            if (!InstanceFieldsInitialized) 
            {
                InitializeInstanceFields();
                InstanceFieldsInitialized = true;
            }
        }

        ~MSTEEncoder() 
        {
            _content = null;
            _tokenCount = 0;
        }

        //=============Implements=============================
        private void _encodeTokenSeparator() 
        {
            _tokenCount++;
            _content.Append(",");
        }

        private void _encodeTokenType(int tokenType) 
        {
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

        private void encodeData(object tb, bool token) {
            byte[] dataObj;
            if (tb is MSData) {
                dataObj = ((MSData)tb).getRawValue();
            }
            else {
                dataObj = (byte[])tb;
            }
            if (dataObj.Length > 0) {
                if (token) {
                    _encodeTokenSeparator();
                    _encodeTokenType(MSTE_TOKEN_TYPE_BASE64_DATA);
                }
                _encodeTokenSeparator();
                _content.Append("\"");
                MSData ms = MSData.initWithData(dataObj);
                _content.Append(ms.ToString());
                _content.Append("\"");
            }
            else {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_EMPTY_DATA);
            }

        }

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

        private void encodeUnsignedShort(ushort? c, bool token) { 

            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_UNSIGNED_SHORT);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0}", c));
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
            _content.Append(string.Format("{0}", f).Replace(",", "."));
        }

        private void encodeDecimal(MSNumber d, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_DECIMAL_VALUE);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0}", d).Replace(",", "."));
        }

        private void encodeDouble(double? d, bool token) {
            if (token) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_DOUBLE);
            }
            _encodeTokenSeparator();
            _content.Append(string.Format("{0}", d).Replace(",","."));
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
            _content.Append(UnixEpoch.getEpochTime(d,DateTimeKind.Local));
        }

        private void encodeUTCDate(DateTime d) {
            _encodeTokenSeparator();
            _encodeTokenType(MSTE_TOKEN_TYPE_TIMESTAMP);
            _encodeTokenSeparator();
            _content.Append(UnixEpoch.getEpochTime(d, DateTimeKind.Utc));
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
                        if ((aDictionary[theKey] is MSCouple)== false) {
                            throw new Exception ("encodeDictionary:isSnapshot: one object is not a MSCouple in a snapshot!");
                        }
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
                        encodeObject(o.FirstMember, true);
                    }
                    else {
                        encodeObject(o.FirstMember, false);
                    }
                }
                else {
                    encodeObject(objects[i], isSnapshot);
                }
            }

            objects = null;
            keys = null;
        }

        private void encodeObject(object anObject, bool referencing) 
        {
            int classIndex = 0;
            int objectReference = 0;

            objectReference = getObjectReference(anObject);
            if (objectReference > 0) {
                _encodeTokenSeparator();
                _encodeTokenType(MSTE_TOKEN_TYPE_REFERENCED_OBJECT);
                encodeInt(objectReference - 1, false);
            }
            else {

                Dictionary<string, int> singleToken = getTokenType(anObject, referencing);
                MSTE.logEvent("encodeObject object type = " + singleToken["tokenType"]);
                if (singleToken["tokenType"] == MSTE_TOKEN_MUST_ENCODE) {
                    throw new MSTEException("encodeObject:unknow token type !");
                }
                if (singleToken["tokenType"] >= MSTE_TOKEN_TYPE_USER_CLASS) {
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
                    _encodeTokenType(MSTE_TOKEN_TYPE_USER_CLASS + classIndex - 1);
                    encodeDictionary(dictSnapshot, true);
                }
                else {
                    if (singleToken["referencing"] == 1) {
                        objectReference = ++_lastReference;
                        addObjectReference(anObject, objectReference);
                       
                    }
                    encodeWithTokenType(anObject, singleToken["tokenType"]);
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

            encodeObject(anObject, true);

            //MSTE header
            _global.Append("[\"MSTE");
            _global.Append(MSTE.MSTE_CURRENT_VERSION);
            _global.Append("\",");
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

        private Dictionary<string, int> getTokenType(object anObject, bool isSnapshot) 
        {
            Dictionary<string, int> dRes = new Dictionary<string, int>();
            dRes["referencing"] = 0;
            if (anObject == null) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_NULL;
            }
            else if (anObject is bool?) {
                if ((bool)anObject) {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_TRUE;
                }
                else {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_FALSE;
                }
            }
            else if (anObject is byte[]) {
                if (((byte[])anObject).Length > 0) {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_BASE64_DATA;
                    dRes["referencing"] = 1;
                } else {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_EMPTY_DATA;
                }
            }
            else if (anObject is string) {
                string str = anObject.ToString();
                if (str.Length > 0) {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_STRING;
                    dRes["referencing"] = 1;
                }
                else {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_EMPTY_STRING;
                }
            }
            else if (anObject is sbyte?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_CHAR;
            }
            else if (anObject is char?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_UNSIGNED_SHORT;
            }
            else if (anObject is short?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_SHORT;
            }
            else if (anObject is int?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_INT32;
            }
            else if (anObject is long?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_INT64;
            }
            else if (anObject is float?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_FLOAT;
            }
            else if (anObject is double?) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_DOUBLE;
            }
            else if (anObject is IList) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_ARRAY;
                dRes["referencing"] = 1;
            }
            else if (anObject is DateTime) {
                DateTime tmpDate = (DateTime)anObject;
                if (tmpDate.Kind == DateTimeKind.Utc) {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_TIMESTAMP;
                }
                else {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_DATE;
                }
                dRes["referencing"] = 1;
            }
            else if (anObject is MSColor) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_COLOR;
                dRes["referencing"] = 1;
            }
            else if (anObject is IDictionary) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_DICTIONARY;
                dRes["referencing"] = 1;
            }
            else if (anObject is MSCouple) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_COUPLE;
                dRes["referencing"] = 1;
            }
            else if (anObject is MSNumber) {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_DECIMAL_VALUE;
                dRes["referencing"] = 1;
            }
            else if (anObject is MSData) {
                if (((MSData)anObject).getLength() == 0) {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_EMPTY_DATA;
                }
                else {
                    dRes["tokenType"] = MSTE_TOKEN_TYPE_BASE64_DATA;
                    dRes["referencing"] = 1;
                }
            }
            else {
                dRes["tokenType"] = MSTE_TOKEN_TYPE_USER_CLASS;
                dRes["referencing"] = 1;
            }

            return dRes;
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
                case MSTE_TOKEN_TYPE_EMPTY_DATA:
                case MSTE_TOKEN_TYPE_BASE64_DATA:
                    encodeData(anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_STRING:
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
                case MSTE_TOKEN_TYPE_FLOAT:
                    encodeFloat((float?)anObject, true);
                    break;
                case MSTE_TOKEN_TYPE_DECIMAL_VALUE:
                    encodeDecimal((MSNumber)anObject, true);
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
                case MSTE_TOKEN_TYPE_TIMESTAMP:
                    encodeUTCDate((DateTime)anObject);
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

        private void addObjectReference(object anObject, int @ref) 
        {
            _encodedObjects[@ref] = anObject;
        }
    }

}
