package com.mopub.mobileads;

import java.util.Map;

/**
 * An utility class to ease working with SmartAdServer on MoPub.
 */
public class SASUtils {
	
	// CONSTANTS :
	private static final String SAS_SITE_ID_KEY = "siteId";
	private static final String SAS_PAGE_ID_KEY = "pageId";
	private static final String SAS_FORMAT_ID_KEY = "formatId";
	private static final String SAS_TARGET_KEY = "target";
	
	
	/**
	 * Returns the site ID from the server extras, or null if none is found.
	 */
	public static Integer getSiteIdFromServerExtras(Map<String, String> serverExtras) {
		return ExtraUtils.getInt(serverExtras, SAS_SITE_ID_KEY);
	}
	
	/**
	 * Returns the page ID from the server extras, or null if none is found.
	 */
	public static String getPageIdFromServerExtras(Map<String, String> serverExtras) {
		return ExtraUtils.getString(serverExtras, SAS_PAGE_ID_KEY);
	}
	
	/**
	 * Returns the format ID from the server extras, or null if none is found.
	 */
	public static Integer getFormatIdFromServerExtras(Map<String, String> serverExtras) {
		return ExtraUtils.getInt(serverExtras, SAS_FORMAT_ID_KEY);
	}
	
	/**
	 * Returns the target from the server extras, or null if none is found.
	 */
	public static String getTargetFromServerExtras(Map<String, String> serverExtras) {
		return ExtraUtils.getString(serverExtras, SAS_TARGET_KEY);
	}
}
