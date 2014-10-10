package com.mopub.mobileads;

import java.util.Map;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;

import com.smartadserver.android.library.SASInterstitialView;
import com.smartadserver.android.library.model.SASAdElement;
import com.smartadserver.android.library.ui.SASAdView;
import com.smartadserver.android.library.ui.SASAdView.StateChangeEvent;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class SASInterstitial extends CustomEventInterstitial implements SASAdView.AdResponseHandler, SASAdView.OnStateChangeListener, View.OnClickListener {

	// PROPERTIES :
	/** The listener used by MoPub to monitor interstitial ad's lifecycle. */
	private CustomEventInterstitialListener listener;
	/** The interstitial ad view. */
	private SASInterstitialView interstitial;
	/** The interstitial ad view parent. */
	private ViewGroup interstitialParent;
	
	/** The Site ID got from MoPub server. */
	private Integer siteId;
	/** The Page ID got from MoPub server. */
	private String pageId;
	/** The Format ID got from MoPub server. */
	private Integer formatId;
	/** The Target got from MoPub server. */
	private String target;
	
	
	//////////////////////////
	// CUSTOM EVENT METHODS //
	//////////////////////////
	
	@Override
	protected void loadInterstitial(Context context, CustomEventInterstitialListener listener, Map<String, Object> localExtras, Map<String, String> serverExtras) {
		
		this.listener = listener;
		
		MoPubExtension.log("Creating a SAS interstitial ...");
		this.interstitial = new SASInterstitialView(context);
		
		MoPubExtension.log("Getting interstitial parameters ...");
		siteId = SASUtils.getSiteIdFromServerExtras(serverExtras);
		pageId = SASUtils.getPageIdFromServerExtras(serverExtras);
		formatId = SASUtils.getFormatIdFromServerExtras(serverExtras);
		target = SASUtils.getTargetFromServerExtras(serverExtras);
		
		if(siteId == null || pageId == null || formatId == null || target == null) {
			MoPubExtension.logE("Invalid SmartAdServer parameters ! Configure network on MoPub to provide custom data : "
					+ "{\"siteId\":YOUR_SITE_ID, \"pageId\":YOUR_PAGE_ID, \"formatId\":YOUR_FORMAT_ID, \"target\":YOUR_TARGET}");
			listener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}
		
		MoPubExtension.log("Loading a master interstitial with parameters : [siteId:" + siteId + ", pageId:" + pageId + ", formatId:" + formatId + ", target:" + target + "] ...");
		interstitial.addStateChangeListener(this);
		interstitial.setOnClickListener(this);
		interstitial.loadAd(siteId, pageId, formatId, true, target, this);
		setInterstitialAlpha(0.0f);
	}

	@Override
	protected void onInvalidate() {
		MoPubExtension.log("Invalidating SAS interstitial ...");
		listener = null;
		if(interstitial != null) {
			MoPubExtension.log("Destroying SAS interstitial ...");
			interstitial.removeStateChangeListener(this);
			interstitial.onDestroy();
		}
		interstitial = null;
		MoPubExtension.log("SAS interstitial invalidated.");
	}

	@Override
	protected void showInterstitial() {
		MoPubExtension.log("Showing SAS interstitial ...");
		interstitial.executeOnUIThread(new Runnable() {
			@Override public void run() {
				if(interstitialParent != null) {
					interstitialParent.addView(interstitial);
					MoPubExtension.log("SAS interstitial unshown.");
				}
				setInterstitialAlpha(1.0f);
				listener.onInterstitialShown();
			}
		});
	}
	

	/////////////////////////////
	// SAS AD RESPONSE METHODS //
	/////////////////////////////

	@Override
	public void adLoadingCompleted(SASAdElement adElement) {
		MoPubExtension.log("SAS interstitial loaded.");
		interstitial.executeOnUIThread(new Runnable() {
			@Override public void run() {
				setInterstitialAlpha(0.0f); // -> to avoid the flickering effect
				ViewParent parent = interstitial.getParent();
				if(parent != null && parent instanceof ViewGroup) {
					interstitialParent = (ViewGroup) parent;
					interstitialParent.removeView(interstitial);
					MoPubExtension.log("SAS interstitial hidden until an explicit show request.");
				}
				listener.onInterstitialLoaded();
			}
		});
	}

	@Override
	public void adLoadingFailed(Exception e) {
		MoPubExtension.logW("SAS interstitial failed to load : " + e.toString());
		interstitial.executeOnUIThread(new Runnable() {
			@Override public void run() {
				listener.onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
			}
		});
	}


	/////////////////////////////////
	// SAS AD STATE CHANGE METHODS //
	/////////////////////////////////

	@Override
	public void onStateChanged(StateChangeEvent event) {
		if(event.getType() == StateChangeEvent.VIEW_HIDDEN) {
			MoPubExtension.log("SAS interstitial dismissed.");
			interstitial.executeOnUIThread(new Runnable() {
				@Override public void run() {
					listener.onInterstitialDismissed();
				}
			});
		}
	}

	
	////////////////////
	// CLICK LISTENER //
	////////////////////
	
	@Override
	public void onClick(View v) {
		MoPubExtension.log("SAS interstitial clicked.");
		listener.onInterstitialClicked();
	}
	
	
	///////////
	// ALPHA //
	///////////
	
	/**
	 * View.setAlpha() using only level 1 APIs (setAlpha() is level 11).
	 */
	public void setInterstitialAlpha(Float alphaValue) {
		
		// Since Android 3.0, setAlpha() is available, make use of it : 
		if(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB) {
			interstitial.setAlpha(alphaValue);
			if(alphaValue == 0.0f)
				interstitial.setVisibility(View.GONE);
			else
				interstitial.setVisibility(View.VISIBLE);
			interstitial.invalidate();
			return;
		}
		
		// Set alpha is not available, use the animation workaround :
		AlphaAnimation alpha = new AlphaAnimation(alphaValue, alphaValue);
		alpha.setDuration(0); // Make animation instant
		alpha.setFillAfter(true); // Tell it to persist after the animation ends
		if(alphaValue == 0.0f) {
			alpha.setAnimationListener(new AnimationListener() {
				@Override public void onAnimationStart(Animation animation) {}
				@Override public void onAnimationRepeat(Animation animation) {}
				@Override public void onAnimationEnd(Animation animation) {
					interstitial.executeOnUIThread(new Runnable() {
						@Override public void run() {
							interstitial.setVisibility(View.GONE);
							interstitial.invalidate();
						}
					});
				}
			});
		}
		else {
			alpha.setAnimationListener(new AnimationListener() {
				@Override public void onAnimationStart(Animation animation) {
					interstitial.executeOnUIThread(new Runnable() {
						@Override public void run() {
							interstitial.setVisibility(View.VISIBLE);
							interstitial.invalidate();
						}
					});
				}
				@Override public void onAnimationRepeat(Animation animation) {}
				@Override public void onAnimationEnd(Animation animation) {}
			});
		}
		interstitial.startAnimation(alpha);
	}
}
