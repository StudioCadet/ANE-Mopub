package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.view.ViewGroup;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubBannerRemove extends UIThreadSafeFREFunction {

	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			ViewGroup parent = (ViewGroup) context.getBanner().getParent();
			if( parent != null )
			{
				parent.removeView( context.getBanner() );
			}
			MoPubExtension.log("Banner removed");
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
