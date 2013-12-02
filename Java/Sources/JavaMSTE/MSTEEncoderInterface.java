package org.openmicrostep.mste;


import java.util.HashMap;



public interface MSTEEncoderInterface{ 
	public HashMap getSnapshot();
	public void initWithDictionary(HashMap aDict);
   
}