package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;

public class MoPubInterstitialDispose implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		
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
