using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework {
    class MSType {
	    public const string MSOBJECT 		= "MSObject";
	    public const string MSARRAY 		= "MSArray"; 
	    public const string MSNATURALARRAY	= "MSNaturalArray";
	    public const string MSDICT 			= "MSDict";
	    public const string MSCOUPLE		= "MSCouple";
	    public const string MSDATE 			= "MSDate";
	    public const string MSCOLOR 		= "MSColor";
	    public const string MSDATA 			= "MSData";
        public const string MSSTRING        = "MSString";
    } 

    //// -----------------------------------------------------------------------------
    //// Class Object : bases class for decoding
    //// -----------------------------------------------------------------------------
    //public class MSObject  {

    //    protected Dictionary<string,MSObject> _values;
    //    public string className;
    //    public string isA;

    //    public MSObject() {
    //        this.isA = MSType.MSOBJECT;
    //    }

    //    public MSObject getValueFromKey(string key) {
    //        if (this._values.Count == 0) {return null;}
    //        return this._values.ContainsKey(key) ? this._values[key] : null;
    //    }

    //    public void setObjectForKey(ref MSObject value, string key) {
    //        this._values.Add(key, value);
    //    }

    //    public void setValueForKey(MSObject value, string key) {
    //        this._values.Add(key, value);
    //    }

    //    public void setValueForKey(string value, string key) {
    //        this._values.Add(key, value);
    //    }

    //    public Dictionary<string, MSObject> getValues() {
    //        return this._values;
    //    }
    //}


    //class MSString : MSObject{
    	
    //    const string S_STRING = "sString";
    //    const string S_LENGHT = "sLength";
    	
    //    public MSString(string s) {
    //        this.isA = MSType.MSSTRING;
    //        this.setString(s);
    //        this.setLength(s.Length);
    //    }

    //    // getters
    //    MSObject getValueFromKey(string key) {
    //        if (key == MSString.S_STRING || key == MSString.S_LENGHT) { 
    //            return this._values[key];
    //        }
    //    }
    //    string getString() {
    //        return this.getValueFromKey(MSString.S_STRING);
    //    }
    //    string toString() {
    //        return this.getValueFromKey(MSString.S_STRING);
    //    }
    //    int getLength() {
    //        return this.getValueFromKey(MSString.S_LENGHT);
    //    }

    //    // setters
    //    void setObjectForKey(ref MSObject value, string key) {
    //        if (key == MSString.S_STRING || key == MSString.S_LENGHT) { 
    //            this._values.Add(key, value);
    //        }
    //    }
    //    void setString(ref MSObject value) {
    //        this->setObjectForKey(value, MSString.S_STRING);
    //    }

    //    void setLength(ref int value) {
    //        this.setObjectForKey(value, MSString.S_LENGHT);
    //    }
    //}

}
