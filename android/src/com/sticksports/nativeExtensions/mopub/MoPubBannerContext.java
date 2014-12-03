package com.sticksports.nativeExtensions.mopub;

import java.util.HashMap;
import java.util.Map;

import android.view.ViewGroup;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;
import com.mopub.mobileads.MoPubView.BannerAdListener;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerDispose;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerDoNothing;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerGetCreativeHeight;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerGetCreativeWidth;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerGetHeight;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerGetPositionX;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerGetPositionY;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerGetWidth;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerInitialise;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerLoad;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerRemove;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetAdUnitId;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetAutorefresh;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetHeight;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetPositionX;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetPositionY;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetSize;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetTestMode;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetWidth;
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerShow;

public class MoPubBannerContext extends FREContext implements BannerAdListener {

	////////////
	// BANNER //
	////////////

	private MoPubBanner banner;

	/**
	 * Returns the current banner. If none exists, one is created.
	 */
	public MoPubBanner getBanner() {
		if(banner == null) {
			banner = new MoPubBanner(this.getActivity());
			banner.setBannerAdListener(this);
		}
		return banner;
	}

	/**
	 * Disposes the current banner, if any.
	 */
	public void disposeBanner() {
		if(banner == null) return;

		banner.setBannerAdListener(null);
		this.getActivity().runOnUiThread(new Runnable() {
			@Override public void run() {
				ViewGroup parent = (ViewGroup) banner.getParent();
				if(parent != null)
					parent.removeView( banner );
				banner.destroy();
			}
		});
	}
	
	
	//////////////////
	// AD LIFECYCLE //
	//////////////////
	
	@Override
	public void onBannerLoaded(MoPubView banner) {
		dispatchStatusEventAsync( "", MoPubMessages.bannerLoaded );
	}

	@Override
	public void onBannerFailed(MoPubView banner, MoPubErrorCode errorCode) {
		dispatchStatusEventAsync( "", MoPubMessages.bannerFailedToLoad );
	}

	@Override
	public void onBannerClicked(MoPubView banner) {
		dispatchStatusEventAsync( "", MoPubMessages.bannerAdClicked );
	}

	@Override
	public void onBannerExpanded(MoPubView banner) {
	}

	@Override
	public void onBannerCollapsed(MoPubView banner) {
	}
	
	
	///////////////
	// EXTENSION //
	///////////////

	@Override
	public void dispose() {
		disposeBanner();
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

		functionMap.put("mopub_initialiseBanner", new MoPubBannerInitialise());

		functionMap.put("mopub_setTestMode", new MoPubBannerSetTestMode());
		functionMap.put("mopub_setAdUnitId", new MoPubBannerSetAdUnitId());
		functionMap.put("mopub_setAutorefresh", new MoPubBannerSetAutorefresh());
		functionMap.put("mopub_lockNativeAdsToOrientation", new MoPubBannerDoNothing());

		functionMap.put("mopub_getPositionX", new MoPubBannerGetPositionX());
		functionMap.put("mopub_setPositionX", new MoPubBannerSetPositionX());
		functionMap.put("mopub_getPositionY", new MoPubBannerGetPositionY());
		functionMap.put("mopub_setPositionY", new MoPubBannerSetPositionY());
		functionMap.put("mopub_getWidth", new MoPubBannerGetWidth());
		functionMap.put("mopub_setWidth", new MoPubBannerSetWidth());
		functionMap.put("mopub_getHeight", new MoPubBannerGetHeight());
		functionMap.put("mopub_setHeight", new MoPubBannerSetHeight());

		functionMap.put("mopub_setSize", new MoPubBannerSetSize());
		functionMap.put("mopub_getCreativeWidth", new MoPubBannerGetCreativeWidth());
		functionMap.put("mopub_getCreativeHeight", new MoPubBannerGetCreativeHeight());
		
		functionMap.put("mopub_loadBanner", new MoPubBannerLoad());
		functionMap.put("mopub_showBanner", new MoPubBannerShow());
		functionMap.put("mopub_removeBanner", new MoPubBannerRemove());
		
		functionMap.put("mopub_disposeBanner", new MoPubBannerDispose());

		return functionMap;
	}
}
