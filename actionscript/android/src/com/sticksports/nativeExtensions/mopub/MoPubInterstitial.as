package com.sticksports.nativeExtensions.mopub
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class MoPubInterstitial extends EventDispatcher
	{
// native method names
		private static const initialiseInterstitial : String = "mopub_initialiseInterstitial";
		
		private static const setTestMode : String = "mopub_setInterstitialTestMode";
		private static const getIsReady : String = "mopub_getInterstitialReady";
		
		private static const loadInterstitial : String = "mopub_loadInterstitial";
		private static const showInterstitial : String = "mopub_showInterstitial";
		
		private static const disposeInterstitial : String = "mopub_disposeInterstitial";

// class variables

		private var extensionContext : ExtensionContext = null;
		private var _adUnitId : String;
		private var _testing : Boolean = false;
		private var _isDisplayed : Boolean = false;

// properties
		public function get adUnitId() : String
		{
			return _adUnitId;
		}

		public function get isReady() : Boolean
		{
			return extensionContext.call( getIsReady ) as Boolean;
		}

		public function get testing() : Boolean
		{
			return _testing;
		}

		public function set testing( value : Boolean ) : void
		{
			_testing = value;
			extensionContext.call( setTestMode, value );
		}

// methods

		public function MoPubInterstitial( adUnitId : String )
		{
			extensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.MoPub", "interstitial" );
			extensionContext.addEventListener( StatusEvent.STATUS, handleStatusEvent );
			_adUnitId = adUnitId;
			extensionContext.call( initialiseInterstitial, adUnitId );
		}
		
		private function handleStatusEvent( event : StatusEvent ) : void
		{
			switch( event.level )
			{
				case InternalMessages.interstitialLoaded :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_LOADED ) );
					break;
				case InternalMessages.interstitialFailedToLoad :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_FAILED_TO_LOAD ) );
					break;
				case InternalMessages.interstitialShown :
					dispatchEvent( new MoPubEvent( MoPubEvent.INTERSTITIAL_SHOWN ) );
					break;
				case InternalMessages.interstitialClosed :
					dispatchClose( null );
					break;
				case InternalMessages.interstitialClicked :
					dispatchEvent( new MoPubEvent( MoPubEvent.INTERSTITIAL_CLICKED ) );
					break;
			}
		}
		
		private function dispatchClose( event : Event ) : void
		{
			NativeApplication.nativeApplication.removeEventListener( Event.ACTIVATE, dispatchClose );
			if(_isDisplayed)
				dispatchEvent( new MoPubEvent( MoPubEvent.AD_CLOSED ) );
			_isDisplayed = false;
		}

		public function load() : void
		{
			extensionContext.call( loadInterstitial );
		}

		public function show() : Boolean
		{
			var success : Boolean = extensionContext.call( showInterstitial ) as Boolean;
			if( success )
			{
				_isDisplayed = true;
				NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE, dispatchClose );
			}
			return success;
		}
		
		public function dispose() : void
		{
			extensionContext.call( disposeInterstitial );
			extensionContext.removeEventListener( StatusEvent.STATUS, handleStatusEvent );
			extensionContext = null;
			_adUnitId = null;
		}
	}
}

