package com.openmicrostep.mste;

public interface MSColor {

    String toString();

    float redComponent();

    float greenComponent();

    float blueComponent();

    float alphaComponent();

    float cyanComponent();

    float magentaComponent();

    float yellowComponent();

    float blackComponent();

    int red();

    int green();

    int blue();

    int opacity();

    int transparency();

    long rgbaValue();

    long cssValue();

    boolean isPaleColor();

    float luminance();

    MSColor lighterColor() throws MSTEException;

    MSColor darkerColor() throws MSTEException;

    MSColor lightestColor() throws MSTEException;

    MSColor darkestColor() throws MSTEException;

    MSColor matchingVisibleColor() throws MSTEException;

    MSColor colorWithAlpha(int opacity) throws MSTEException;

    boolean isEqualToColorObject(MSColor color);

    int compareToColorObject(MSColor color);
}
