package com.openmicrostep.mste;
//
//  MSTEDecoder.java
//
//
//

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.HashMap;

public class MSTDecoder {

    final String MSTE_CURRENT_VERSION = "0102";

    final int MSTE_TOKEN_MUST_ENCODE = -1;

    final int MSTE_TOKEN_TYPE_NULL = 0;
    final int MSTE_TOKEN_TYPE_TRUE = 1;
    final int MSTE_TOKEN_TYPE_FALSE = 2;
    final int MSTE_TOKEN_TYPE_EMPTY_STRING = 3;
    final int MSTE_TOKEN_TYPE_EMPTY_DATA = 4;

    final int MSTE_TOKEN_TYPE_REFERENCED_OBJECT = 9;

    final int MSTE_TOKEN_TYPE_CHAR = 10;
    final int MSTE_TOKEN_TYPE_UNSIGNED_CHAR = 11;
    final int MSTE_TOKEN_TYPE_SHORT = 12;
    final int MSTE_TOKEN_TYPE_UNSIGNED_SHORT = 13;
    final int MSTE_TOKEN_TYPE_INT32 = 14;
    final int MSTE_TOKEN_TYPE_INSIGNED_INT32 = 15;
    final int MSTE_TOKEN_TYPE_INT64 = 16;
    final int MSTE_TOKEN_TYPE_UNSIGNED_INT64 = 17;
    final int MSTE_TOKEN_TYPE_FLOAT = 18;
    final int MSTE_TOKEN_TYPE_DOUBLE = 19;

    final int MSTE_TOKEN_TYPE_DECIMAL_VALUE = 20;
    final int MSTE_TOKEN_TYPE_STRING = 21;
    final int MSTE_TOKEN_TYPE_DATE = 22;
    final int MSTE_TOKEN_TYPE_TIMESTAMP = 23;

    final int MSTE_TOKEN_TYPE_COLOR = 24;
    final int MSTE_TOKEN_TYPE_BASE64_DATA = 25;
    final int MSTE_TOKEN_TYPE_NATURAL_ARRAY = 26;

    final int MSTE_TOKEN_TYPE_DICTIONARY = 30;
    final int MSTE_TOKEN_TYPE_ARRAY = 31;
    final int MSTE_TOKEN_TYPE_COUPLE = 32;
    final int MSTE_TOKEN_LAST_DEFINED_TYPE = MSTE_TOKEN_TYPE_COUPLE;
    final int MSTE_TOKEN_TYPE_USER_CLASS = 50;
    final int MSTE_DECODING_ARRAY_START = 0;
    final int MSTE_DECODING_VERSION_START = 1;
    final int MSTE_DECODING_VERSION_HEADER = 2;
    final int MSTE_DECODING_VERSION_VALUE = 3;
    final int MSTE_DECODING_VERSION_END = 4;
    final int MSTE_DECODING_VERSION_NEXT_TOKEN = 5;
    final int MSTE_DECODING_TOKEN_NUMBER_VALUE = 6;
    final int MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN = 7;
    final int MSTE_DECODING_CRC_START = 8;
    final int MSTE_DECODING_CRC_HEADER = 9;
    final int MSTE_DECODING_CRC_VALUE = 10;
    final int MSTE_DECODING_CRC_END = 11;
    final int MSTE_DECODING_CRC_NEXT_TOKEN = 12;
    final int MSTE_DECODING_CLASSES_NUMBER_VALUE = 13;
    final int MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN = 14;
    final int MSTE_DECODING_CLASS_NAME = 15;
    final int MSTE_DECODING_CLASS_NEXT_TOKEN = 16;
    final int MSTE_DECODING_KEYS_NUMBER_VALUE = 17;
    final int MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN = 18;
    final int MSTE_DECODING_KEY_NAME = 19;
    final int MSTE_DECODING_KEY_NEXT_TOKEN = 20;
    final int MSTE_DECODING_ROOT_OBJECT = 21;
    final int MSTE_DECODING_ARRAY_END = 22;
    final int MSTE_DECODING_GLOBAL_END = 23;

    final int MSTE_DECODING_STRING_START = 0;
    final int MSTE_DECODING_STRING = 1;
    final int MSTE_DECODING_STRING_ESCAPED_CAR = 2;
    final int MSTE_DECODING_STRING_STOP = 3;

    final long MSUShortMax = 65535;
    final long MSIntMax = 2147483647;
    final long MSIntMin = (-MSIntMax - 1);
    final long MSUIntMax = 4294967295L;
    final long MSShortMax = 32767;
    final long MSShortMin = -32768;
    final long MSCharMax = 127;
    final long MSCharMin = -128;
    final long MSByteMax = 255;

    // ========= constructors and destructors =========
    public MSTDecoder() {
    }

    private static byte[] decodeFromBase64(String s) {

        return Base64Coder.decode(s);

    }

    //=============Implements=============================

