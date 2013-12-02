using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace MSTEClasses {
    interface MSTEInterface {

        Dictionary<string, object> Snapshot();
        void initWithDictionary(Dictionary<string, object> dict);

    }

    class MSTEIMethods {

	    public const string CONSTR  = "newObject";
        public const string INIT    = "initWithDictionary";
        public const string SNAP    = "Snapshot";

    }
}
