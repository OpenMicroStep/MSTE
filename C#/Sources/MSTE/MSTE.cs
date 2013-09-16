using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace MSTE {
    class MSTE {
	    // create object from MSTE string
	    public static object decode(string source) {
            object r = null;
		    try {
                r = MSTE._msteDecodePrivate(source, null) ;
		    }
		    catch (Exception e) { 
			     // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
			     Console.WriteLine("Unable to create MSTE object : " + e.Message); 
		    }
		    return r ;
	    }

        public static object decode(string source, Dictionary<string,object> options) {
            object r = null;
		    try {
                r = MSTE._msteDecodePrivate(source, options) ;
		    }
		    catch (Exception e) { 
			     // throw new Exception("Unable to create MSTE object : ".$e->getMessage()); 
			     Console.WriteLine("Unable to create MSTE object : " + e.Message); 
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

            return decoder.decodeObject(source.GetBytes(), vCRC, uUserClass);
	    }

        //private static function _msteEncodePrivate($rootObject) {
        //    $e = new MSTEEncoder($rootObject);	
        //    // echo '<hr>'.print_r($e,true).'<hr>';
        //    return $e->getTokens();
        //}

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