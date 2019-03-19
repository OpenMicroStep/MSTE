package com.openmicrostep.mste;

public class MSTEException extends Exception {

    public MSTEException() {
        super();
    }

    public MSTEException(String s) {
        super(s);
    }

    public MSTEException(String s, Exception e) {
        super(s, e);
    }
}
