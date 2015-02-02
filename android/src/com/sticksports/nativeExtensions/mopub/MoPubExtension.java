package com.sticksports.nativeExtensions.mopub;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class MoPubExtension implements FREExtension
{
	
	/** A reference to the mopub extension context. */
	private static MoPubExtensionContext mpContext;
	
	/** A Date formatter used for logging. */
	private static SimpleDateFormat dateFormat;
	
	
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
		
		if(dateFormat == null)
			dateFormat = new SimpleDateFormat("HH:mm:ss.SSS");
		
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
			mpContext.dispatchStatusEventAsync(MoPubMessages.log, dateFormat.format(new Date()) + " INFO " + message);
	}
	
	/**
	 * Logs the given message at warning level.
	 */
	public static void logW(String message) {
		Log.w("MoPubExtension", message);
		if(mpContext != null)
			mpContext.dispatchStatusEventAsync(MoPubMessages.log, dateFormat.format(new Date()) + " WARN " + message);
	}
	
	/**
	 * Logs the given message at error level.
	 */
	public static void logE(String message) {
		Log.e("MoPubExtension", message);
		if(mpContext != null)
			mpContext.dispatchStatusEventAsync(MoPubMessages.log, dateFormat.format(new Date()) + " ERROR " + message);
	}
}
