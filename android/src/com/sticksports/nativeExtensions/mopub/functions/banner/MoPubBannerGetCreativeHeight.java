package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;

public class MoPubBannerGetCreativeHeight implements FREFunction
{

	@Override
	public FREObject call( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			//int height = (int) Math.ceil( context.getBanner().getAdHeight() * ctx.getActivity().getResources().getDisplayMetrics().density );
			int height = context.getBanner().getPlannedHeight();
			return FREObject.newObject( height );
		}
		catch ( Exception exception )
		{
			Log.w( "MoPub", exception );
		}
		return null;
	}

}
