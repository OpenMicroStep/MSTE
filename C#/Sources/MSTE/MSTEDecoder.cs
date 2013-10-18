using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;
using System.Text.RegularExpressions;

namespace MSTEClasses {

    	
    public class MSTEDecoder
	{
		private bool InstanceFieldsInitialized = false;

		private void InitializeInstanceFields()
		{
			MSIntMin = (-MSIntMax - 1);
        }

        #region "OPTIONS FOR DECODER"

        public const string OPT_VALID_CRC = "ValidateCRC";
        public const string OPT_UNKNOWN_USER_CLASS = "UknownUserClass";
        public const string OPT_USER_CLASS = "UserClass";
        
        #endregion

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
		const int MSTE_DECODING_ARRAY_START = 0;
		const int MSTE_DECODING_VERSION_START = 1;
		const int MSTE_DECODING_VERSION_HEADER = 2;
		const int MSTE_DECODING_VERSION_VALUE = 3;
		const int MSTE_DECODING_VERSION_END = 4;
		const int MSTE_DECODING_VERSION_NEXT_TOKEN = 5;
		const int MSTE_DECODING_TOKEN_NUMBER_VALUE = 6;
		const int MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN = 7;
		const int MSTE_DECODING_CRC_START = 8;
		const int MSTE_DECODING_CRC_HEADER = 9;
		const int MSTE_DECODING_CRC_VALUE = 10;
		const int MSTE_DECODING_CRC_END = 11;
		const int MSTE_DECODING_CRC_NEXT_TOKEN = 12;
		const int MSTE_DECODING_CLASSES_NUMBER_VALUE = 13;
		const int MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN = 14;
		const int MSTE_DECODING_CLASS_NAME = 15;
		const int MSTE_DECODING_CLASS_NEXT_TOKEN = 16;
		const int MSTE_DECODING_KEYS_NUMBER_VALUE = 17;
		const int MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN = 18;
		const int MSTE_DECODING_KEY_NAME = 19;
		const int MSTE_DECODING_KEY_NEXT_TOKEN = 20;
		const int MSTE_DECODING_ROOT_OBJECT = 21;
		const int MSTE_DECODING_ARRAY_END = 22;
		const int MSTE_DECODING_GLOBAL_END = 23;
		const int MSTE_DECODING_STRING_START = 0;
		const int MSTE_DECODING_STRING = 1;
		const int MSTE_DECODING_STRING_ESCAPED_CAR = 2;
		const int MSTE_DECODING_STRING_STOP = 3;
		const long MSUShortMax = 65535;
		const long MSIntMax = 2147483647;
		internal long MSIntMin;
		const long MSUIntMax = 4294967295L;
		const long MSShortMax = 32767;
		const long MSShortMin = -32768;
		const long MSCharMax = 127;
		const long MSCharMin = -128;
		const long MSByteMax = 255;

		private int _tokenCount = 0;
		private int classesNumber = 0;
		private int keysNumber = 0;
		private List<string> decodedClasses;
		private List<string> decodedKeys;
		private List<object> decodedObjects;

        private Dictionary<string, string> dUserClass;

		private DateTime __theDistantPast = DateTime.MinValue;
		private DateTime __theDistantFuture = DateTime.MaxValue;

		// ========= constructors and destructors =========
		public MSTEDecoder(Dictionary<string, object> options)
		{
			if (!InstanceFieldsInitialized) {
				InitializeInstanceFields();
				InstanceFieldsInitialized = true;
			}
            this.dUserClass = options.ContainsKey(MSTEDecoder.OPT_USER_CLASS) ? (Dictionary<string, string>)options[MSTEDecoder.OPT_USER_CLASS] : null;
		}
		~MSTEDecoder()
		{
			_tokenCount = 0;
		}

		//=============Implements=============================

		private void _MSTJumpToNextToken(sbyte[] data, int[] pos, int[] tokenCount)
		{
			int len = data.Length;
			bool separatorFound = false;
			bool nextFound = false;

			while ((!separatorFound) && (pos[0] < len)) {
				if ((char)data[pos[0]] == ' ') {
					pos[0]++;
				}
				else if ((char)data[pos[0]] == ',') {
					pos[0]++;
					separatorFound = true;
					tokenCount[0]++;
				}
				else {
					throw new MSTEException("_MSTJumpToNextToken: - Bad format (unexpected character before token separator:" + (char)data[pos[0]]);
				}
			}
			if (!separatorFound) {
				throw new MSTEException("_MSTJumpToNextToken: - Bad format (no token separator)");
			}
			while (!nextFound && (pos[0] < len)) {
				if ((char)data[pos[0]] == ' ') {
					pos[0]++;
				}
				nextFound = ((char)data[pos[0]] != ' ');
			}
			if (!separatorFound) {
				throw new MSTEException("_MSTJumpToNextToken: - Bad format (no next token)");
			}
			MSTE.logEvent("_MSTJumpToNextToken > " + (char)data[pos[0]]);
		}

