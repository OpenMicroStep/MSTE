using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework 
{
    public class MSData
    {

        #region Constructor

        public MSData() 
        {
            this._dataValue = new byte[0];
        }

        #endregion

        #region Initializers

        public static MSData initWithString(string s) 
        {
            MSData md = new MSData();
            try 
            {
                md.setValue(ASCIIEncoding.ASCII.GetBytes(s));
            }
            catch (Exception e) 
            {
                Console.WriteLine(e.ToString());
            }
            return md;
        }

        public static MSData initWithData(byte[] b) 
        {
            MSData md = new MSData();
            try 
            {
                md.setValue(b);
            }
            catch (Exception e) 
            {
                Console.WriteLine(e.ToString());
            }
            return md;
        }

        #endregion

        #region Public Getters

        public int getLength() 
        {
            return this.getValue().Length;
        }

        public string getValue() 
        {
            if (this._dataValue != null && this._dataValue.Length>0)
                return Encoding.ASCII.GetString(this._dataValue);
            else
                return ""; 
        }

        public byte[] getRawValue() 
        {
            return this._dataValue;
        }        
        
        public override string ToString() 
        {
            return this.getValue().ToString();
        }

        #endregion

        #region Setters

        protected void setValue(byte[] b)
        {
            this._dataValue = b;
        }

        #endregion

        #region Private attributes

        byte[] _dataValue;

        #endregion

    }
}
