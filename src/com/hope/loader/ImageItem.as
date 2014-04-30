package com.hope.loader {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	public class ImageItem extends LoaderItem {

		private var loader:Loader;

		public function ImageItem(url:String) {
			super(url);
		}

		override public function load():void {
			super.load();
			loader=new Loader;
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onItemOpenHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onItemProgressHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			loader.load(urlRequest);
		}

		override public function get content():* {
			if (loaded)
				return loader.content;
			return null;
		}
	}
}