		private object _MSTDecodeNumber(sbyte[] data, int[] pos, int tokenType)	{
			object ret = null;
			switch (tokenType) {
				case MSTE_TOKEN_TYPE_INTEGER_VALUE : {
					ret = _MSTDecodeLong(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_REAL_VALUE :
				case MSTE_TOKEN_TYPE_DOUBLE: {
					ret = _MSTDecodeDouble(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_CHAR : {
					ret = _MSTDecodeChar(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_UNSIGNED_CHAR : {
					ret = _MSTDecodeUnsignedChar(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_SHORT : {
					ret = _MSTDecodeShort(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_UNSIGNED_SHORT : {
					ret = _MSTDecodeUnsignedShort(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_INT32 : {
					ret = _MSTDecodeInt(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_INSIGNED_INT32 : {
					ret = _MSTDecodeUnsignedInt(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_INT64: {
					ret = _MSTDecodeLong(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_UNSIGNED_INT64: {
					ret = _MSTDecodeUnsignedLong(data, pos, "_MSTDecodeNumber");
					break;
				}
				case MSTE_TOKEN_TYPE_FLOAT: {
					ret = _MSTDecodeFloat(data, pos, "_MSTDecodeNumber");
					break;
				}
				default: {
					throw new MSTEException("_MSTDecodeNumber - unknown tokenType :" + tokenType);
				}
			}
			return ret;
		}

        private sbyte? _MSTDecodeChar(sbyte[] data, int[] pos, string operation)
		{
			sbyte? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
					} else { break; }
				} else { break;	}
				pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeChar:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				long? l = Convert.ToInt64(sb.ToString());
				if ((l < MSCharMax) && (l > MSCharMin))	{
					value = (sbyte?)Convert.ToByte(sb.ToString());
				} else {
					throw new MSTEException("_MSTDecodeChar: - out of range (" + sb.ToString() + ")");
				}
			}
			return value;
		}

		private short? _MSTDecodeUnsignedChar(sbyte[] data, int[] pos, string operation)
		{
			short? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
					} else { break; }
                } else { break; }
				pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeChar:" + operation + " (no termination) ");
			}
			if (sb.Length > 0) {
				long? l = Convert.ToInt64(sb.ToString());
				if ((l < MSByteMax) && (l >= 0)) {
					value = Convert.ToInt16(sb.ToString());
				} else {
					throw new MSTEException("_MSTDecodeChar: - out of range (" + sb.ToString() + ")");
				}
			}
			return value;
		}

		private float? _MSTDecodeFloat(sbyte[] data, int[] pos, string operation) {
			float? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
                } else { break; }
				pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeFloat:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				value = Convert.ToSingle(sb.ToString());
			}
			return value;
		}

		private double? _MSTDecodeDouble(sbyte[] data, int[] pos, string operation)	{
			double? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
				} else { break; } 
                pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeDouble:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				value = Convert.ToDouble(sb.ToString());
			}
			return value;
		}

		private long? _MSTDecodeUnsignedInt(sbyte[] data, int[] pos, string operation) {
			long? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
				} else { break; } 
                pos[0]++;
			}

			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeInt:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				long? l = Convert.ToInt64(sb.ToString());
				if ((l < MSUIntMax) && (l >= 0)) {
					value = Convert.ToInt64(sb.ToString());
				} else {
					throw new MSTEException("_MSTDecodeInt: - out of range (" + sb.ToString() + ")");
				}
			}
			return value;
		}

        private int? _MSTDecodeInt(sbyte[] data, int[] pos, string operation) {
			int? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
				} else { break; } 
                pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeInt:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				long? l = Convert.ToInt64(sb.ToString());
				if ((l < MSIntMax) && (l>MSIntMin)) {
					value = Convert.ToInt32(sb.ToString());
				} else {
					throw new MSTEException("_MSTDecodeInt: - out of range (" + sb.ToString() + ")");
				}
			}
			return value;
		}

		private long? _MSTDecodeLong(sbyte[] data, int[] pos, string operation)
		{
			long? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
                } else { break; }
				pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeLong - " + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				value = Convert.ToInt64(sb.ToString());
			}
			return value;
		}

