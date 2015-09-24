package com.mopub.mobileads;

import java.util.Map;

import com.smartadserver.android.library.exception.SASAdTimeoutException;
import com.smartadserver.android.library.exception.SASNoAdToDeliverException;
import com.smartadserver.android.library.exception.SASNoAdToDeliverFromCacheException;
import com.sticksports.nativeExtensions.utils.ExtraUtils;

/**
 * An utility class to ease working with SmartAdServer on MoPub.
 */
public class SmartAdUtils {
	
	// CONSTANTS :
	private static final String SAS_SITE_ID_KEY = "siteId";
	private static final String SAS_PAGE_ID_KEY = "pageId";
	private static final String SAS_FORMAT_ID_KEY = "formatId";
	private static final String SAS_TARGET_KEY = "target";
	private static final String SAS_RETRY_DELAY_KEY = "retryDelay";
	
	
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
	
	/**
	 * Returns the retry delay from the server extras, or null if none is found.
	 */
	public static Integer getRetryDelayFromServerExtras(Map<String, String> serverExtras) {
		return ExtraUtils.getInt(serverExtras, SAS_RETRY_DELAY_KEY);
	}

	public static MoPubErrorCode getMopubErrorCodeFromSmartAdException(Exception e) {
		if(e instanceof SASNoAdToDeliverException || e instanceof SASNoAdToDeliverFromCacheException)
			return MoPubErrorCode.NETWORK_NO_FILL;
		
		if(e instanceof SASAdTimeoutException)
			return MoPubErrorCode.NETWORK_TIMEOUT;
		
		return MoPubErrorCode.UNSPECIFIED;
	}
}
