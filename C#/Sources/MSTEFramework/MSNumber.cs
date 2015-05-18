using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;

namespace MSTEFramework 
{
    public class MSNumber
    {
        #region Constructors

        public MSNumber() 
        {
        }

        public MSNumber(string s)
        {
            initWithString(s);
        }

        #endregion

        #region Initializer

        public void initWithString (string s) 
        {
                try 
                {
                    NumberStyles style = NumberStyles.AllowDecimalPoint | NumberStyles.AllowExponent;
                    CultureInfo provider = new CultureInfo("en-US");
                    this._decimalValue = Decimal.Parse(s, style, provider);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.ToString());
                    this._decimalValue = 0;
                }
        }

        #endregion

        #region Getters

        public decimal getDecimalValue()
        {
            return this._decimalValue;
        }

        #endregion

        #region Public Methods

        public override string ToString()
        {
            return this._decimalValue.ToString();
        }

        #endregion

        #region Private attributes

        decimal _decimalValue;

        #endregion
    }
}
