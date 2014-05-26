using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework {
    public class MSData {
        byte[] _dataValue;

        public MSData() {
            this._dataValue = new byte[0];
        }

        protected void setValue(byte[] b) {
            this._dataValue = b;
        }

        public static MSData initWithString(string s) {
            MSData md = new MSData();
            try {
                md.setValue(ASCIIEncoding.ASCII.GetBytes(s));
                
            }
            catch (Exception e) {
                Console.WriteLine(e.ToString());
            }
            return md;
        }

        public static MSData initWithData(byte[] b) {
            MSData md = new MSData();
            try {
                md.setValue(b);
            }
            catch (Exception e) {
                Console.WriteLine(e.ToString());
            }
            return md;
        }

        public int getLength() {
            return this.getValue().Length;
        }

        public string getValue() {
            if (this._dataValue != null && this._dataValue.Length>0) {
                return Encoding.ASCII.GetString(this._dataValue);
            }
            else {
                return ""; 
            }
        }

        public byte[] getRawValue() {
            return this._dataValue;
        }        
        
        public override string ToString() {
            return this.getValue().ToString();
        }
    
    }
}
