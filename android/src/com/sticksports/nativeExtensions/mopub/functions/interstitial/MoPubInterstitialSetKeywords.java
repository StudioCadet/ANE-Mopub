package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubInterstitialSetKeywords extends UIThreadSafeFREFunction {

	public FREObject safeCall(FREContext ctx, FREObject[] args) {
		try
		{
			MoPubInterstitialContext context = (MoPubInterstitialContext) ctx;
			String keywords = args[0].getAsString();
			context.getInterstitial().setKeywords(keywords);
			MoPubExtension.log("Interstitial keywords set to " + keywords);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
