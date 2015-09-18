package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerSetAdUnitId implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			String adUnitId = args[0].getAsString();
			context.getBanner().setAdUnitId( adUnitId );
			MoPubExtension.log("Banner ad unit ID set to " + adUnitId);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
