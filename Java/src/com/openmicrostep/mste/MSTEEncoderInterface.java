package com.openmicrostep.mste;


import java.util.HashMap;


public interface MSTEEncoderInterface {
    HashMap getSnapshot();

    void initWithDictionary(HashMap aDict);

}
