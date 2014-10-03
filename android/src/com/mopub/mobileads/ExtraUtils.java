package com.mopub.mobileads;

import java.util.Map;

public class ExtraUtils {
	
	/**
	 * Returns the given entry as an object, or null if something goes wrong retrieving the entry.
	 */
	private static Object get(Map<String, ?> extras, String key) {
		if(extras == null)
			return null;
		if(!extras.containsKey(key))
			return null;
		
		return extras.get(key);
	}

	/**
	 * Returns the given entry as a Long. If something goes wrong, null is returned.
	 */
	public static Long getLong(Map<String, ?> extras, String key) {
		try {
			return Long.parseLong((String) get(extras, key));
		}
		catch(Exception e) {}
		return null;
	}
	
	/**
	 * Returns the given entry as a String. If something goes wrong, null is returned.
	 */
	public static String getString(Map<String, ?> extras, String key) {
		Object value = get(extras, key);
		if(value == null)
			return null;
		return (String) value;
	}

	
	/**
	 * Returns the given entry as a String. If something goes wrong, null is returned.
	 */
	public static Integer getInt(Map<String, ?> extras, String key) {
		try {
			return Integer.parseInt((String) get(extras, key));
		}
		catch(Exception e) {}
		return null;
	}
}
