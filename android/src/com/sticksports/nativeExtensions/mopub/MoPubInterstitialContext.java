package com.sticksports.nativeExtensions.mopub;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.mobileads.MoPubInterstitial.InterstitialAdListener;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialGetIsReady;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialInitialise;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialLoad;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialSetKeywords;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialSetTestMode;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialShow;

public class MoPubInterstitialContext extends FREContext implements InterstitialAdListener {
	
	//////////////////
	// INTERSTITIAL //
	//////////////////
	
	private MoPubInterstitial interstitial;
	
	/**
	 * Creates a new Interstitial ad with the given ad unit.
	 */
	public MoPubInterstitial createInterstitial(String adUnitId) {
		interstitial = new MoPubInterstitial(this.getActivity(), adUnitId);
		interstitial.setInterstitialAdListener(this);
		return interstitial;
	}

	/** The currently active interstitial, if any. */
	public MoPubInterstitial getInterstitial() {
		return interstitial;
	}
	
	/**
	 * Disposes the current interstitial, if any.
	 */
	public void disposeInterstitial() {
		if(interstitial == null) return;
		
		interstitial.setInterstitialAdListener(null);
		interstitial.destroy();
	}
	
	
	//////////////////
	// AD LIFECYCLE //
	//////////////////
	
	@Override
	public void onInterstitialLoaded(MoPubInterstitial interstitial) {
		MoPubExtension.log("Interstitial loaded");
		dispatchStatusEventAsync("", MoPubMessages.interstitialLoaded);
	}

	@Override
	public void onInterstitialFailed(MoPubInterstitial interstitial, MoPubErrorCode errorCode) {
		MoPubExtension.log("Interstitial failed : " + errorCode.toString());
		dispatchStatusEventAsync(errorCode.toString(), MoPubMessages.interstitialFailedToLoad);
	}

	@Override
	public void onInterstitialShown(MoPubInterstitial interstitial) {
		MoPubExtension.log("Interstitial shown");
		dispatchStatusEventAsync("", MoPubMessages.interstitialShown);
	}

	@Override
	public void onInterstitialClicked(MoPubInterstitial interstitial) {
		MoPubExtension.log("Interstitial clicked");
	}

	@Override
	public void onInterstitialDismissed(MoPubInterstitial interstitial) {
		MoPubExtension.log("Interstitial dismissed");
		dispatchStatusEventAsync("", MoPubMessages.interstitialClosed);
	}
	
	
	
	///////////////
	// EXTENSION //
	///////////////
	
	@Override
	public void dispose() {
		disposeInterstitial();
		MoPubExtension.log("Disposed interstitial");
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("initialiseInterstitial", new MoPubInterstitialInitialise());
		
		functionMap.put("setInterstitialTestMode", new MoPubInterstitialSetTestMode());
		functionMap.put("getInterstitialReady", new MoPubInterstitialGetIsReady());
		
		functionMap.put("setInterstitialKeywords", new MoPubInterstitialSetKeywords());
		
		functionMap.put("loadInterstitial", new MoPubInterstitialLoad());
		functionMap.put("showInterstitial", new MoPubInterstitialShow());
		return functionMap;
	}
}
