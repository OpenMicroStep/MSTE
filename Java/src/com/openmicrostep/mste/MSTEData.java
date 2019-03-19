package com.openmicrostep.mste;

import java.util.HashMap;

public class MSTEData {
    private final Object objects;
    private final long protocolVersion;
    private final long modelVersion;
    private final long mode;

    public MSTEData(Object msteDecoded) throws MSTEDataException {
        if (!(msteDecoded instanceof HashMap))
            throw new MSTEDataException("Decoded MSTE is not a dictionary");
        HashMap<String, Object> dictionary = (HashMap<String, Object>) msteDecoded;

        protocolVersion = getUInt32(dictionary, "protocolVersion");
        if (protocolVersion == 1 || protocolVersion == 2) {
            modelVersion = getUInt32(dictionary, "modelVersion");
        }
        else {
            throw new MSTEDataException("Unsupported protocol version, 1, 2 or 3 was expected");
        }

        mode = getUInt32(dictionary, "mode");
        objects = dictionary.get("objects");
    }

    public MSTEData(byte[] mste) throws MSTEDataException {
        this(getMsteDecoded(mste));
    }

    private static Object getMsteDecoded(byte[] mste) throws MSTEDataException {
        try {
            return new MSTDecoder().decodeObject(mste, true, true, new HashMap<String, String>());
        } catch (MSTEException e) {
            throw new MSTEDataException("Unable to decode MSTE", e);
        }
    }

    private static Long getUInt32(HashMap<String, Object> dictionary, String key) throws MSTEDataException {
        Object uInt32 = dictionary.get(key);
        if (!(uInt32 instanceof Number))
            throw new MSTEDataException(key + " is not an UInt32");
        return ((Number) uInt32).longValue();
    }

    public long getProtocolVersion() {
        return protocolVersion;
    }

    public boolean isValidModelVersion(long minVersion, long maxVersion) {
        return minVersion <= modelVersion && modelVersion <= maxVersion;
    }

    public long getModelVersion() {
        return modelVersion;
    }

    public long getMode() {
        return mode;
    }

    public Object getObjects() {
        return objects;
    }

    static public class MSTEDataException extends Exception {
        public MSTEDataException(String detailMessage) {
            super(detailMessage);
        }

        public MSTEDataException(String detailMessage, Throwable throwable) {
            super(detailMessage, throwable);
        }
    }
}
