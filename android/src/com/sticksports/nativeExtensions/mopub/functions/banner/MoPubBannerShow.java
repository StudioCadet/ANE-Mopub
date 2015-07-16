package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.app.Activity;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBanner;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubBannerShow extends UIThreadSafeFREFunction {

	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{
		try
		{
			final MoPubBannerContext context = (MoPubBannerContext) ctx;
			final Activity activity = context.getActivity();
			final MoPubBanner banner = context.getBanner();
			
			activity.runOnUiThread(new Runnable() {
				@Override public void run() {
					FrameLayout.LayoutParams params = new FrameLayout.LayoutParams( banner.getPlannedWidth(), banner.getPlannedHeight() );
					params.gravity = Gravity.LEFT | Gravity.TOP;
					params.setMargins( banner.getPosX(), banner.getPosY(), 0, 0 );
					
					ViewGroup parent = (ViewGroup) banner.getParent();
					if(parent != null)
						parent.removeView(banner);
					
					ViewGroup frameLayout = (ViewGroup) activity.findViewById( android.R.id.content );
					frameLayout = (ViewGroup) frameLayout.getChildAt( 0 );
					frameLayout.addView( banner, params );
					
					MoPubExtension.log("Banner displayed");
				}
			});
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}
}
