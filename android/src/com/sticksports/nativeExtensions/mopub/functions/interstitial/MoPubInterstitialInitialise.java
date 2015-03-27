package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.mopub.mobileads.InMobiUtils;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubInterstitialInitialise extends UIThreadSafeFREFunction {

	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{

		try
		{
			MoPubInterstitialContext context = (MoPubInterstitialContext) ctx;
			String adUnitId = args[0].getAsString();
			Boolean useInMobi = InMobiUtils.isInMobiAdUnit(context.getActivity(), adUnitId);
			context.createInterstitial(adUnitId, useInMobi);
			MoPubExtension.log("Interstitial created for ad unit " + adUnitId + " (using InMobi without Mopub ? " + useInMobi + ")");
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
