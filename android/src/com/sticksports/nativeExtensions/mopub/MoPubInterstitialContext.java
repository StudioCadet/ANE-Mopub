package com.sticksports.nativeExtensions.mopub;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.inmobi.monetization.IMErrorCode;
import com.inmobi.monetization.IMInterstitial;
import com.inmobi.monetization.IMInterstitialListener;
import com.mopub.mobileads.InMobiUtils;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.mobileads.MoPubInterstitial.InterstitialAdListener;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialDispose;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialGetIsReady;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialInitialise;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialLoad;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialSetTestMode;
import com.sticksports.nativeExtensions.mopub.functions.interstitial.MoPubInterstitialShow;

public class MoPubInterstitialContext extends FREContext implements InterstitialAdListener, IMInterstitialListener {
	
	//////////////////
	// INTERSTITIAL //
	//////////////////
	
	/** Whether this interstitial ad is a Mopub or an InMobi ad. */
	public Boolean useInMobi;
	
	private MoPubInterstitial mopubInterstitial;
	private IMInterstitial inMobiInterstitial;
	
	/**
	 * Creates a new Interstitial ad with the given ad unit.
	 */
	public void createInterstitial(String adUnitId, Boolean useInMobi) {
		this.useInMobi = useInMobi;
		
		if(!useInMobi) {
			mopubInterstitial = new MoPubInterstitial(this.getActivity(), adUnitId);
			mopubInterstitial.setInterstitialAdListener(this);
		}
		else {
			inMobiInterstitial = new IMInterstitial(this.getActivity(), InMobiUtils.inMobiPropertyId);
			inMobiInterstitial.setIMInterstitialListener(this);
		}
	}
	
	/**
	 * Returns true when the current interstitial is ready for display.
	 */
	public boolean getIsReady() {
		return useInMobi ? 
				(inMobiInterstitial != null && IMInterstitial.State.READY.equals(this.inMobiInterstitial.getState())) :
				(mopubInterstitial != null && mopubInterstitial.isReady());
	}
	
	/**
	 * Sets the mopub interstitial keywords if the interstitial is a MopubInterstitial.
	 */
	public void setKeywords(String mopubKeywords) {
		if(mopubInterstitial != null)
			mopubInterstitial.setKeywords(mopubKeywords);
	}
	
	/**
	 * Starts loading the current interstitial ad.
	 */
	public void loadInterstitial() {
		if(useInMobi) 
			inMobiInterstitial.loadInterstitial();
		else
			mopubInterstitial.load();
	}
	
	/**
	 * Sets mopub test mode.
	 */
	public void setTestMode(Boolean testMode) {
		if(mopubInterstitial != null)
			mopubInterstitial.setTesting(testMode);
	}
	
	/**
	 * Tries to display the current interstitial ad. Returns true on successful displaying.
	 */
	public boolean showInterstitial() {
		if(useInMobi) {
			inMobiInterstitial.show();
			return true;
		}
		
		return mopubInterstitial.show();
	}

	/**
	 * Disposes the current mopubInterstitial, if any.
	 */
	public void disposeInterstitial() {
		if(!useInMobi) {
			if(mopubInterstitial == null)
				return;
			mopubInterstitial.setInterstitialAdListener(null);
			mopubInterstitial.destroy();
		}
		else {
			if(inMobiInterstitial != null) {
				MoPubExtension.log("Removing an InMobi interstitial ...");
				inMobiInterstitial.setIMInterstitialListener(null);
				inMobiInterstitial = null;
				MoPubExtension.log("InMobi interstitial removed.");
			}
		}
	}
	
	
	/////////////////////
	// MOPUB LIFECYCLE //
	/////////////////////
	
	@Override
	public void onInterstitialLoaded(MoPubInterstitial interstitial) {
		MoPubExtension.log("Mopub Interstitial loaded");
		dispatchStatusEventAsync("", MoPubMessages.interstitialLoaded);
	}

	@Override
	public void onInterstitialFailed(MoPubInterstitial interstitial, MoPubErrorCode errorCode) {
		MoPubExtension.log("Mopub Interstitial failed : " + errorCode.toString());
		dispatchStatusEventAsync(errorCode.toString(), MoPubMessages.interstitialFailedToLoad);
	}

	@Override
	public void onInterstitialShown(MoPubInterstitial interstitial) {
		MoPubExtension.log("Mopub Interstitial shown");
		dispatchStatusEventAsync("", MoPubMessages.interstitialShown);
	}

	@Override
	public void onInterstitialClicked(MoPubInterstitial interstitial) {
		MoPubExtension.log("Mopub Interstitial clicked");
		dispatchStatusEventAsync("", MoPubMessages.interstitialClicked);
	}

	@Override
	public void onInterstitialDismissed(MoPubInterstitial interstitial) {
		MoPubExtension.log("Mopub Interstitial dismissed");
		dispatchStatusEventAsync("", MoPubMessages.interstitialClosed);
	}
	
	
	//////////////////////
	// INMOBI LIFECYCLE //
	//////////////////////

	@Override
	public void onInterstitialLoaded(IMInterstitial inMobiInterstitial) {
		MoPubExtension.log("InMobi Interstitial loaded");
		dispatchStatusEventAsync("", MoPubMessages.interstitialLoaded);
	}

	@Override
	public void onInterstitialFailed(IMInterstitial inMobiInterstitial, IMErrorCode imErrorCode) {
		MoPubExtension.log("InMobi Interstitial failed : " + imErrorCode.toString());
		dispatchStatusEventAsync(imErrorCode.toString(), MoPubMessages.interstitialFailedToLoad);
	}
	
	@Override
	public void onShowInterstitialScreen(IMInterstitial inMobiInterstitial) {
		MoPubExtension.log("InMobi Interstitial shown");
		dispatchStatusEventAsync("", MoPubMessages.interstitialShown);
	}

	@Override
	public void onInterstitialInteraction(IMInterstitial inMobiInterstitial, Map<String, String> map) {
		MoPubExtension.log("InMobi Interstitial clicked");
		dispatchStatusEventAsync("", MoPubMessages.interstitialClicked);
	}

	@Override
	public void onDismissInterstitialScreen(IMInterstitial inMobiInterstitial) {
		MoPubExtension.log("InMobi Interstitial dismissed");
		dispatchStatusEventAsync("", MoPubMessages.interstitialClosed);
	}
	
	@Override
	public void onLeaveApplication(IMInterstitial inMobiInterstitial) {
		MoPubExtension.log("InMobi Interstitial will leave app");
	}
	
	
	///////////////
	// EXTENSION //
	///////////////
	
	@Override
	public void dispose() {
		disposeInterstitial();
		MoPubExtension.log("Disposed mopubInterstitial");
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("mopub_initialiseInterstitial", new MoPubInterstitialInitialise());
		
		functionMap.put("mopub_setInterstitialTestMode", new MoPubInterstitialSetTestMode());
		functionMap.put("mopub_getInterstitialReady", new MoPubInterstitialGetIsReady());
		
		functionMap.put("mopub_loadInterstitial", new MoPubInterstitialLoad());
		functionMap.put("mopub_showInterstitial", new MoPubInterstitialShow());
		
		functionMap.put("mopub_disposeInterstitial", new MoPubInterstitialDispose());
		
		return functionMap;
	}

}
