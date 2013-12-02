package org.openmicrostep.mste;

public interface MSColor {
	
	public String toString();
	public float redComponent() ;
	public float greenComponent() ;
	public float blueComponent() ;
	public float alphaComponent() ;

	public float cyanComponent() ;
	public float magentaComponent() ;
	public float yellowComponent() ;
	public float blackComponent() ;

	public int red() ;
	public int green() ;
	public int blue() ;
	public int opacity() ;
	public int transparency() ;

	public long rgbaValue() ;
	public long cssValue() ;

	public boolean isPaleColor() ;
	public float luminance() ;

	public MSColor lighterColor () throws MSTEException;
	public MSColor darkerColor() throws MSTEException;

	public MSColor lightestColor() throws MSTEException;
	public MSColor darkestColor() throws MSTEException;

	public MSColor matchingVisibleColor() throws MSTEException;

	public MSColor colorWithAlpha(int opacity) throws MSTEException ;

	public boolean isEqualToColorObject(MSColor color) ;
	public int compareToColorObject(MSColor color) ;
}