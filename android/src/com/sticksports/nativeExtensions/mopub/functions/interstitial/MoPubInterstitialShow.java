package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubInterstitialShow extends UIThreadSafeFREFunction {

	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubInterstitialContext context = (MoPubInterstitialContext) ctx;
			boolean success = context.showInterstitial();
			MoPubExtension.log(success ? "Interstitial displayed" : "Interstitial failed to display");
			return FREObject.newObject( success );
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
