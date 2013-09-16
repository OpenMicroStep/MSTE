using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace MSTE {
    interface MSTEInterface {

        Hashtable Snapshot();
        void initWithDictionary(Dictionary<string, object> dict);

    }
}
