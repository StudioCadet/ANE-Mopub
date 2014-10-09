package com.sticksports.nativeExtensions.mopub;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class MoPubExtension implements FREExtension
{
	
	/** A reference to the mopub extension context. */
	private static MoPubExtensionContext mpContext;
	
	@Override
	public FREContext createContext(String label)
	{
		FREContext context = null;
		
		Log.i("MoPubExtension", "Creating a context with : " + label);
		if(label.equals("mopub")) 
			context = mpContext = new MoPubExtensionContext();
		
		else if(label.equals("interstitial"))
			context = new MoPubInterstitialContext();
		
		else if(label.equals("banner"))
			context = new MoPubBannerContext();
		
		return context;
	}

	@Override
	public void dispose() {
	}

	@Override
	public void initialize() {
	}
	
	/**
	 * Logs the given message at info level.
	 */
	public static void log(String message) {
		Log.i("MoPubExtension", message);
		if(mpContext != null)
			mpContext.dispatchStatusEventAsync(MoPubMessages.log, "INFO " + message);
	}
	
	/**
	 * Logs the given message at warning level.
	 */
	public static void logW(String message) {
		Log.w("MoPubExtension", message);
		if(mpContext != null)
			mpContext.dispatchStatusEventAsync(MoPubMessages.log, "WARN " + message);
	}
	
	/**
	 * Logs the given message at error level.
	 */
	public static void logE(String message) {
		Log.e("MoPubExtension", message);
		if(mpContext != null)
			mpContext.dispatchStatusEventAsync(MoPubMessages.log, "ERROR " + message);
	}
}
