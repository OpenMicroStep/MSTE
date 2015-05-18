using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework 
{
    public class MSColor
    {
        #region Constructor

        public MSColor() 
        {
            if (!InstanceFieldsInitialized) 
            {
                InitializeInstanceFields();
                InstanceFieldsInitialized = true;
            }
        }

        #endregion

        #region Initializers

        public virtual MSColor initWithRGB(int red, int green, int blue, int opacity)
        {
            _red = red;
            _green = green;
            _blue = blue;
            _opacity = opacity;
            return this;
        }

        public virtual void initWithCSSColor(long? trgb)
        {
            _opacity = (int)(255 - ((trgb >> 24) & 0xff));
            _red = (int)((trgb >> 16) & 0xff);
            _green = (int)((trgb >> 8) & 0xff);
            _blue = (int)(trgb & 0xff);
        }

        #endregion

        #region Public Methods

        public override string ToString()
        {
            string strColor = "";
            if (_opacity == OPAQUE_COLOR)
                strColor = string.Format("#{0:x2}{1:x2}{2:x2}", _red, _green, _blue);
            else
                strColor = string.Format("#{0:x2}{1:x2}{2:x2}{3:x2}", _transparency, _red, _green, _blue);
            return strColor;
        }

        #endregion

        #region Private Methods

        private void InitializeInstanceFields() 
        {
            _transparency = 255 - _opacity;
        }

        #endregion

        #region Private Properties

        private bool InstanceFieldsInitialized = false;
        private int _red = 0;
        private int _green = 0;
        private int _blue = 0;
        private int _opacity = 255;
        private int _transparency;
        private int OPAQUE_COLOR = -1;

        #endregion
    }
}
