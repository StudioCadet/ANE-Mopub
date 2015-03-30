package com.mopub.mobileads;

import java.util.Map;

import android.app.Activity;
import android.content.Context;

import com.smaato.soma.internal.requests.settings.UserSettings;
import com.smaato.soma.interstitial.Interstitial;
import com.smaato.soma.interstitial.InterstitialAdListener;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubExtensionContext;


public class SmaatoInterstitial extends CustomEventInterstitial implements InterstitialAdListener {

	private Interstitial interstitial;
	private CustomEventInterstitialListener mInterstitialListener;

	@Override
	protected void loadInterstitial(Context context, CustomEventInterstitialListener interstitialListener, 
				Map<String, Object> localExtras, Map<String, String> serverExtras) {
		
			MoPubExtension.log("Creating a Smaato interstitial ...");
			this.mInterstitialListener = interstitialListener;
			
			Activity activity = null;
			if (context instanceof Activity) {
				activity = (Activity) context;
			} else {
				// You may also pass in an Activity Context in the localExtras map
				// and retrieve it here.
			}

			if (activity == null) {
				MoPubExtension.logE("No activity found for Smaato interstitial !");
				mInterstitialListener.onInterstitialFailed(MoPubErrorCode.UNSPECIFIED);
				return;
			}
			
			if(interstitial == null){
				interstitial = new Interstitial(activity);
				interstitial.setInterstitialAdListener(this);
			}
			int publisherId = Integer.parseInt((String) serverExtras.get("publisherId"));
			int adSpaceId = Integer.parseInt((String) serverExtras.get("adSpaceId"));
			interstitial.getAdSettings().setPublisherId(publisherId);
			interstitial.getAdSettings().setAdspaceId(adSpaceId);
			
			interstitial.setLocationUpdateEnabled(true);
			
			MoPubExtension.log("Setting the user settings ...");
			UserSettings userSettings = interstitial.getUserSettings();
			userSettings.setAge(MoPubExtensionContext.keywords.age);
			String gender = MoPubExtensionContext.keywords.gender;
			userSettings.setUserGender(gender != null && gender.equals("m") ? UserSettings.Gender.MALE : gender != null && gender.equals("f") ? UserSettings.Gender.FEMALE : UserSettings.Gender.UNSET);
			userSettings.setKeywordList(MoPubExtensionContext.keywords.interests);
			
			MoPubExtension.log("Done. Loading interstitial ...");
			interstitial.asyncLoadNewBanner();
	}

	@Override
	protected void onInvalidate() {
		if (interstitial != null) {
			MoPubExtension.log("Removing a Smaato interstitial ...");
			interstitial.setInterstitialAdListener(null);
            interstitial = null;
			MoPubExtension.log("Smaato interstitial removed.");
		}
	}

	@Override
	protected void showInterstitial() {
		if (interstitial != null) {
			MoPubExtension.log("Showing a Smaato interstitial ...");
			interstitial.show();
		}
	}

	@Override
	public void onFailedToLoadAd() {
		MoPubExtension.log("Smaato interstitial failed to load ...");
		mInterstitialListener.onInterstitialFailed(MoPubErrorCode.NO_FILL);
	}

	@Override
	public void onReadyToShow() {
		MoPubExtension.log("Smaato interstitial is ready to show ...");
		mInterstitialListener.onInterstitialLoaded();
	}

	@Override
	public void onWillClose() {
		MoPubExtension.log("Smaato interstitial will be closed.");
		mInterstitialListener.onInterstitialDismissed();
	}

	@Override
	public void onWillOpenLandingPage() {
		MoPubExtension.log("Smaato interstitial clicked");
		mInterstitialListener.onInterstitialClicked();
	}

	@Override
	public void onWillShow() {
		MoPubExtension.log("Smaato interstitial will show ...");
		mInterstitialListener.onInterstitialShown();
	}

}
