package com.sticksports.nativeExtensions.mopub
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class MoPubInterstitial extends EventDispatcher
	{
// class variables

		private var _adUnitId : String;
		private var _testing : Boolean = false;

// properties
		public function get adUnitId() : String
		{
			return _adUnitId;
		}

		public function get isReady() : Boolean
		{
			return false;
		}

		public function get testing() : Boolean
		{
			return _testing;
		}

		public function set testing( value : Boolean ) : void
		{
			_testing = value;
		}

// methods

		public function MoPubInterstitial( adUnitId : String )
		{
			_adUnitId = adUnitId;
		}
		
		public function load() : void
		{
		}

		public function show() : Boolean
		{
			return false;
		}
		
		public function dispose() : void
		{
		}
	}
}

