package com.sticksports.nativeExtensions.utils;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/**
 * A set of tools to ease working with FRE objects.
 */
public class FREUtils {
	
	/**
	 * Safely tries to get a string argument at the given index. If something goes wrong, null is returned.
	 */
	public static String getString(FREObject[] args, int index) {
		if(args == null || args != null && args.length <= index)
			return null;
		
		String s = null;
		try {
			s = args[index].getAsString();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return s;
	}
	
	/**
	 * Safely tries to get an integer argument at the given index. If something goes wrong, null is returned.
	 */
	public static Integer getInteger(FREObject[] args, int index) {
		if(args == null || args != null && args.length <= index)
			return null;
		
		Integer i = null;
		try {
			i = args[index].getAsInt();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return i;
	}
	
	/**
	 * Safely tries to get a boolean argument at the given index. If something goes wrong, null is returned.
	 */
	public static Boolean getBoolean(FREObject[] args, int index) {
		if(args == null || args != null && args.length <= index)
			return null;
		
		Boolean b = null;
		try {
			b = args[index].getAsBool();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}
	
	/**
	 * Safely tries to get a double argument at the given index. If something goes wrong, null is returned.
	 */
	public static Double getDouble(FREObject[] args, int index) {
		if(args == null || args != null && args.length <= index)
			return null;
		
		Double d = null;
		try {
			d = args[index].getAsDouble();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return d;
	}
	
	/**
	 * Safely tries to get a String[] argument at the given index. If something goes wrong, null is returned.
	 */
	public static String[] getStringArray(FREObject[] args, int index) {
		if(args == null || args != null && args.length <= index)
			return null;
		
		String[] s = null;
		FREArray array;
		try {
			array = (FREArray) args[index];
			s = new String[(int) array.getLength()];
			for(int i = 0 ; i < array.getLength() ; i++)
				s[i] = array.getObjectAt(i).getAsString();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return s;
	}
	
	/**
	 * Safely returns an FREObject with the given string value, or null if something goes wrong.
	 */
	public static FREObject newObject(String stringValue) {
		try {
			return FREObject.newObject(stringValue);
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Safely returns an FREObject with the given int value, or null if something goes wrong.
	 */
	public static FREObject newObject(int intValue) {
		try {
			return FREObject.newObject(intValue);
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Safely returns an FREObject with the given boolean value, or null if something goes wrong.
	 */
	public static FREObject newObject(boolean booleanValue) {
		try {
			return FREObject.newObject(booleanValue);
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Safely returns an FREObject with the given double value, or null if something goes wrong.
	 */
	public static FREObject newObject(double doubleValue) {
		try {
			return FREObject.newObject(doubleValue);
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Safely returns an FREObject with the given ActionScript class and constructor arguments, or null if something goes wrong.
	 */
	public static FREObject newObject(String className, FREObject[] constructorArgs) {
		try {
			return FREObject.newObject(className, constructorArgs);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
