using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;

namespace MSTEClasses {

    public class MSTE {

        public static string log;

        #region "sharing constants code disctionnay for decoder and encoder"

            protected const string MSTE_CURRENT_VERSION = "0102";

            protected const int MSTE_TOKEN_MUST_ENCODE = -1;
            protected const int MSTE_TOKEN_TYPE_NULL = 0;
            protected const int MSTE_TOKEN_TYPE_TRUE = 1;
            protected const int MSTE_TOKEN_TYPE_FALSE = 2;
            protected const int MSTE_TOKEN_TYPE_EMPTY_STRING = 3;
            protected const int MSTE_TOKEN_TYPE_DISTANT_PAST = 4;
            protected const int MSTE_TOKEN_TYPE_DISTANT_FUTURE = 5;
            protected const int MSTE_TOKEN_TYPE_EMPTY_DATA = 6;

            protected const int MSTE_TOKEN_TYPE_REFERENCED_OBJECT = 9;

            protected const int MSTE_TOKEN_TYPE_CHAR = 10;
            protected const int MSTE_TOKEN_TYPE_UNSIGNED_CHAR = 11;
            protected const int MSTE_TOKEN_TYPE_SHORT = 12;
            protected const int MSTE_TOKEN_TYPE_UNSIGNED_SHORT = 13;
            protected const int MSTE_TOKEN_TYPE_INT32 = 14;
            protected const int MSTE_TOKEN_TYPE_INSIGNED_INT32 = 15;
            protected const int MSTE_TOKEN_TYPE_INT64 = 16;
            protected const int MSTE_TOKEN_TYPE_UNSIGNED_INT64 = 17;
            protected const int MSTE_TOKEN_TYPE_FLOAT = 18;
            protected const int MSTE_TOKEN_TYPE_DOUBLE = 19;

            protected const int MSTE_TOKEN_TYPE_DECIMAL_VALUE = 20;
            protected const int MSTE_TOKEN_TYPE_STRING = 21;
            protected const int MSTE_TOKEN_TYPE_DATE = 22;
            protected const int MSTE_TOKEN_TYPE_COLOR = 23;
            protected const int MSTE_TOKEN_TYPE_BASE64_DATA = 24;
            protected const int MSTE_TOKEN_TYPE_NATURAL_ARRAY = 25;

            protected const int MSTE_TOKEN_TYPE_DICTIONARY = 30;
            protected const int MSTE_TOKEN_TYPE_ARRAY = 31;
            protected const int MSTE_TOKEN_TYPE_COUPLE = 32;

            protected const int MSTE_TOKEN_TYPE_USER_CLASS = 50;

            //const int MSTE_TOKEN_TYPE_INTEGER_VALUE = 3;
            //const int MSTE_TOKEN_TYPE_REAL_VALUE = 4;
            //const int MSTE_TOKEN_TYPE_WEAKLY_REFERENCED_OBJECT = 27;

        #endregion

        // create object from MSTE string
	    public static object decode(string source) {
            object r = null;
		    try {
                MSTE.log = "";
                r = MSTE._msteDecodePrivate(source, null) ;
		    }
		    catch (Exception e) { 
			     // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
			     MSTE.logEvent("Unable to create MSTE object : " + e.Message); 
		    }
		    return r ;
	    }

        public static object decode(string source, Dictionary<string,object> options) {
            object r = null;
		    try {
                MSTE.log = "";
                r = MSTE._msteDecodePrivate(source, options) ;
		    }
		    catch (Exception e) { 
			     // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
			     MSTE.logEvent("Unable to create MSTE object : " + e.Message); 
		    }
		    return r ;
	    }

        public static object decode(sbyte[] source, Dictionary<string, object> options) {
            object r = null;
            try {
                MSTE.log = "";
                r = MSTE._msteDecodePrivate(source, options);
            }
            catch (Exception e) {
                // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
                MSTE.logEvent("Unable to create MSTE object : " + e.Message);
            }
            return r;
        } 

