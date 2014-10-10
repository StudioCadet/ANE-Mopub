package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubBannerGetCreativeWidth extends UIThreadSafeFREFunction {
	
	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			// int width = (int) Math.ceil( context.getBanner().getAdWidth() * ctx.getActivity().getResources().getDisplayMetrics().density );
			int width = context.getBanner().getPlannedWidth();
			return FREObject.newObject( width );
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
