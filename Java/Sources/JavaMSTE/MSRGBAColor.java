package org.openmicrostep.mste;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MSRGBAColor implements MSColor {
	private int _red = 0;
	private int _green = 0;
	private int _blue = 0;
	private int _opacity = 255;
	private int _transparency = 255 - _opacity;
	private int OPAQUE_COLOR = -1;

	private static float _MSColorLuminance(int r, int g, int b, int a) { return (0.3f*r + 0.59f*g +0.11f*b)/255.0f ; }
	private static boolean _MSIsPaleColor(int r, int g, int b, int a) { return _MSColorLuminance(r, g, b, a) > 0.4f ? true : false; }
	private static float _Lighter(float x){return (2.0f*(x)*(x)/3.0f+(x)/2.0f+0.25f);}
	private static float _Darker(float x){return (-(x)*(x)/3+5.0f*(x)/6.0f);}
	
	
	private MSColor MSCreateComponentsColor (float rf, float gf, float bf, float af) throws MSTEException {				
		MSRGBAColor ret = new MSRGBAColor();
		if (ret != null) {
			int r = Math.round(Math.min(1.0f, rf) * 255);
			int g = Math.round(Math.min(1.0f, gf) * 255); 
			int b = Math.round(Math.min(1.0f, bf) * 255);
			int a = Math.round(Math.min(1.0f, af) * 255);
			ret.initWithRGBA(r,g,b,a);
		}
		return ret ;
	}
	
	private MSColor MSCreateColor(int r, int g, int b, int a) throws MSTEException {
		MSRGBAColor ret = new MSRGBAColor();
		if (ret!=null) {
			ret.initWithRGBA(r,g,b,a);
		}
		return ret ;
	}
	
	public MSRGBAColor() {}
	
	public void initWithCSSValue(long cssValue) throws MSTEException{
		int mask = 0xFF;
		
		if (cssValue <= 4294967296L){
			_opacity = 255 - (int)((cssValue >> 24) & mask);
			_red = (int)((cssValue >> 16) & mask);
			_green = (int)((cssValue >> 8) & mask);
			_blue = (int)(cssValue & mask);	
			_transparency = 255 - _opacity;		
		}
		else{
			throw new MSTEException("initWithCSSValue: CSS value too big !");
		}
	}
	
	public void initWithRGBAValue(long rgbaValue) throws MSTEException{
		initWithCSSValue(rgbaValue);
	}
	
	public void initWithRGB(int r, int g, int b) throws MSTEException {
		if (r<256){
			_red = r;
		}
		else{
			throw new MSTEException("initWithRGB: red value too big !");
		}
		if (g<256){
			_green = g;
		}
		else{
			throw new MSTEException("initWithRGB: green value too big !");
		}
		if (b<256){
			_blue = b;
		}
		else{
			throw new MSTEException("initWithRGB: blue value too big !");
		}
		_opacity=255;
		_transparency = 255 - _opacity;	
	}
	
	public void initWithRGBA(int r, int g, int b, int a) throws MSTEException{
		initWithRGB(r,g,b);
		if (a<256){
			_opacity = a;
			_transparency = 255 - _opacity;	
		}
		else{
			throw new MSTEException("initWithRGBA: opacity value too big !");
		}
		
	}
	
	public void initWithString(String aString) throws MSTEException {

		aString = aString.replace("#","");
		if (aString.length()>6){
			throw new MSTEException("initWithString: string length too long !");
		}
		if (aString.length()<3){
			throw new MSTEException("initWithString: string length too short !");
		}
		
		Pattern pattern = Pattern.compile("^(\\w{2})(\\w{2})(\\w{2})$");
		Matcher matcher = pattern.matcher(aString);
		
		if (!matcher.matches()){
			//splitString = (aString.split("^(\\w{1})(\\w{1})(\\w{1})$"));
			pattern = Pattern.compile("^(\\w{1})(\\w{1})(\\w{1})$");
			matcher = pattern.matcher(aString);
			//System.out.println("splitString count= " + splitString.length);		
			if (!matcher.matches()){
				throw new MSTEException("initWithString: no correct string !");			
			} 
		}
		
		_red = Integer.valueOf(matcher.group(1),16);
		if (_red>255) {_red=255;}
		if (_red<0) {_red=0;}
		_green = Integer.valueOf(matcher.group(2),16);
		if (_green>255) {_green=255;}
		if (_green<0) {_green=0;}
		_blue = Integer.valueOf(matcher.group(3),16);
		if (_blue>255) {_blue=255;}
		if (_blue<0) {_blue=0;}
		_opacity = 255;
		_transparency = 255 - _opacity;			
	}
	
	public void initWithColor(MSColor aColor){
		this._red = aColor.red();
		this._green = aColor.green();
		this._blue = aColor.blue();
		this._opacity = aColor.opacity();
		this._transparency = 255 - _opacity;	
	}
	
	
	public float redComponent() {	
		return ((float) _red)/255.0f;
	}
	
	public float greenComponent(){
		return ((float) _green)/255.0f;
	}
	
	public float blueComponent() {
		return ((float) _blue)/255.0f;
	}
	
	public float alphaComponent() {
		return ((float) _opacity)/255.0f;	
	}

	public float cyanComponent() {
		float C = 1.0f - ((float) _red)/255.0f ;
		float M = 1.0f - ((float) _green)/255.0f ;
		float Y = 1.0f - ((float) _blue)/255.0f ;
		float K = 1.0f ;
		if ( C < K ) K = C ;
		if ( M < K ) K = M ;
		if ( Y < K ) K = Y ;
		if (K >= 1.0f) return 0.0f ;	
		return (C - K) / (1 - K) ;
	}
	
	public float magentaComponent() {
		float C = 1.0f - ((float)_red)/255.0f ;
		float M = 1.0f - ((float)_green)/255.0f ;
		float Y = 1.0f - ((float)_blue)/255.0f ;
		float K = 1.0f ;
		if ( C < K ) K = C ;
		if ( M < K ) K = M ;
		if ( Y < K ) K = Y ;
		if (K >= 1.0f) return 0.0f ;
		return (M - K) / (1 - K) ;	
	}
	
	public float yellowComponent() {
		float C = 1.0f - ((float) _red)/255.0f ;
		float M = 1.0f - ((float) _green)/255.0f ;
		float Y = 1.0f - ((float) _blue)/255.0f ;
		float K = 1.0f ;
		if ( C < K ) K = C ;
		if ( M < K ) K = M ;
		if ( Y < K ) K = Y ;
		if (K >= 1.0f) return 0.0f ;
		return (Y - K) / (1 - K) ;
	}
	
	
	public float blackComponent() {
		float C = 1.0f - ((float) _red)/255.0f ;
		float M = 1.0f - ((float) _green)/255.0f ;
		float Y = 1.0f - ((float) _blue)/255.0f ;
		float K = 1.0f ;
		if ( C < K ) K = C ;
		if ( M < K ) K = M ;
		if ( Y < K ) K = Y ;
		return K ;		
	}

	public String toString(){
		if (this._opacity==255){
			return ("#" + String.format("%02x",this._red) + String.format("%02x",this._green) + String.format("%02x",this._blue));
		}
		else{
			return ("#" + String.format("%02x",this._transparency) + String.format("%02x",this._red) + String.format("%02x",this._green) + String.format("%02x",this._blue));
		}		
	}
	
	public int red() { return _red;}
	public int green() {return _green;}
	public int blue() {return _blue;}
	public int opacity() {return _opacity;}
	public int transparency() {return (255 - _opacity);}

	public long rgbaValue() {
		return ((long)_red<<24|(long)_green<<16|(long)_blue<<8|(long)_opacity);
	}
	
	public long cssValue() {		
		return ((long)_transparency<<24|(long)_red<<16|(long)_green<<8|(long)_blue);
	}

	public boolean isPaleColor() {
		return _MSIsPaleColor(_red, _green, _blue, _opacity) ;
	}
	
	public float luminance() {
		return _MSColorLuminance(_red, _green, _blue, _opacity) ;
	}

	public MSColor lighterColor() throws MSTEException{
	    float rf = this.redComponent();
	    float gf = this.greenComponent() ;
	    float bf = this.blueComponent() ;
	    return MSCreateComponentsColor(_Lighter(rf), _Lighter(gf), _Lighter(bf), this.alphaComponent()) ;		
	}
	
	public MSColor darkerColor() throws MSTEException{
	    float rf = this.redComponent();
	    float gf = this.greenComponent() ;
	    float bf = this.blueComponent() ;
		return MSCreateComponentsColor(_Darker(rf), _Darker(gf), _Darker(bf), this.alphaComponent()) ;
	}

	public MSColor lightestColor() throws MSTEException{
	    float rf = this.redComponent();
	    float gf = this.greenComponent() ;
	    float bf = this.blueComponent() ;
		rf = _Lighter(rf) ;
	    gf = _Lighter(gf) ;
	    bf = _Lighter(bf) ;
		return MSCreateComponentsColor(_Lighter(rf), _Lighter(gf), _Lighter(bf), this.alphaComponent()) ;			
	}
	
	public MSColor darkestColor() throws MSTEException{
	    float rf = this.redComponent();
	    float gf = this.greenComponent() ;
	    float bf = this.blueComponent() ;
		rf = _Darker(rf) ;
	    gf = _Darker(gf) ;
	    bf = _Darker(bf) ;
		return MSCreateComponentsColor(_Darker(rf), _Darker(gf), _Darker(bf), this.alphaComponent()) ;		
	}

	public MSColor matchingVisibleColor() throws MSTEException{
		return _MSIsPaleColor(this._red, this._green, this._blue, this._opacity) ? this.darkestColor() : this.lightestColor() ;
	}

	public MSColor colorWithAlpha(int opacity) throws MSTEException{
		return MSCreateColor(this._red, this._green, this._blue, opacity) ;
	}

	public boolean isEqualToColorObject(MSColor color) {
		if (color==null){return false;}
		if (this.equals(color)) {
			return true;
		}
		else{
			return false;
		}		
	}
		
	public int compareToColorObject(MSColor color) {
		if (this.equals(color)){return 0;}
		if (color==null){return -1;}
		long a = this.rgbaValue();
		long b = color.rgbaValue();
		if (a<b){return 1;};
		if (a>b){return -1;};
		return 0;
	}
}


