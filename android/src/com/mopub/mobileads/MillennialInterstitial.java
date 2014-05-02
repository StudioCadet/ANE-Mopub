/*
 * Copyright (c) 2011, MoPub Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the name of 'MoPub Inc.' nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.mopub.mobileads;

import java.util.Map;

import android.content.Context;
import android.location.Location;

import com.millennialmedia.android.MMAd;
import com.millennialmedia.android.MMException;
import com.millennialmedia.android.MMInterstitial;
import com.millennialmedia.android.MMRequest;
import com.millennialmedia.android.MMSDK;
import com.millennialmedia.android.RequestListener;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

class MillennialInterstitial extends CustomEventInterstitial {
    private MMInterstitial mMillennialInterstitial;
    private CustomEventInterstitialListener mInterstitialListener;
    public static final String APID_KEY = "adUnitID";

    @Override
    protected void loadInterstitial(Context context, CustomEventInterstitialListener customEventInterstitialListener,
                                    Map<String, Object> localExtras, Map<String, String> serverExtras) {
        mInterstitialListener = customEventInterstitialListener;

        if (!extrasAreValid(serverExtras)) {
        	mInterstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
        	return;
        } 
        
        String apid = serverExtras.get(APID_KEY);

        MMSDK.initialize(context);

        Location location = (Location) localExtras.get("location");
        if (location != null) MMRequest.setUserLocation(location);

        if (mMillennialInterstitial != null && mMillennialInterstitial.isAdAvailable()) {
            MoPubExtension.log("Millennial interstitial ad already loaded.");
            mInterstitialListener.onInterstitialLoaded();
        }
        else {
        	mMillennialInterstitial = new MMInterstitial(context);
            mMillennialInterstitial.setApid(apid);
            MoPubExtension.log("Fetching a Millenial interstitial ad ...");
            mMillennialInterstitial.fetch(new MMRequest(), new MillennialRequestListener());
        }
    }

    @Override
    protected void showInterstitial() {
        if (mMillennialInterstitial.isAdAvailable()) {
        	MoPubExtension.log("Displaying a Millennial interstitial ad ...");
            boolean success = mMillennialInterstitial.display(true);
            MoPubExtension.log("Millennial interstitial " + (success ? "displayed successfully" : "failed to display"));
        } else {
            MoPubExtension.log("Tried to show a Millennial interstitial ad before it finished loading. Please try again.");
        }
    }

    @Override
    protected void onInvalidate() {
    	if(mMillennialInterstitial != null) 
    		mMillennialInterstitial.setListener(null);
    	MoPubExtension.log("Millennial interstitial invalidated");
    }

    private boolean extrasAreValid(Map<String, String> serverExtras) {
        return serverExtras.containsKey(APID_KEY);
    }

	class MillennialRequestListener implements RequestListener {

		@Override
		public void MMAdOverlayClosed(MMAd ad) {
			MoPubExtension.log("Millennial interstitial overlay closed");
			mInterstitialListener.onInterstitialDismissed();
		}

		@Override
		public void MMAdOverlayLaunched(MMAd ad) {
			MoPubExtension.log("Millennial interstitial overlay launched");
			mInterstitialListener.onInterstitialShown();
		}

		@Override
		public void MMAdRequestIsCaching(MMAd ad) {
			MoPubExtension.log("Millennial interstitial is caching");
		}

		@Override
		public void onSingleTap(MMAd ad) {
			MoPubExtension.log("Millennial interstitial on single tap");
			mInterstitialListener.onInterstitialClicked();
		}

		@Override
		public void requestCompleted(MMAd ad) {
			if(mMillennialInterstitial.isAdAvailable()) {
				MoPubExtension.log("Millennial interstitial loaded successfully");
				mInterstitialListener.onInterstitialLoaded();
			}
			else {
				MoPubExtension.log("Millennial interstitial failed to load");
				mInterstitialListener.onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
			}
		}

		@Override
		public void requestFailed(MMAd ad, MMException exception) {
			if(ad instanceof MMInterstitial) {
				MMInterstitial interstitial = (MMInterstitial) ad;
				if(interstitial.isAdAvailable()) {
					MoPubExtension.log("Millennial interstitial ad already loaded.");
					mInterstitialListener.onInterstitialLoaded();
					return;
				}
			}
			
			MoPubExtension.log("Millennial interstitial request failed : " + exception);
			exception.printStackTrace();
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
		}
    }
}
