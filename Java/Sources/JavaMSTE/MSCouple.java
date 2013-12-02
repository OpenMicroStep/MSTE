package org.openmicrostep.mste;

public class MSCouple {
	private Object _firstObj;
	private Object _secondObj;
	
	public Object getFirstMember(){	return _firstObj;}
	
	public Object getSecondMember(){ return _secondObj;}
	
	public void setFirstMember(Object aObj){ _firstObj=aObj;}
	
	public void setSecondMember(Object aObj){ _secondObj=aObj;}
	
}