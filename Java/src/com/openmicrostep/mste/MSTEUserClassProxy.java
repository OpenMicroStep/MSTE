package com.openmicrostep.mste;

import java.util.HashMap;

public class MSTEUserClassProxy {

    private final String className;
    private final HashMap<String, Object> data;

    public MSTEUserClassProxy(String className, HashMap<String, Object> data) {
        this.className = className;
        this.data = data;
    }

    public String getClassName() {
        return className;
    }

    public HashMap<String, Object> getData() {
        return data;
    }
}
