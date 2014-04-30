package com.hope.loader {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;

	public class TextItem extends LoaderItem {

		private var urlLoader:URLLoader;

		public function TextItem(url:String) {
			super(url);
		}

		override public function load():void {
			super.load();
			urlLoader=new URLLoader;
			urlLoader.addEventListener(Event.OPEN, onItemOpenHandler, false, 0, true);
			urlLoader.addEventListener(Event.COMPLETE, onItemCompleteHandler, false, 0, true);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onItemProgressHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler, false, 0, true);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			urlLoader.load(urlRequest);
		}

		override public function get content():* {
			if (loaded)
				return urlLoader.data;
			return null;
		}
	}
}
