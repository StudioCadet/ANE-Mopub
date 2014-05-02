package com.sticksports.nativeExtensions.mopub;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class MoPubExtension implements FREExtension
{
	
	@Override
	public FREContext createContext(String label)
	{
		FREContext context = null;
		
		Log.i("MoPubExtension", "Creating a context with : " + label);
		if(label.equals("mopub"))
			context = new MoPubExtensionContext();
		
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
	}
	
	/**
	 * Logs the given message at warning level.
	 */
	public static void logW(String message) {
		Log.w("MoPubExtension", message);
	}
}
