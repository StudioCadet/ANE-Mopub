package com.sticksports.nativeExtensions.mopub;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.mopub.mobileads.MoPubConversionTracker;

public class MoPubExtension implements FREExtension
{
	/** Whether the conversion tracking has been called already. */
	private static boolean conversionTrackingCalled = false;
	
	@Override
	public FREContext createContext(String label)
	{
		FREContext context = null;
		
		if(label.equals("mopub"))
			context = new MoPubExtensionContext();
		
		else if(label.equals("interstitial"))
			context = new MoPubInterstitialContext();
		
		else if(label.equals("banner"))
			context = new MoPubBannerContext();
		
		// Conversion tracking call
		if(context != null && !conversionTrackingCalled) {
			new MoPubConversionTracker().reportAppOpen(context.getActivity());
			conversionTrackingCalled = true;
		}
		
		return context;
	}

	@Override
	public void dispose()
	{
	}

	@Override
	public void initialize()
	{
	}
}
