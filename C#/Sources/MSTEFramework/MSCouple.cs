using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework 
{
    public class MSCouple
    {
        #region Private attributes

        private object _firstObj;
        private object _secondObj;

        #endregion

        #region Public properties

        public virtual object FirstMember 
        {
            get { return _firstObj; }
            set { _firstObj = value; }
        }

        public virtual object SecondMember 
        {
            get { return _secondObj; }
            set { _secondObj = value; }
        }

        #endregion
    }
}
