using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework {
    public class MSTEException : Exception {

	    public MSTEException() : base() {
	    }
	    public MSTEException(String s) : base(s) {
		    
	    }
    }
}