    private void _MSTJumpToNextToken(byte[] data, int[] pos, int[] tokenCount) throws MSTEException {
        int len = data.length;
        Boolean separatorFound = false;
        Boolean nextFound = false;
        while ((!separatorFound) && (pos[0] < len)) {
            if ((char) data[pos[0]] == ' ') {
                pos[0]++;
            } else if ((char) data[pos[0]] == ',') {
                pos[0]++;
                separatorFound = true;
                tokenCount[0]++;
            } else {
                throw new MSTEException("_MSTJumpToNextToken: - Bad format (unexpected character before token separator:" + (char) data[pos[0]]);
            }
        }
        if (!separatorFound) {
            throw new MSTEException("_MSTJumpToNextToken: - Bad format (no token separator)");
        }
        while (!nextFound && (pos[0] < len)) {
            if ((char) data[pos[0]] == ' ') {
                pos[0]++;
            }
            nextFound = ((char) data[pos[0]] != ' ');
        }
        if (!nextFound) {
            throw new MSTEException("_MSTJumpToNextToken: - Bad format (no next token)");
        }

    }

    private Object _MSTDecodeNumber(byte[] data, int[] pos, int tokenType) throws MSTEException {
        Object ret;

        switch (tokenType) {
            case MSTE_TOKEN_TYPE_DECIMAL_VALUE: {
                ret = _MSTDecodeDecimal(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_DOUBLE: {
                ret = _MSTDecodeDouble(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_CHAR: {
                ret = _MSTDecodeChar(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_UNSIGNED_CHAR: {
                ret = _MSTDecodeUnsignedChar(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_SHORT: {
                ret = _MSTDecodeShort(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_UNSIGNED_SHORT: {
                ret = _MSTDecodeUnsignedShort(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_INT32: {
                ret = _MSTDecodeInt(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_INSIGNED_INT32: {
                ret = _MSTDecodeUnsignedInt(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_INT64: {
                ret = _MSTDecodeLong(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_UNSIGNED_INT64: {
                ret = _MSTDecodeUnsignedLong(data, pos, "_MSTDecodeNumber");
                break;
            }
            case MSTE_TOKEN_TYPE_FLOAT: {
                ret = _MSTDecodeFloat(data, pos, "_MSTDecodeNumber");
                break;
            }
            default: {
                throw new MSTEException("_MSTDecodeNumber - unknown tokenType :" + tokenType);
            }
        }
        return ret;
    }

    private Byte _MSTDecodeChar(byte[] data, int[] pos, String operation) throws MSTEException {
        Byte value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeChar:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            Long l = Long.parseLong(sb.toString());
            if ((l < MSCharMax) && (l > MSCharMin)) {
                value = Byte.parseByte(sb.toString());
            } else {
                throw new MSTEException("_MSTDecodeChar: - out of range (" + sb.toString() + ")");
            }
        }
        return value;
    }

    private Short _MSTDecodeUnsignedChar(byte[] data, int[] pos, String operation) throws MSTEException {
        Short value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeChar:" + operation + " (no termination) ");
        }
        if (sb.length() > 0) {
            Long l = Long.parseLong(sb.toString());
            if ((l < MSByteMax) && (l >= 0)) {
                value = Short.parseShort(sb.toString());
            } else {
                throw new MSTEException("_MSTDecodeChar: - out of range (" + sb.toString() + ")");
            }
        }
        return value;
    }

    private Float _MSTDecodeFloat(byte[] data, int[] pos, String operation) throws MSTEException {
        Float value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeFloat:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            value = Float.parseFloat(sb.toString());
        }
        return value;
    }

    private Double _MSTDecodeDouble(byte[] data, int[] pos, String operation) throws MSTEException {
        Double value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeDouble:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            value = Double.parseDouble(sb.toString());
        }
        return value;
    }

    private BigDecimal _MSTDecodeDecimal(byte[] data, int[] pos, String operation) throws MSTEException {
        BigDecimal value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeDecimal:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            value = new BigDecimal(sb.toString());
        }
        return value;
    }

    private Long _MSTDecodeUnsignedInt(byte[] data, int[] pos, String operation) throws MSTEException {
        Long value = null;
        int len = data.length;
        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }

        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeInt:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            Long l = Long.parseLong(sb.toString());
            if ((l < MSUIntMax) && (l >= 0)) {
                value = Long.parseLong(sb.toString());
            } else {
                throw new MSTEException("_MSTDecodeInt: - out of range (" + sb.toString() + ")");
            }
        }

        return value;
    }

    private Integer _MSTDecodeInt(byte[] data, int[] pos, String operation) throws MSTEException {
        Integer value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeInt:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            Long l = Long.parseLong(sb.toString());
            if ((l < MSIntMax) && (l > MSIntMin)) {
                value = Integer.parseInt(sb.toString());
            } else {
                throw new MSTEException("_MSTDecodeInt: - out of range (" + sb.toString() + ")");
            }
        }
        return value;
    }

    private Long _MSTDecodeLong(byte[] data, int[] pos, String operation) throws MSTEException {
        Long value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeLong - " + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            value = Long.parseLong(sb.toString());
        }
        return value;
    }

    private Long _MSTDecodeUnsignedLong(byte[] data, int[] pos, String operation) throws MSTEException {
        Long value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeUnsignedLong - " + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            try {
                value = Long.parseLong(sb.toString());
            } catch (Exception e) {
                throw new MSTEException("_MSTDecodeUnsignedLong : unable to parse value " + sb.toString() + " - error : " + e.toString());
            }
        }
        return value;
    }

    private Integer _MSTDecodeUnsignedShort(byte[] data, int[] pos, String operation) throws MSTEException {
        Integer value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeUnsignedShort:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            Long l = Long.parseLong(sb.toString());
            if ((l <= MSUShortMax) && (l >= 0)) {
                value = Integer.parseInt(sb.toString());
            } else {
                throw new MSTEException("_MSTDecodeUnsignedShort: - out of range (" + sb.toString() + ")");
            }
        }
        return value;
    }

    private Short _MSTDecodeShort(byte[] data, int[] pos, String operation) throws MSTEException {
        Short value = null;
        int len = data.length;

        StringBuffer sb = new StringBuffer();
        while (pos[0] < len) {
            if ((char) data[pos[0]] != ',') {
                if ((Character.isDigit((char) data[pos[0]])) || ((char) data[pos[0]] == '-') || ((char) data[pos[0]] == '.')) {
                    sb.append((char) data[pos[0]]);
                } else {
                    break;
                }
            } else {
                break;
            }
            pos[0]++;
        }
        if (pos[0] == len) {
            throw new MSTEException("_MSTDecodeShort:" + operation + " (no termination) ");
        }

        if (sb.length() > 0) {
            Long l = Long.parseLong(sb.toString());
            if ((l < MSShortMax) && (l > MSShortMin)) {
                value = Short.parseShort(sb.toString());
            } else {
                throw new MSTEException("_MSTDecodeShort: - out of range (" + sb.toString() + ")");
            }
        }
        return value;
    }

    private MSColor _MSTDecodeColor(byte[] data, int[] pos, String operation) throws MSTEException {
        MSRGBAColor ret = new MSRGBAColor();
        long trgbValue = _MSTDecodeUnsignedInt(data, pos, operation);
        ret.initWithCSSValue(trgbValue);
        return ret;
    }

    private ArrayList<Object> _MSTDecodeArray(byte[] data, int[] pos, String operation, ArrayList<Object> decodedObjects, ArrayList<String> classes, ArrayList<String> keys, int[] tokenCount, Boolean allowsUnknownUserClasses, HashMap<String, String> nameSpace) throws MSTEException {
        long count = _MSTDecodeUnsignedInt(data, pos, operation);
        ArrayList<Object> ret = new ArrayList<Object>();
        decodedObjects.add(ret);
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                Boolean isWeakRef = false;
                Object object;
                _MSTJumpToNextToken(data, pos, tokenCount);
                object = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses, nameSpace);
                ret.add(object);
                if (isWeakRef) {
                    throw new MSTEException("_MSTDecodeArray: - Weakly referenced object encountered while decoding an array!");
                }
            }
        }
        return ret;
    }

    private ArrayList<Long> _MSTDecodeNaturalArray(byte[] data, int[] pos, String operation, ArrayList<Object> decodedObjects, int[] tokenCount) throws MSTEException {
        long count = _MSTDecodeUnsignedInt(data, pos, operation);
        ArrayList<Long> ret = new ArrayList<Long>();
        decodedObjects.add(ret);
        Long val;
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                _MSTJumpToNextToken(data, pos, tokenCount);
                val = _MSTDecodeUnsignedLong(data, pos, operation);
                ret.add(val);
            }
        }
        return ret;
    }

    private byte[] _MSTDecodeBufferBase64String(byte[] data, int[] pos, String operation) throws MSTEException {
        byte[] ret = null;
        String base64String = _MSTDecodeString(data, pos, operation);
        if (base64String.length() > 0) {
            ret = decodeFromBase64(base64String);
        }
        return ret;
    }

    private MSCouple _MSTDecodeCouple(byte[] data, int[] pos, String operation, ArrayList<Object> decodedObjects, ArrayList<String> classes, ArrayList<String> keys, int[] tokenCount, Boolean allowsUnknownUserClasses, HashMap<String, String> nameSpace) throws MSTEException {
        MSCouple ret = new MSCouple();
        Object firstMember = null;
        Object secondMember = null;
        Boolean isWeakRef = false;
        decodedObjects.add(ret);
        firstMember = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses, nameSpace);
        if (isWeakRef) {
            throw new MSTEException("_MSTDecodeCouple: - Weakly referenced object encountered while decoding an MSCouple!");
        }

        _MSTJumpToNextToken(data, pos, tokenCount);
        secondMember = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses, nameSpace);
        if (isWeakRef) {
            throw new MSTEException("_MSTDecodeCouple: - Weakly referenced object encountered while decoding an MSCouple!");
        }

