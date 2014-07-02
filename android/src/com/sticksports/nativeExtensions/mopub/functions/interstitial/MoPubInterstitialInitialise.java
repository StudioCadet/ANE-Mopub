package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;
import com.sticksports.nativeExtensions.mopub.functions.UIThreadSafeFREFunction;

public class MoPubInterstitialInitialise extends UIThreadSafeFREFunction {

	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{

		try
		{
			MoPubInterstitialContext context = (MoPubInterstitialContext) ctx;
			String adUnitId = args[0].getAsString();
			context.createInterstitial( adUnitId );
			MoPubExtension.log("Interstitial created for ad unit " + adUnitId);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
