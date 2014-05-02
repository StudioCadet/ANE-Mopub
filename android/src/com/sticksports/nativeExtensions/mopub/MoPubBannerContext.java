package com.sticksports.nativeExtensions.mopub;

import java.util.HashMap;
import java.util.Map;

import android.view.ViewGroup;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;
import com.mopub.mobileads.MoPubView.BannerAdListener;
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
import com.sticksports.nativeExtensions.mopub.functions.banner.MoPubBannerSetKeywords;
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
		ViewGroup parent = (ViewGroup) banner.getParent();
		if(parent != null)
			parent.removeView( banner );
		banner.destroy();
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

		functionMap.put("initialiseBanner", new MoPubBannerInitialise());

		functionMap.put("setTestMode", new MoPubBannerSetTestMode());
		functionMap.put("setAdUnitId", new MoPubBannerSetAdUnitId());
		functionMap.put("setAutorefresh", new MoPubBannerSetAutorefresh());
		functionMap.put("lockNativeAdsToOrientation", new MoPubBannerDoNothing());

		functionMap.put("getPositionX", new MoPubBannerGetPositionX());
		functionMap.put("setPositionX", new MoPubBannerSetPositionX());
		functionMap.put("getPositionY", new MoPubBannerGetPositionY());
		functionMap.put("setPositionY", new MoPubBannerSetPositionY());
		functionMap.put("getWidth", new MoPubBannerGetWidth());
		functionMap.put("setWidth", new MoPubBannerSetWidth());
		functionMap.put("getHeight", new MoPubBannerGetHeight());
		functionMap.put("setHeight", new MoPubBannerSetHeight());

		functionMap.put("setSize", new MoPubBannerSetSize());
		functionMap.put("getCreativeWidth", new MoPubBannerGetCreativeWidth());
		functionMap.put("getCreativeHeight", new MoPubBannerGetCreativeHeight());

		functionMap.put("setBannerKeywords", new MoPubBannerSetKeywords());
		
		functionMap.put("loadBanner", new MoPubBannerLoad());
		functionMap.put("showBanner", new MoPubBannerShow());
		functionMap.put("removeBanner", new MoPubBannerRemove());

		return functionMap;
	}
}
