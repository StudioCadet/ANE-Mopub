package com.mopub.mobileads;

import com.chartboost.sdk.Chartboost.CBAgeGateConfirmation;
import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class ChartboostDelegate implements com.chartboost.sdk.ChartboostDelegate {


	//////////////////////
	// INTERSTITIAL ADS //
	//////////////////////

	@Override
	public boolean shouldDisplayInterstitial(String location) {
		return true;
	}

	@Override
	public boolean shouldRequestInterstitial(String location) {
		return true;
	}

	@Override
	public boolean shouldRequestInterstitialsInFirstSession() {
		return true;
	}

	@Override
	public void didCacheInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " loaded successfully.");
		ChartboostUtils.getListener(location).onInterstitialLoaded();
	}

	@Override
	public void didDismissInterstitial(String location) {
		// Note that this method is fired before didCloseInterstitial and didClickInterstitial.
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " dismissed.");
		ChartboostUtils.getListener(location).onInterstitialDismissed();
	}

	@Override
	public void didCloseInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " closed.");
	}

	@Override
	public void didClickInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " clicked.");
		ChartboostUtils.getListener(location).onInterstitialClicked();
	}

	@Override
	public void didShowInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " shown.");
		ChartboostUtils.getListener(location).onInterstitialShown();
	}

	@Override
	public void didFailToLoadInterstitial(String location, CBImpressionError cbError) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " failed to load : " + cbError.toString());
		ChartboostUtils.getListener(location).onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
	}

	@Override
	public void didFailToRecordClick(String location, CBClickError clickError) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " failed to receive click : " + clickError.toString());
	}

	@Override
	public boolean shouldPauseClickForConfirmation(CBAgeGateConfirmation arg0) {
		return false;
	}
	
	
	///////////////
	// MORE APPS //
	///////////////
	
	@Override
	public boolean shouldDisplayLoadingViewForMoreApps() {
		return false;
	}

	@Override
	public boolean shouldRequestMoreApps() {
		return false;
	}

	@Override
	public boolean shouldDisplayMoreApps() {
		return false;
	}

	@Override
	public void didCacheMoreApps() {
	}

	@Override
	public void didDismissMoreApps() {
	}

	@Override
	public void didCloseMoreApps() {
	}

	@Override
	public void didClickMoreApps() {
	}

	@Override
	public void didShowMoreApps() {
	}

	@Override
	public void didFailToLoadMoreApps(CBImpressionError error) {
	}
}
