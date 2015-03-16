package com.mopub.mobileads;

import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class ChartboostDelegate extends com.chartboost.sdk.ChartboostDelegate {
	
	@Override
	public boolean shouldRequestInterstitial(String location) {
		return true;
	}

	@Override
	public void didCacheInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " loaded successfully.");
		ChartboostUtils.getListener(location).onInterstitialLoaded();
	}

	@Override
	public void didFailToLoadInterstitial(String location, CBImpressionError cbError) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " failed to load : " + cbError.toString());
		ChartboostUtils.getListener(location).onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
	}

	@Override
	public boolean shouldDisplayInterstitial(String location) {
		return true;
	}
	
	@Override
	public void didDisplayInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " shown.");
		ChartboostUtils.getListener(location).onInterstitialShown();
	}
	
	@Override
	public void didClickInterstitial(String location) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " clicked.");
		ChartboostUtils.getListener(location).onInterstitialClicked();
	}
	
	@Override
	public void didFailToRecordClick(String location, CBClickError clickError) {
		MoPubExtension.log("Chartboost interstitial ad for location " + location + " failed to receive click : " + clickError.toString());
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
}
