package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.app.Activity;
import android.util.Log;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;

public class MoPubBannerShow implements FREFunction
{
	@Override
	public FREObject call( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			Activity activity = context.getActivity();
			
			ViewGroup frameLayout = (ViewGroup) activity.findViewById( android.R.id.content );
			frameLayout = (ViewGroup) frameLayout.getChildAt( 0 );
			FrameLayout.LayoutParams params = new FrameLayout.LayoutParams( context.getBanner().getPlannedWidth(), context.getBanner().getPlannedHeight() );
			params.gravity = Gravity.LEFT | Gravity.TOP;
			params.setMargins( context.getBanner().getPosX(), context.getBanner().getPosY(), 0, 0 );
			frameLayout.addView( context.getBanner(), params );
		}
		catch ( Exception exception )
		{
			Log.w( "MoPub", exception );
		}
		return null;
	}
}
