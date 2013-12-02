package org.openmicrostep.mste;

public class MSNode {
	private Object _firstObj;
	private Object _secondObj;
	private int _reference;
	
	public Object getFirstMember(){	return _firstObj;}
	
	public Object getSecondMember(){ return _secondObj;}
	
	public int getReference(){ return _reference;}
	
	public void setFirstMember(Object aObj){ _firstObj=aObj;}
	
	public void setSecondMember(Object aObj){ _secondObj=aObj;}
	
	public void setReference(int ref){ _reference=ref;}
	
}