		private long? _MSTDecodeUnsignedLong(sbyte[] data, int[] pos, string operation) {
			long? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
					} else { break; }
                } else { break; }
				pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeUnsignedLong - " + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				try {
					value = Convert.ToInt64(sb.ToString());
				} catch (Exception e) {
					throw new MSTEException("_MSTDecodeUnsignedLong : unable to parse value " + sb.ToString() + " - error : " + e.ToString());
				}
			}
			return value;
		}

		private int? _MSTDecodeUnsignedShort(sbyte[] data, int[] pos, string operation) {
			int? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
				} else { break; } 
                pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeUnsignedShort:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				long? l = Convert.ToInt64(sb.ToString());
				if ((l <= MSUShortMax) && (l >= 0)) {
					value = Convert.ToInt32(sb.ToString());
				} else {
					throw new MSTEException("_MSTDecodeUnsignedShort: - out of range (" + sb.ToString() + ")");
				}
			}
			return value;
		}

		private short? _MSTDecodeShort(sbyte[] data, int[] pos, string operation) {
			short? value = null;
			int len = data.Length;

			StringBuilder sb = new StringBuilder();
			while (pos[0] < len) {
				if ((char)data[pos[0]] != ',') {
					if ((char.IsDigit((char)data[pos[0]])) || ((char)data[pos[0]] == '-') || ((char)data[pos[0]] == '.')) {
						sb.Append((char)data[pos[0]]);
                    } else { break; }
				} else { break; }
				pos[0]++;
			}
			if (pos[0] == len) {
				throw new MSTEException("_MSTDecodeShort:" + operation + " (no termination) ");
			}

			if (sb.Length > 0) {
				long? l = Convert.ToInt64(sb.ToString());
				if ((l < MSShortMax) && (l>MSShortMin)) {
					value = Convert.ToInt16(sb.ToString());
				} else {
					throw new MSTEException("_MSTDecodeShort: - out of range (" + sb.ToString() + ")");
				}
			}
			return value;
		}

		private MSColor _MSTDecodeColor(sbyte[] data, int[] pos, string operation) {
			MSColor ret = new MSColor();
			long? trgbValue = _MSTDecodeUnsignedInt(data, pos, operation);
			ret.initWithCSSColor(trgbValue);
			return ret;
		}

		private List<object> _MSTDecodeArray(sbyte[] data, int[] pos, string operation, List<object> decodedObjects, List<string> classes, List<string> keys, int[] tokenCount, bool? allowsUnknownUserClasses) {
			long? count = _MSTDecodeUnsignedInt(data, pos, operation);

			List<object> ret = new List<object>();
			decodedObjects.Add(ret);

			if (count > 0) {
				for (int i = 0; i < count; i++)	{
					bool isWeakRef = false;
					object obj;
					_MSTJumpToNextToken(data,pos,tokenCount);
					obj = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses);
					ret.Add(obj);
					if (isWeakRef) {
						throw new MSTEException("_MSTDecodeArray: - Weakly referenced object encountered while decoding an array!");
					}
				}
			}
			return ret;
		}

		private sbyte[] _MSTDecodeBufferBase64String(sbyte[] data, int[] pos, string operation) {
			sbyte[] ret = null;
			string base64String = _MSTDecodeString(data, pos, operation);
			if (base64String.Length > 0) {
				ret = decodeFromBase64(base64String);
			}
			return ret;
		}

		private MSCouple _MSTDecodeCouple(sbyte[] data, int[] pos, string operation, List<object> decodedObjects, List<string> classes, List<string> keys, int[] tokenCount, bool? allowsUnknownUserClasses) {
			MSCouple ret = new MSCouple();
			object firstMember = null;
			object secondMember = null;
			bool isWeakRef = false;
			decodedObjects.Add(ret);
			firstMember = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses);
			if (isWeakRef) {
				throw new MSTEException("_MSTDecodeCouple: - Weakly referenced object encountered while decoding an MSCouple!");
			}

			_MSTJumpToNextToken(data, pos, tokenCount);
			secondMember = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses);
			if (isWeakRef) {
				throw new MSTEException("_MSTDecodeCouple: - Weakly referenced object encountered while decoding an MSCouple!");
			}
			ret.FirstMember = firstMember;
			ret.SecondMember = secondMember;

			return ret;
		}

		private object _MSTDecodeUserDefinedObject(sbyte[] data, int[] pos, string operation, int tokenType, List<object> decodedObjects, List<string> classes, List<string> keys, int[] tokenCount, bool? allowsUnknownUserClasses) {
			object ret = null;
			int classIndex = (tokenType - MSTE_TOKEN_TYPE_USER_CLASS) / 2;

			if (classIndex >= 0 && classIndex < classes.Count) {
				string className = classes[classIndex];
				try {
                    Type aClass = Type.GetType(className);
                    if (aClass==null) {
                        if (this.dUserClass != null && this.dUserClass.Count > 0) {
                            if (this.dUserClass.ContainsKey(className)) {
                                aClass = Type.GetType(this.dUserClass[className]);
                            } else {
                                aClass = null;
                            }
                        } else {
                            aClass = null;
                        }
                    }
                                        
                    if (aClass != null) {
                        try {
                            ret = Activator.CreateInstance(aClass);
                        } catch (Exception ex) {
                            throw new MSTEException("_MSTDecodeUserDefinedObject: -	unable to find constructor or initializer for user class " + className + " in current system");
                        }
						Dictionary<string, object> dict = new Dictionary<string, object>();
                        decodedObjects.Add(ret);
                        dict = _MSTDecodeDictionary(data, pos, operation, decodedObjects, classes, keys, tokenCount, false, true, allowsUnknownUserClasses);
                        // retrieve init interface method
                        MethodInfo initMethod = aClass.GetMethod(MSTEIMethods.INIT);
                        if (initMethod == null) {
                            throw new MSTEException("_MSTDecodeUserDefinedObject: -	unable to find initWithDictionary method in " + className + " in current system");
                        }
                        // call to init interface method
                        initMethod.Invoke(ret, new object[] { dict });
					}
                    // if unknown user class are allowed we decode as dictionnary
					else if ((bool)allowsUnknownUserClasses) {
						ret = _MSTDecodeDictionary(data, pos, "_MSTDecodeUserDefinedObject", decodedObjects, classes, keys, tokenCount, true, true,allowsUnknownUserClasses);
					}
					else {
						throw new MSTEException("_MSTDecodeUserDefinedObject: -	unable to find user class " + className + " in current system");
					}
				}
				catch (Exception e)	{
					throw new MSTEException("_MSTDecodeUserDefinedObject : unable to create user class instance !" + e.ToString());
				}
			}
			else {
				throw new MSTEException("_MSTDecodeUserDefinedObject: -	unable to find user class at index " + classIndex);
			}
			return ret;
		}

		private string _MSTDecodeString(sbyte[] data, int[] pos, string operation) {
			int state = MSTE_DECODING_STRING_START;
			bool endStringFound = false;
			StringBuilder sb = new StringBuilder();
			int len = data.Length;

			while ((pos[0] < len) && (!endStringFound)) {
				switch (state) {
					case MSTE_DECODING_STRING_START : {
						if ((char)data[pos[0]] == '"') {
							pos[0]++;
							state = MSTE_DECODING_STRING;
						}
						else {
							throw new MSTEException("_MSTDecodeString: (wrong starting character) : " + operation);
						}
						break;
					}
					case MSTE_DECODING_STRING : {
						if ((char)data[pos[0]] == '\\')	{
							pos[0]++;
							state = MSTE_DECODING_STRING_ESCAPED_CAR;
							break;
						}
						if ((char)data[pos[0]] == '"') {
							pos[0]++;
							state = MSTE_DECODING_STRING_STOP;
							endStringFound = true;
							break;
						}
						sb.Append((char)data[pos[0]]);
						pos[0]++;
						break;
					}
					case MSTE_DECODING_STRING_ESCAPED_CAR : {
						if ((char)data[pos[0]] == '"') {
							int hexToInt = Convert.ToInt32("0022", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == '\\') {
							int hexToInt = Convert.ToInt32("005c", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == '/') {
							int hexToInt = Convert.ToInt32("002F", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == 'b') {
							int hexToInt = Convert.ToInt32("0008", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == 'f') {
							int hexToInt = Convert.ToInt32("0012", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == 'n') {
							int hexToInt = Convert.ToInt32("000a", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == 'r') {
							int hexToInt = Convert.ToInt32("000d", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == 't') {
							int hexToInt = Convert.ToInt32("0009", 16);
							char intToChar = (char)hexToInt;
							sb.Append(intToChar);
							pos[0]++;
							state = MSTE_DECODING_STRING;
							break;
						}
						else if ((char)data[pos[0]] == 'u') {
							//UTF16 value on 4 hexadecimal characters expected
							if ((pos[0] + 4) > len) {
								throw new MSTEException("_MSTDecodeString: (too short UTF16 character expected) " + operation);
							}
							char? s0 = (char)data[pos[0] + 1];
							char? s1 = (char)data[pos[0] + 2];
							char? s2 = (char)data[pos[0] + 3];
							char? s3 = (char)data[pos[0] + 4];
                            Regex rx = new Regex(@"[0-9A-Fa-f]+");

                            if ((rx.Matches(s0.ToString()).Count <= 0) || (rx.Matches(s1.ToString()).Count <= 0) || (rx.Matches(s2.ToString()).Count <= 0) || (rx.Matches(s2.ToString()).Count <= 0)) {
								throw new MSTEException("_MSTDecodeString: (bad hexadecimal character for UTF16) " + operation);
							}
							else {
                                sbyte b0 = (sbyte)data[pos[0] + 1];
								sbyte b1 = (sbyte)data[pos[0] + 2];
								sbyte b2 = (sbyte)data[pos[0] + 3];
								sbyte b3 = (sbyte)data[pos[0] + 4];
								char? car = (char)((b0 << 12) + (b1 << 8) + (b2 << 4) + b3);
								sb.Append(car);
								pos[0] = pos[0] + 5;
								state = MSTE_DECODING_STRING;
							}
							break;
						}
						else {
							throw new MSTEException("_MSTDecodeString: (unexpected escaped character) " + operation);
						}
					}
					default: {
						throw new MSTEException("_MSTDecodeString: (unknown state) " + operation);
					}
				}
			}
			return sb.ToString();
		}

		private object _MSTDecodeObject(sbyte[] data, int[] pos, string operation, List<object> decodedObjects, List<string> classes, List<string> keys, int[] tokenCount, bool? isWeaklyReferenced, bool? allowsUnknownUserClasses) {
			int len = data.Length;
			object ret = null;

			int tokenType = (int)_MSTDecodeUnsignedShort(data, pos,"token type");
        	MSTE.logEvent("_MSTDecodeObject tokenType : " + tokenType);
			switch (tokenType) {
				case MSTE_TOKEN_TYPE_NULL :	{
					//nothing to do: returning nil
					break;
				}
				case MSTE_TOKEN_TYPE_TRUE :	{
					ret = new bool?(true);
					break;
				}
				case MSTE_TOKEN_TYPE_FALSE : {
					ret = new bool?(false);
					break;
				}
				case MSTE_TOKEN_TYPE_INTEGER_VALUE :
				case MSTE_TOKEN_TYPE_REAL_VALUE : {
					_MSTJumpToNextToken(data,pos,tokenCount);
					ret = _MSTDecodeNumber(data, pos, tokenType);
					decodedObjects.Add(ret);
					break;
				}
				case MSTE_TOKEN_TYPE_CHAR :
				case MSTE_TOKEN_TYPE_UNSIGNED_CHAR :
				case MSTE_TOKEN_TYPE_SHORT :
				case MSTE_TOKEN_TYPE_UNSIGNED_SHORT :
				case MSTE_TOKEN_TYPE_INT32 :
				case MSTE_TOKEN_TYPE_INSIGNED_INT32 :
				case MSTE_TOKEN_TYPE_INT64 :
				case MSTE_TOKEN_TYPE_UNSIGNED_INT64 :
				case MSTE_TOKEN_TYPE_FLOAT :
				case MSTE_TOKEN_TYPE_DOUBLE : {
					_MSTJumpToNextToken(data,pos,tokenCount);
					ret = _MSTDecodeNumber(data, pos, tokenType);
					break;
				}
				case MSTE_TOKEN_TYPE_STRING : {
					_MSTJumpToNextToken(data, pos,tokenCount);
					ret = _MSTDecodeString(data, pos, "_MSTDecodeObject");
					decodedObjects.Add(ret);
					break;
				}
				case MSTE_TOKEN_TYPE_DATE : {
					long? seconds = long.MinValue;
					_MSTJumpToNextToken(data, pos, tokenCount);
					seconds = _MSTDecodeLong(data, pos, "_MSTDecodeObject");
                    DateTime? dt = UnixEpoch.getDateTime((long)seconds);
                    ret = (dt == null ? this.__theDistantPast : dt);
                    //ret = null;
					decodedObjects.Add(ret);
					break;
				}
				case MSTE_TOKEN_TYPE_DICTIONARY : {
					_MSTJumpToNextToken(data, pos, tokenCount);
					ret = _MSTDecodeDictionary(data, pos, "_MSTDecodeObject", decodedObjects, classes, keys, tokenCount, true, false,allowsUnknownUserClasses);
					break;
				}
				case MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT : {
	                MSTE.logEvent("_MSTDecodeObject objectReference in MSTE_TOKEN_TYPE_STRONGLY_REFERENCED_OBJECT");
					int? objectReference;
					_MSTJumpToNextToken(data, pos, tokenCount);
					objectReference = _MSTDecodeInt(data, pos, "_MSTDecodeObject");
                    //MSTE.logEvent("_MSTDecodeObject objectReference" + objectReference);
					ret = decodedObjects[(int)objectReference];
                    //MSTE.logEvent("_MSTDecodeObject ret" + ret.ToString());
					break;
				}
				case MSTE_TOKEN_TYPE_COLOR : {
					_MSTJumpToNextToken(data, pos, tokenCount);
					ret = _MSTDecodeColor(data, pos, "_MSTDecodeObject");
					decodedObjects.Add(ret);
					break;
				}
				case MSTE_TOKEN_TYPE_ARRAY : {
					_MSTJumpToNextToken(data, pos, tokenCount);
					ret = _MSTDecodeArray(data, pos, operation, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses);
					break;
				}
				case MSTE_TOKEN_TYPE_NATURAL_ARRAY : {
					_MSTJumpToNextToken(data, pos, tokenCount);
					ret = _MSTDecodeArray(data, pos, operation, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses);
					break;
				}
				case MSTE_TOKEN_TYPE_COUPLE : {
					_MSTJumpToNextToken(data, pos, tokenCount);
					ret = _MSTDecodeCouple(data, pos, operation, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses);
					break;
				}
				case MSTE_TOKEN_TYPE_BASE64_DATA : {
					_MSTJumpToNextToken(data, pos, tokenCount);
					ret = _MSTDecodeBufferBase64String(data, pos, operation);
					decodedObjects.Add(ret);
                    break;
				}
				case MSTE_TOKEN_TYPE_DISTANT_PAST : {
					ret = __theDistantPast;
					break;
				}
				case MSTE_TOKEN_TYPE_DISTANT_FUTURE : {
					ret = __theDistantFuture;
					break;
				}
				case MSTE_TOKEN_TYPE_EMPTY_STRING : {
					ret = "";
					break;
				}
				case MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT : {
					//Decoded like Strongly referenced
					int? objectReference;
					_MSTJumpToNextToken(data, pos, tokenCount);
					objectReference = _MSTDecodeInt(data, pos, "_MSTDecodeObject");
					ret = decodedObjects[(int)objectReference];
					break;
				}
				default : {
					if (tokenType >= MSTE_TOKEN_TYPE_USER_CLASS){
						_MSTJumpToNextToken(data, pos, tokenCount);
						ret = _MSTDecodeUserDefinedObject(data, pos, operation, tokenType, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses);

						if (((tokenType - MSTE_TOKEN_TYPE_USER_CLASS) % 2) > 0) {
							isWeaklyReferenced = true;
						} else {
							isWeaklyReferenced = false;
						}
					} else {
						throw new MSTEException("_MSTDecodeObject - unknown tokenType : " + tokenType);
					}
					break;
				}
			}
			return ret;
		}

		private Dictionary<string, object> _MSTDecodeDictionary(sbyte[] data, int[] pos, string operation, List<object> decodedObjects, List<string> classes, List<string> keys, int[] tokenCount, bool manageReference, bool decodingUserClass, bool? allowsUnknownUserClasses)
		{
			Dictionary<string, object> ret = new Dictionary<string, object>();
			long? count = _MSTDecodeUnsignedLong(data, pos, operation);

			if (manageReference) {
				decodedObjects.Add(ret);
			}

			if (count > 0) {
				for (int i = 0; i < count; i++) {
					bool isWeakRef = false;
					long keyReference = 0;
					object @object = 0;
					string key = "";
					_MSTJumpToNextToken(data, pos, tokenCount);
					keyReference = (long)_MSTDecodeUnsignedInt(data, pos, operation);
					key = keys[(int)keyReference];
					_MSTJumpToNextToken(data, pos, tokenCount);
					@object = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses);
					ret[key] = @object;
					if (isWeakRef) {
						if (decodingUserClass) {
							if (manageReference) {
								throw new MSTEException("_MSTDecodeDictionary - Weakly referenced object encountered while decoding a user class!");
							}
						} else {
							throw new MSTEException("_MSTDecodeDictionary - Weakly referenced object encountered while decoding a non user class!");
						}
					}
				}
			}
			return ret;
		}

		public virtual object decodeObject(sbyte[] data, bool verifyCRC, bool? allowsUnknownUserClasses) {
			int len = data.Length;
			string strCRC = "";

			if (len > 26) {
				int[] pos = new int[1];
				pos[0] = 0;
				int state = MSTE_DECODING_ARRAY_START;
				object @object = null;
				List<string> decodedClasses = new List<string>();
				List<string> decodedKeys = new List<string>();
				List<object> decodedObjects = new List<object>();
				int[] myTokenCount = new int[1];
				myTokenCount[0] = 0;
				long tokenNumber = 0;
				int classesNumber = 0;
				int keysNumber = 0;

				while (pos[0] < len) {
	                MSTE.logEvent("Position = " + pos[0] + " / taille =" + len + " valeur =" + (char)data[pos[0]] + " State =" + state);
					switch (state) {
						case MSTE_DECODING_ARRAY_START : {
							if ((char)data[pos[0]] == ' ') {
								pos[0]++;
								break;
							}
							if ((char)data[pos[0]] == '[') {
								pos[0]++;
								state = MSTE_DECODING_VERSION_START;
								break;
							}
							throw new MSTEException("decodeObject:Bad header format (array start) !");
						}
						case MSTE_DECODING_VERSION_START : {
							if ((char)data[pos[0]] == ' ') {
								pos[0]++;
								break;
							}
							if ((char)data[pos[0]] == '"') {
								pos[0]++;
								state = MSTE_DECODING_VERSION_HEADER;
								break;
							}
							throw new MSTEException("decodeObject:Bad header format (start) !");
						}
						case MSTE_DECODING_VERSION_HEADER : {
							if (((pos[0] + 4) > len) || ((char)data[pos[0]] != 'M') || ((char)data[pos[0] + 1] != 'S') || ((char)data[pos[0] + 2] != 'T') || ((char)data[pos[0] + 3] != 'E')) {
								throw new MSTEException("decodeObject:Bad header format (MSTE marker) !");
							}
							pos[0] = pos[0] + 4;
							state = MSTE_DECODING_VERSION_VALUE;
							break;
						}
						case MSTE_DECODING_VERSION_VALUE : {
							if (((pos[0] + 4) > len) || (!char.IsDigit((char)data[pos[0]])) || (!char.IsDigit((char)data[pos[0] + 1])) || (!char.IsDigit((char)data[pos[0] + 2])) || (!char.IsDigit((char)data[pos[0] + 3]))) {
								throw new MSTEException("decodeObject: Bad header version !");
							}
							pos[0] = pos[0] + 4;
							state = MSTE_DECODING_VERSION_END;
							break;
						}
						case MSTE_DECODING_VERSION_END : {
							if ((char)data[pos[0]] == '"') {
								pos[0]++;
								state = MSTE_DECODING_VERSION_NEXT_TOKEN;
							} else {
								throw new MSTEException("decodeObject: Bad header format (version end) !");
							}
							break;
						}
						case MSTE_DECODING_VERSION_NEXT_TOKEN :
						case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN :
						case MSTE_DECODING_CRC_NEXT_TOKEN :
						case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN :
						case MSTE_DECODING_CLASS_NEXT_TOKEN :
						case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN :
						case MSTE_DECODING_KEY_NEXT_TOKEN : {
							_MSTJumpToNextToken(data, pos, myTokenCount);
							switch (state) {
								case MSTE_DECODING_VERSION_NEXT_TOKEN:
									state = MSTE_DECODING_TOKEN_NUMBER_VALUE;
									break;
								case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN:
									state = MSTE_DECODING_CRC_START;
									break;
								case MSTE_DECODING_CRC_NEXT_TOKEN:
									state = MSTE_DECODING_CLASSES_NUMBER_VALUE;
									break;
								case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN:
									if (classesNumber > 0) {
										state = MSTE_DECODING_CLASS_NAME;
									} else {
										state = MSTE_DECODING_KEYS_NUMBER_VALUE;
									}
									break;
								case MSTE_DECODING_CLASS_NEXT_TOKEN:
									if (classesNumber > decodedClasses.Count) {
										state = MSTE_DECODING_CLASS_NAME;
									} else {
										state = MSTE_DECODING_KEYS_NUMBER_VALUE;
									}
									break;
								case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN:
									if (keysNumber > 0) {
										state = MSTE_DECODING_KEY_NAME;
									} else {
										state = MSTE_DECODING_ROOT_OBJECT;
									}
									break;
								case MSTE_DECODING_KEY_NEXT_TOKEN:
									if (keysNumber > decodedKeys.Count) {
										state = MSTE_DECODING_KEY_NAME;
									} else {
										state = MSTE_DECODING_ROOT_OBJECT;
									}
									break;
								default:
									throw new MSTEException("decodeObject: state unchanged!!!!");
							}
							break;
						}
						case MSTE_DECODING_TOKEN_NUMBER_VALUE : {
							tokenNumber = (long)_MSTDecodeUnsignedLong(data, pos,"token number");
							state = MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN;
							break;
						}
						case MSTE_DECODING_CRC_START : {
							if ((char)data[pos[0]] == '"') {
								pos[0]++;
								state = MSTE_DECODING_CRC_HEADER;
								break;
							} else {
								throw new MSTEException("decodeObject: Bad header format (CRC start)");
							}
						}
						case MSTE_DECODING_CRC_HEADER : {
							if (((pos[0] + 3) > len) || ((char)data[pos[0]] != 'C') || ((char)data[pos[0] + 1] != 'R') || ((char)data[pos[0] + 2] != 'C')) {
								throw new MSTEException("decodeObject:Bad header format (CRC marker) !");
							}
							pos[0] = pos[0] + 3;
							state = MSTE_DECODING_CRC_VALUE;
							break;
						}
						case MSTE_DECODING_CRC_VALUE : {
							if ((pos[0] + 8) > (len - 1)) {
								throw new MSTEException("decodeObject:Bad header format (CRC value) !");
							}
							StringBuilder sb = new StringBuilder();
							for (int j = pos[0]; j < (pos[0] + 8);j++) {
								sb.Append((char)data[j]);
							}
							strCRC = sb.ToString();
							pos[0] = pos[0] + 8;
							state = MSTE_DECODING_CRC_END;
							break;
						}
						case MSTE_DECODING_CRC_END : {
							if ((char)data[pos[0]] == '"') {
								pos[0]++;
								state = MSTE_DECODING_CRC_NEXT_TOKEN;
							} else {
								throw new MSTEException("decodeObject: Bad header format (CRC end)");
							}
							break;
						}
						case MSTE_DECODING_CLASSES_NUMBER_VALUE : {
							classesNumber = (int)_MSTDecodeInt(data, pos,"classes number");
							if (classesNumber > 0) {
								decodedClasses = new List<string>(classesNumber);
							}
							state = MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN;
							break;
						}
						case MSTE_DECODING_CLASS_NAME : {
							string className = _MSTDecodeString(data, pos, "class name");
							decodedClasses.Add(className);
							state = MSTE_DECODING_CLASS_NEXT_TOKEN;
							break;
						}
						case MSTE_DECODING_KEYS_NUMBER_VALUE : {
							keysNumber = (int)_MSTDecodeInt(data, pos,"keys number");
							if (keysNumber > 0) {
								decodedKeys = new List<string>(keysNumber);
							}
							state = MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN;
							break;
						}
						case MSTE_DECODING_KEY_NAME : {
							string key = _MSTDecodeString(data, pos, "key name");
							decodedKeys.Add(key);
							state = MSTE_DECODING_KEY_NEXT_TOKEN;
							break;
						}
						case MSTE_DECODING_ROOT_OBJECT : {
							decodedObjects = new List<object> ();
							@object = _MSTDecodeObject(data, pos, "root object", decodedObjects, decodedClasses, decodedKeys, myTokenCount, null, allowsUnknownUserClasses);
							state = MSTE_DECODING_ARRAY_END;
							break;
						}
						case MSTE_DECODING_ARRAY_END : {
							if ((char)data[pos[0]] == ' ') {
								pos[0]++;
								break;
							}
							if ((char)data[pos[0]] == ']') {
								state = MSTE_DECODING_GLOBAL_END;
								break;
							}
							throw new MSTEException("decodeObject - Bad format (array end)");
						}
						case MSTE_DECODING_GLOBAL_END : {
							if ((char)data[pos[0]] == ' ') {
								pos[0]++;
								break;
							}
							if (pos[0] == len - 1) {
                                //if (verifyCRC) {
                                //    StringBuilder global = new StringBuilder();
                                //    Encoding enc8 = Encoding.UTF8;
                                //    byte[] byteData = Array.ConvertAll(data, (a) => (byte)a);
                                //    string s = enc8.GetString(byteData);
                                //    global.Append(s);
                                //    int posCRC = s.IndexOf("CRC");
                                //    global.Remove(posCRC + 3, 11);
                                //    global.Insert(posCRC + 3, "00000000");
                                //    string calcCRC = MSCRC32.getCRC(global.ToString());
                                //    if (calcCRC.ToUpper() != strCRC.ToUpper()) {
                                //        throw new MSTEException("decodeObject  - CRC Verification failed");
                                //    }
                                //}
								myTokenCount[0]++;
								if (tokenNumber != myTokenCount[0]) {
									throw new MSTEException("decodeObject - Wrong token number : " + myTokenCount[0] + " (expected : " + tokenNumber + ")");
								}
								pos[0]++;
								break;
							} else {
								throw new MSTEException("decodeObject - Bad format (character after array end)");
							}
						}
						default : {
							throw new MSTEException("decodeObject - unknown state");
						}
					}
				}
				return @object;
			} else {
				throw new MSTEException("decodeObject:no minimum header size !");
			}
		}

		private static int[] toInt = new int[128];
		
        private static sbyte[] decodeFromBase64(string s) {
			int delta = s.EndsWith("==") ? 2 : s.EndsWith("=") ? 1 : 0;
			sbyte[] buffer = new sbyte[s.Length * 3 / 4 - delta];
			int mask = 0xFF;
			int index = 0;
			for (int i = 0; i < s.Length; i += 4) {
				int c0 = toInt[s[i]];
				int c1 = toInt[s[i + 1]];
				buffer[index++] = (sbyte)(((c0 << 2) | (c1 >> 4)) & mask);
				if (index >= buffer.Length) {
					return buffer;
				}
				int c2 = toInt[s[i + 2]];
				buffer[index++] = (sbyte)(((c1 << 4) | (c2 >> 2)) & mask);
				if (index >= buffer.Length) {
					return buffer;
				}
				int c3 = toInt[s[i + 3]];
				buffer[index++] = (sbyte)(((c2 << 6) | c3) & mask);
			}
			return buffer;
		}

	}
}
