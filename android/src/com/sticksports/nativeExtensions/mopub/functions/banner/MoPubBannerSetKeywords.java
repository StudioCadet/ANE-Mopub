package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerSetKeywords implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			String keywords = args[0].getAsString();
			context.getBanner().setKeywords(keywords);
			MoPubExtension.log("Banner ad keywords set to " + keywords);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
