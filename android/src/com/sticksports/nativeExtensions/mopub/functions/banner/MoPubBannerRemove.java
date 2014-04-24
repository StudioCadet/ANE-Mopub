package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.util.Log;
import android.view.ViewGroup;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;

public class MoPubBannerRemove implements FREFunction
{

	@Override
	public FREObject call( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			ViewGroup parent = (ViewGroup) context.getBanner().getParent();
			if( parent != null )
			{
				parent.removeView( context.getBanner() );
			}
		}
		catch ( Exception exception )
		{
			Log.w( "MoPub", exception );
		}
		return null;
	}

}