        public static string encode(object obj) {
            string r = null;
		    try {
                MSTE.log = "";
                r = MSTE._msteEncodePrivate(obj) ;
		    }
		    catch (Exception e) { 
			     // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
			     MSTE.logEvent("Unable to create MSTE object : " + e.Message); 
		    }
		    return r ;
        }
        
        //// create MSTE array from object
        //public static function tokenize($obj) {
        //    $r = null ;
        //    try {
        //        $r = MSTE::_msteEncodePrivate($obj);
        //    }
        //    catch (Exception $e) { 
        //        echo "Unable to create MSTE array : ".$e->getMessage(); 
        //    }
        //    return $r;
        //}

        //// create MSTE string from object
        //public static function stringify($obj) {
        //    $r = null ;
        //    try {
        //        $r = MSTE::tokenize($obj);
        //        $s = json_encode($r);
        //    }
        //    catch (Exception $e) { 
        //        echo "Unable to create MSTE string : ".$e->getMessage(); 
        //    }
        //    return $s;
        //}

        private static object _msteDecodePrivate(string source, Dictionary<string, object> options) {
            MSTEDecoder decoder = new MSTEDecoder(options);
            bool vCRC = options.ContainsKey("ValidateCRC") ? (bool)options["ValidateCRC"] : false;
            bool uUserClass = options.ContainsKey("UknownUserClass") ? (bool)options["UknownUserClass"] : true;

            return decoder.decodeObject(MSTE.stringToSbyteArray(source), vCRC, uUserClass);
	    }

        private static object _msteDecodePrivate(sbyte[] source, Dictionary<string, object> options) {
            MSTEDecoder decoder = new MSTEDecoder(options);
            bool vCRC = options.ContainsKey("ValidateCRC") ? (bool)options["ValidateCRC"] : false;
            bool uUserClass = options.ContainsKey("UknownUserClass") ? (bool)options["UknownUserClass"] : true;

            return decoder.decodeObject(source, vCRC, uUserClass);
        }

        private static string _msteEncodePrivate(object o) {
            MSTEEncoder e = new MSTEEncoder();
            Dictionary<string, object> res = e.encodeRootObject(o);
            return (string)res["msteString"];
        }

        public static void logEvent(string s) {
            Console.WriteLine(s);
            log += s + Environment.NewLine;
        }

        #region "For Byte"

        public static string sbyteArrayToString(sbyte[] data) {
            Encoding enc8 = Encoding.UTF8;
            byte[] byteData = Array.ConvertAll(data, (a) => (byte)a);
            string s = enc8.GetString(byteData);
            byteData = null;
            return s;
        }

        public static sbyte[] stringToSbyteArray(string s) {
            Encoding enc8 = Encoding.UTF8;
            byte[] abData = enc8.GetBytes(s);
            sbyte[] sbyteData = Array.ConvertAll(abData, (a) => (sbyte)a);
            abData = null;
            return sbyteData;
        }

        #endregion
    }
}



//public static class TypeEx {
//     public const string  NS = "MSTETypes.";
//     public static Type GetType(string typeName) {
//          return Type.GetType(NS + typeName);
//     }
//}

///// <summary>
///// Gets a all Type instances matching the specified class name with just non-namespace qualified class name.
///// </summary>
///// <param name="className">Name of the class sought.</param>
///// <returns>Types that have the class name specified. They may not be in the same namespace.</returns>
//public static Type[] getTypeByName(string className) {
//    List<Type> returnVal = new List<Type>();

//    foreach (Assembly a in AppDomain.CurrentDomain.GetAssemblies()) {
//        Type[] assemblyTypes = a.GetTypes();
//        for (int j = 0; j < assemblyTypes.Length; j++) {
//            if (assemblyTypes[j].Name == className) {
//                returnVal.Add(assemblyTypes[j]);
//            }
//        }
//    }

//    return returnVal.ToArray();
//}