        ret.setFirstMember(firstMember);
        ret.setSecondMember(secondMember);

        return ret;
    }

    private Object _MSTDecodeUserDefinedObject(byte[] data, int[] pos, String operation, int tokenType, ArrayList<Object> decodedObjects, ArrayList<String> classes, ArrayList<String> keys, int[] tokenCount, Boolean allowsUnknownUserClasses, HashMap<String, String> nameSpace) throws MSTEException {
        Object ret = null;
        //int classIndex = (tokenType - MSTE_TOKEN_TYPE_USER_CLASS) / 2;
        int classIndex = tokenType - MSTE_TOKEN_TYPE_USER_CLASS;
        if (classIndex >= 0 && classIndex < classes.size()) {
            String className = classes.get(classIndex);
            if (nameSpace.containsKey(className)) {
                className = nameSpace.get(className);
            }
            Class<?> aClass = null;
            try {
                try {
                    aClass = Class.forName(className);
                } catch (Exception e) {
                    aClass = null;
                }
                if (aClass != null) {
                    ret = aClass.newInstance();
                    HashMap<String, Object> dictionary = new HashMap<String, Object>();
                    decodedObjects.add(ret);
                    dictionary = _MSTDecodeDictionary(data, pos, operation, decodedObjects, classes, keys, tokenCount, false, true, allowsUnknownUserClasses, nameSpace);
                    Class params[] = new Class[1];
                    params[0] = HashMap.class;
                    java.lang.reflect.Method myMethod = aClass.getDeclaredMethod("initWithDictionary", params);
                    myMethod.invoke(ret, dictionary);
                } else if (allowsUnknownUserClasses) {
                    HashMap<String, Object> dictionary = _MSTDecodeDictionary(data, pos, "_MSTDecodeUserDefinedObject", decodedObjects, classes, keys, tokenCount, true, true, allowsUnknownUserClasses, nameSpace);
                    ret = new MSTEUserClassProxy(className, dictionary);
                } else {
                    throw new MSTEException("_MSTDecodeUserDefinedObject: -	unable to find user class " + className + " in current system");
                }
            } catch (Exception e) {
                throw new MSTEException("_MSTDecodeUserDefinedObject : unable to create user class instance !" + e.toString());
            }
        } else {
            throw new MSTEException("_MSTDecodeUserDefinedObject: -	unable to find user class at index " + classIndex);
        }
        return ret;
    }

    private String _MSTDecodeString(byte[] data, int[] pos, String operation) throws MSTEException {
        int state = MSTE_DECODING_STRING_START;
        Boolean endStringFound = false;
        StringBuffer sb = new StringBuffer();
        int len = data.length;

        while ((pos[0] < len) && (!endStringFound)) {
            switch (state) {
                case MSTE_DECODING_STRING_START: {
                    if ((char) data[pos[0]] == '"') {
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                    } else {
                        throw new MSTEException("_MSTDecodeString: (wrong starting character) : " + operation);
                    }
                    break;
                }
                case MSTE_DECODING_STRING: {
                    if ((char) data[pos[0]] == '\\') {
                        pos[0]++;
                        state = MSTE_DECODING_STRING_ESCAPED_CAR;
                        break;
                    }
                    if ((char) data[pos[0]] == '"') {
                        pos[0]++;
                        state = MSTE_DECODING_STRING_STOP;
                        endStringFound = true;
                        break;
                    }

                    if ((char) data[pos[0]] <= 0x7F) {
                        sb.append((char) data[pos[0]]);
                        pos[0]++;
                    } else {
                        int lenChar = 0;
                        if (((char) data[pos[0]] >= 0xC2) && ((char) data[pos[0]] <= 0xDF)) {
                            lenChar = 2;
                        } else if (((char) data[pos[0]] >= 0xE0) && ((char) data[pos[0]] <= 0xEF)) {
                            lenChar = 3;
                        } else if (((char) data[pos[0]] >= 0xF0) && ((char) data[pos[0]] <= 0xF4)) {
                            lenChar = 4;
                        }
                        if (lenChar > 0) {
                            byte[] dataChar = new byte[lenChar];
                            for (int i = 0; i < lenChar; i++) {
                                dataChar[i] = data[pos[0]];
                            }
                            try {
                                sb.append(new String(dataChar, "UTF-8"));
                            } catch (java.io.UnsupportedEncodingException e) {
                                throw new MSTEException("_MSTDecodeString ERROR UnsupportedEncodingException:" + e.getMessage());
                            }
                            pos[0] = pos[0] + lenChar;
                        } else {
                            throw new MSTEException("_MSTDecodeString -Bad first byte value on a supposed UTF-8 character: " + (char) data[pos[0]]);
                        }
                    }
                    break;
                }
                case MSTE_DECODING_STRING_ESCAPED_CAR: {
                    if ((char) data[pos[0]] == '"') {
                        int hexToInt = Integer.parseInt("0022", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == '\\') {
                        int hexToInt = Integer.parseInt("005c", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == '/') {
                        int hexToInt = Integer.parseInt("002F", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == 'b') {
                        int hexToInt = Integer.parseInt("0008", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == 'f') {
                        int hexToInt = Integer.parseInt("0012", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == 'n') {
                        int hexToInt = Integer.parseInt("000a", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == 'r') {
                        int hexToInt = Integer.parseInt("000d", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == 't') {
                        int hexToInt = Integer.parseInt("0009", 16);
                        char intToChar = (char) hexToInt;
                        sb.append(intToChar);
                        pos[0]++;
                        state = MSTE_DECODING_STRING;
                        break;
                    } else if ((char) data[pos[0]] == 'u') {
                        //UTF16 value on 4 hexadecimal characters expected
                        if ((pos[0] + 4) > len) {
                            throw new MSTEException("_MSTDecodeString: (too short UTF16 character expected) " + operation);
                        }
                        Character s0 = (char) data[pos[0] + 1];
                        Character s1 = (char) data[pos[0] + 2];
                        Character s2 = (char) data[pos[0] + 3];
                        Character s3 = (char) data[pos[0] + 4];
                        if ((!s0.toString().matches("[0-9A-Fa-f]+")) ||
                                (!s1.toString().matches("[0-9A-Fa-f]+")) ||
                                (!s2.toString().matches("[0-9A-Fa-f]+")) ||
                                (!s3.toString().matches("[0-9A-Fa-f]+"))) {
                            throw new MSTEException("_MSTDecodeString: (bad hexadecimal character for UTF16) " + operation);
                        } else {
                            StringBuffer sbChar = new StringBuffer();
                            sbChar.append(s0);
                            sbChar.append(s1);
                            sbChar.append(s2);
                            sbChar.append(s3);
                            int hexVal = Integer.parseInt(sbChar.toString(), 16);
                            Character car = (char) hexVal;
                            sb.append(car);
                            pos[0] = pos[0] + 5;
                            state = MSTE_DECODING_STRING;
                        }
                        break;
                    } else {
                        throw new MSTEException("_MSTDecodeString: (unexpected escaped character) " + operation);
                    }
                }
                default: {
                    throw new MSTEException("_MSTDecodeString: (unknown state) " + operation);
                }
            }
        }
        return sb.toString();
    }

    private Object _MSTDecodeObject(byte[] data, int[] pos, String operation, ArrayList<Object> decodedObjects, ArrayList<String> classes, ArrayList<String> keys, int[] tokenCount, Boolean isWeaklyReferenced, Boolean allowsUnknownUserClasses, HashMap<String, String> nameSpace) throws MSTEException {
        int len = data.length;
        Object ret = null;

        int tokenType = _MSTDecodeUnsignedShort(data, pos, "token type");
        switch (tokenType) {

            case MSTE_TOKEN_TYPE_NULL: {
                //nothing to do: returning nil
                break;
            }
            case MSTE_TOKEN_TYPE_TRUE: {
                ret = true;
                break;
            }
            case MSTE_TOKEN_TYPE_FALSE: {
                ret = false;
                break;
            }
            case MSTE_TOKEN_TYPE_DECIMAL_VALUE: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeNumber(data, pos, tokenType);
                decodedObjects.add(ret);
                break;
            }

/*
            case MSTE_TOKEN_TYPE_INTEGER_VALUE :
			case MSTE_TOKEN_TYPE_REAL_VALUE : {
				_MSTJumpToNextToken(data,pos,tokenCount);
				ret = _MSTDecodeNumber(data, pos, tokenType);
				decodedObjects.add(ret);
				break;
			}
*/
            case MSTE_TOKEN_TYPE_CHAR:
            case MSTE_TOKEN_TYPE_UNSIGNED_CHAR:
            case MSTE_TOKEN_TYPE_SHORT:
            case MSTE_TOKEN_TYPE_UNSIGNED_SHORT:
            case MSTE_TOKEN_TYPE_INT32:
            case MSTE_TOKEN_TYPE_INSIGNED_INT32:
            case MSTE_TOKEN_TYPE_INT64:
            case MSTE_TOKEN_TYPE_UNSIGNED_INT64:
            case MSTE_TOKEN_TYPE_FLOAT:
            case MSTE_TOKEN_TYPE_DOUBLE: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeNumber(data, pos, tokenType);
                break;
            }
            case MSTE_TOKEN_TYPE_STRING: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeString(data, pos, "_MSTDecodeObject");
                decodedObjects.add(ret);
                break;
            }
            case MSTE_TOKEN_TYPE_DATE: {
                Long seconds = Long.MIN_VALUE;
                _MSTJumpToNextToken(data, pos, tokenCount);
                seconds = _MSTDecodeLong(data, pos, "_MSTDecodeObject");
                ret = LocalDateTime.ofEpochSecond(seconds, 0, ZoneOffset.UTC);
                decodedObjects.add(ret);
                break;
            }
            case MSTE_TOKEN_TYPE_TIMESTAMP: {
                Long seconds = Long.MIN_VALUE;
                _MSTJumpToNextToken(data, pos, tokenCount);
                //seconds = _MSTDecodeLong (data, pos, "_MSTDecodeObject");
                double s = (Double) _MSTDecodeNumber(data, pos, MSTE_TOKEN_TYPE_DOUBLE);
                seconds = Math.round(s);
                ret = new java.util.Date(seconds * 1000);
                decodedObjects.add(ret);
                break;
            }
            case MSTE_TOKEN_TYPE_DICTIONARY: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeDictionary(data, pos, "_MSTDecodeObject", decodedObjects, classes, keys, tokenCount, true, false, allowsUnknownUserClasses, nameSpace);
                break;
            }
            case MSTE_TOKEN_TYPE_REFERENCED_OBJECT: {
                Integer objectReference;
                _MSTJumpToNextToken(data, pos, tokenCount);
                objectReference = _MSTDecodeInt(data, pos, "_MSTDecodeObject");
                ret = decodedObjects.get(objectReference);
                break;
            }
            case MSTE_TOKEN_TYPE_COLOR: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeColor(data, pos, "_MSTDecodeObject");
                decodedObjects.add(ret);
                break;
            }
            case MSTE_TOKEN_TYPE_ARRAY: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeArray(data, pos, operation, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses, nameSpace);
                break;
            }
            case MSTE_TOKEN_TYPE_NATURAL_ARRAY: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                //ret = _MSTDecodeArray(data, pos, operation, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses,nameSpace);
                ret = _MSTDecodeNaturalArray(data, pos, operation, decodedObjects, tokenCount);
                break;
            }
            case MSTE_TOKEN_TYPE_COUPLE: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeCouple(data, pos, operation, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses, nameSpace);
                break;
            }
            case MSTE_TOKEN_TYPE_BASE64_DATA: {
                _MSTJumpToNextToken(data, pos, tokenCount);
                ret = _MSTDecodeBufferBase64String(data, pos, operation);
                decodedObjects.add(ret);
                break;
            }
            case MSTE_TOKEN_TYPE_EMPTY_STRING: {
                ret = "";
                break;
            }
            case MSTE_TOKEN_TYPE_EMPTY_DATA: {
                ret = new byte[0];
                break;
            }
            default: {
                if (tokenType >= MSTE_TOKEN_TYPE_USER_CLASS) {
                    _MSTJumpToNextToken(data, pos, tokenCount);
                    ret = _MSTDecodeUserDefinedObject(data, pos, operation, tokenType, decodedObjects, classes, keys, tokenCount, allowsUnknownUserClasses, nameSpace);
                    isWeaklyReferenced = false;
                } else {
                    throw new MSTEException("_MSTDecodeObject - unknown tokenType : " + tokenType);
                }
                break;
            }
        }
        return ret;
    }

    private HashMap<String, Object> _MSTDecodeDictionary(byte[] data, int[] pos, String operation, ArrayList<Object> decodedObjects, ArrayList<String> classes, ArrayList<String> keys, int[] tokenCount, Boolean manageReference, Boolean decodingUserClass, Boolean allowsUnknownUserClasses, HashMap<String, String> nameSpace) throws MSTEException {
        HashMap<String, Object> ret = new HashMap<String, Object>();
        Long count = _MSTDecodeUnsignedLong(data, pos, operation);

        if (manageReference) {
            decodedObjects.add(ret);
        }

        if (count > 0) {
            for (int i = 0; i < count; i++) {
                Boolean isWeakRef = false;
                long keyReference = 0;
                Object object = 0;
                String key = "";
                _MSTJumpToNextToken(data, pos, tokenCount);
                keyReference = _MSTDecodeUnsignedInt(data, pos, operation);
                key = keys.get((int) keyReference);
                _MSTJumpToNextToken(data, pos, tokenCount);
                object = _MSTDecodeObject(data, pos, operation, decodedObjects, classes, keys, tokenCount, isWeakRef, allowsUnknownUserClasses, nameSpace);
                ret.put(key, object);
                if (isWeakRef) {
                    if (decodingUserClass) {
                        if (manageReference) {
                            throw new MSTEException("_MSTDecodeDictionary - Weakly referenced object encountered while decoding a user class!");
                        }
                    } else {
                        throw new MSTEException("_MSTDecodeDictionary - Weakly referenced object encountered while decoding a non user class!");
                    }
                }
            }
        }
        return ret;
    }

    public Object decodeObject(byte[] data, Boolean verifyCRC, Boolean allowsUnknownUserClasses, HashMap<String, String> nameSpace) throws MSTEException {
        int len = data.length;
        String strCRC = "";
        if (len > 26) { //minimum header size : ["MSTE0101",3,"CRC00000000" ...]
            int[] pos = new int[1];
            pos[0] = 0;
            int state = MSTE_DECODING_ARRAY_START;
            Object object = null;
            ArrayList<String> decodedClasses = new ArrayList<String>();
            ArrayList<String> decodedKeys = new ArrayList<String>();
            ArrayList<Object> decodedObjects = new ArrayList<Object>();
            int[] myTokenCount = new int[1];
            myTokenCount[0] = 0;
            long tokenNumber = 0;
            int classesNumber = 0;
            int keysNumber = 0;
            while (pos[0] < len) {
                switch (state) {
                    case MSTE_DECODING_ARRAY_START: {
                        if ((char) data[pos[0]] == ' ') {
                            pos[0]++;
                            break;
                        }
                        if ((char) data[pos[0]] == '[') {
                            pos[0]++;
                            state = MSTE_DECODING_VERSION_START;
                            break;
                        }
                        throw new MSTEException("decodeObject:Bad header format (array start) !");
                    }
                    case MSTE_DECODING_VERSION_START: {
                        if ((char) data[pos[0]] == ' ') {
                            pos[0]++;
                            break;
                        }
                        if ((char) data[pos[0]] == '"') {
                            pos[0]++;
                            state = MSTE_DECODING_VERSION_HEADER;
                            break;
                        }
                        throw new MSTEException("decodeObject:Bad header format (start) !");
                    }
                    case MSTE_DECODING_VERSION_HEADER: {
                        if (((pos[0] + 4) > len) || ((char) data[pos[0]] != 'M') || ((char) data[pos[0] + 1] != 'S') || ((char) data[pos[0] + 2] != 'T') || ((char) data[pos[0] + 3] != 'E')) {
                            throw new MSTEException("decodeObject:Bad header format (MSTE marker) !");
                        }
                        pos[0] = pos[0] + 4;
                        state = MSTE_DECODING_VERSION_VALUE;
                        break;
                    }
                    case MSTE_DECODING_VERSION_VALUE: {
                        if (((pos[0] + 4) > len) || ((char) data[pos[0]] != MSTE_CURRENT_VERSION.charAt(0)) || ((char) data[pos[0] + 1] != MSTE_CURRENT_VERSION.charAt(1)) || ((char) data[pos[0] + 2] != MSTE_CURRENT_VERSION.charAt(2)) || ((char) data[pos[0] + 3] != MSTE_CURRENT_VERSION.charAt(3))) {
                            throw new MSTEException("decodeObject: Bad header version !");
                        }
                        pos[0] = pos[0] + 4;
                        state = MSTE_DECODING_VERSION_END;
                        break;
                    }
                    case MSTE_DECODING_VERSION_END: {
                        if ((char) data[pos[0]] == '"') {
                            pos[0]++;
                            state = MSTE_DECODING_VERSION_NEXT_TOKEN;
                        } else {
                            throw new MSTEException("decodeObject: Bad header format (version end) !");
                        }
                        break;
                    }
                    case MSTE_DECODING_VERSION_NEXT_TOKEN:
                    case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN:
                    case MSTE_DECODING_CRC_NEXT_TOKEN:
                    case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN:
                    case MSTE_DECODING_CLASS_NEXT_TOKEN:
                    case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN:
                    case MSTE_DECODING_KEY_NEXT_TOKEN: {
                        _MSTJumpToNextToken(data, pos, myTokenCount);
                        switch (state) {
                            case MSTE_DECODING_VERSION_NEXT_TOKEN:
                                state = MSTE_DECODING_TOKEN_NUMBER_VALUE;
                                break;
                            case MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN:
                                state = MSTE_DECODING_CRC_START;
                                break;
                            case MSTE_DECODING_CRC_NEXT_TOKEN:
                                state = MSTE_DECODING_CLASSES_NUMBER_VALUE;
                                break;
                            case MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN:
                                if (classesNumber > 0) {
                                    state = MSTE_DECODING_CLASS_NAME;
                                } else {
                                    state = MSTE_DECODING_KEYS_NUMBER_VALUE;
                                }
                                break;
                            case MSTE_DECODING_CLASS_NEXT_TOKEN:
                                if (classesNumber > decodedClasses.size()) {
                                    state = MSTE_DECODING_CLASS_NAME;
                                } else {
                                    state = MSTE_DECODING_KEYS_NUMBER_VALUE;
                                }
                                break;
                            case MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN:
                                if (keysNumber > 0) {
                                    state = MSTE_DECODING_KEY_NAME;
                                } else {
                                    state = MSTE_DECODING_ROOT_OBJECT;
                                }
                                break;
                            case MSTE_DECODING_KEY_NEXT_TOKEN:
                                if (keysNumber > decodedKeys.size()) {
                                    state = MSTE_DECODING_KEY_NAME;
                                } else {
                                    state = MSTE_DECODING_ROOT_OBJECT;
                                }
                                break;
                            default:
                                throw new MSTEException("decodeObject: state unchanged!!!!");
                        }
                        break;
                    }
                    case MSTE_DECODING_TOKEN_NUMBER_VALUE: {
                        tokenNumber = _MSTDecodeUnsignedLong(data, pos, "token number");
                        state = MSTE_DECODING_TOKEN_NUMBER_NEXT_TOKEN;
                        break;
                    }
                    case MSTE_DECODING_CRC_START: {
                        if ((char) data[pos[0]] == '"') {
                            pos[0]++;
                            state = MSTE_DECODING_CRC_HEADER;
                            break;
                        } else {
                            throw new MSTEException("decodeObject: Bad header format (CRC start)");
                        }
                    }
                    case MSTE_DECODING_CRC_HEADER: {
                        if (((pos[0] + 3) > len) || ((char) data[pos[0]] != 'C') || ((char) data[pos[0] + 1] != 'R') || ((char) data[pos[0] + 2] != 'C')) {
                            throw new MSTEException("decodeObject:Bad header format (CRC marker) !");
                        }
                        pos[0] = pos[0] + 3;
                        state = MSTE_DECODING_CRC_VALUE;
                        break;
                    }
                    case MSTE_DECODING_CRC_VALUE: {
                        if ((pos[0] + 8) > (len - 1)) {
                            throw new MSTEException("decodeObject:Bad header format (CRC value) !");
                        }
                        StringBuffer sb = new StringBuffer();
                        for (int j = pos[0]; j < (pos[0] + 8); j++) {
                            sb.append((char) data[j]);
                        }
                        strCRC = sb.toString();
                        pos[0] = pos[0] + 8;
                        state = MSTE_DECODING_CRC_END;
                        break;
                    }
                    case MSTE_DECODING_CRC_END: {
                        if ((char) data[pos[0]] == '"') {
                            pos[0]++;
                            state = MSTE_DECODING_CRC_NEXT_TOKEN;
                        } else {
                            throw new MSTEException("decodeObject: Bad header format (CRC end)");
                        }
                        break;
                    }
                    case MSTE_DECODING_CLASSES_NUMBER_VALUE: {
                        classesNumber = _MSTDecodeInt(data, pos, "classes number");
                        if (classesNumber > 0) {
                            decodedClasses = new ArrayList<String>(classesNumber);
                        }
                        state = MSTE_DECODING_CLASSES_NUMBER_NEXT_TOKEN;
                        break;
                    }
                    case MSTE_DECODING_CLASS_NAME: {
                        String className = _MSTDecodeString(data, pos, "class name");
                        decodedClasses.add(className);
                        state = MSTE_DECODING_CLASS_NEXT_TOKEN;
                        break;
                    }
                    case MSTE_DECODING_KEYS_NUMBER_VALUE: {
                        Integer end = 0;
                        keysNumber = _MSTDecodeInt(data, pos, "keys number");
                        if (keysNumber > 0) {
                            decodedKeys = new ArrayList<String>(keysNumber);
                        }
                        state = MSTE_DECODING_KEYS_NUMBER_NEXT_TOKEN;
                        break;
                    }
                    case MSTE_DECODING_KEY_NAME: {
                        String key = _MSTDecodeString(data, pos, "key name");
                        decodedKeys.add(key);
                        state = MSTE_DECODING_KEY_NEXT_TOKEN;
                        break;
                    }
                    case MSTE_DECODING_ROOT_OBJECT: {
                        decodedObjects = new ArrayList<Object>();
                        object = _MSTDecodeObject(data, pos, "root object", decodedObjects, decodedClasses, decodedKeys, myTokenCount, null, allowsUnknownUserClasses, nameSpace);
                        state = MSTE_DECODING_ARRAY_END;
                        break;
                    }
                    case MSTE_DECODING_ARRAY_END: {
                        if ((char) data[pos[0]] == ' ') {
                            pos[0]++;
                            break;
                        }
                        if ((char) data[pos[0]] == ']') {
                            state = MSTE_DECODING_GLOBAL_END;
                            break;
                        }
                        throw new MSTEException("decodeObject - Bad format (array end)");
                    }
                    case MSTE_DECODING_GLOBAL_END: {
                        if ((char) data[pos[0]] == ' ') {
                            pos[0]++;
                            break;
                        }
                        if (pos[0] == len - 1) {
                            if (verifyCRC) {
                                StringBuffer global = new StringBuffer();
                                String s = new String(data);
                                global.append(s);
                                int posCRC = global.indexOf("CRC");
                                global.replace(posCRC + 3, posCRC + 11, "00000000");
                                String calcCRC = MSCRC32.getCRC(global.toString());
                                if (calcCRC.compareToIgnoreCase(strCRC) != 0) {
                                    throw new MSTEException("decodeObject  - CRC Verification failed");
                                }
                            }
                            myTokenCount[0]++;
                            if (tokenNumber != myTokenCount[0]) {
                                throw new MSTEException("decodeObject - Wrong token number : " + myTokenCount[0] + " (expected : " + tokenNumber + ")");
                            }
                            pos[0]++;
                            break;
                        } else {
                            throw new MSTEException("decodeObject - Bad format (character after array end)");
                        }
                    }
                    default: {
                        throw new MSTEException("decodeObject - unknown state");
                    }
                }
            }
            return object;
        } else {
            throw new MSTEException("decodeObject:no minimum header size !");
        }

    }

}
