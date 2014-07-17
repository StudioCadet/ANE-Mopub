package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;
import com.sticksports.nativeExtensions.mopub.functions.UIThreadSafeFREFunction;

public class MoPubInterstitialDispose extends UIThreadSafeFREFunction {

	public FREObject safeCall(FREContext ctx, FREObject[] args) {
		
		try
		{
			MoPubInterstitialContext context = (MoPubInterstitialContext) ctx;
			context.disposeInterstitial();
			MoPubExtension.log("Interstitial disposed");
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}