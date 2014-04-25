package com.sticksports.nativeExtensions.mopub.functions.interstitial;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubInterstitialContext;

public class MoPubInterstitialInitialise implements FREFunction
{
	@Override
	public FREObject call( FREContext ctx, FREObject[] args )
	{

		try
		{
			MoPubInterstitialContext context = (MoPubInterstitialContext) ctx;
			String adUnitId = args[0].getAsString();
			context.createInterstitial( adUnitId );
		}
		catch ( Exception exception )
		{
			Log.w( "MoPub", exception );
		}
		return null;
	}

}
