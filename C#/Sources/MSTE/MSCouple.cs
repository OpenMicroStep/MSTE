using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEClasses {
    public class MSCouple {
        private object _firstObj;
        private object _secondObj;

        public virtual object FirstMember {
            get {
                return _firstObj;
            }
            set {
                _firstObj = value;
            }
        }

        public virtual object SecondMember {
            get {
                return _secondObj;
            }
            set {
                _secondObj = value;
            }
        }
    }
}
