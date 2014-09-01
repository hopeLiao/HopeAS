package com.yueyi.core.load.hope
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	public class ImageItem extends LoaderItem
	{

		private var loader:Loader;

		public function ImageItem(url:String, vars:Object) {
			super(url, vars);
		}

		override public function load():void {
			super.load();
			var _context:* = vars[HopeLoader.CONTEXT] || null;
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onItemOpenHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onItemProgressHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			loader.load(urlRequest, _context);
		}

		override public function get content():* {
			if (isLoaded)
				return loader.content;
			return null;
		}

		public function getDefinitionByName(className:String):Object {
			if (isLoaded) {
				if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className)) {
					return loader.contentLoaderInfo.applicationDomain.getDefinition(className);
				}
			}
			return null;
		}

		public function hasDefinitionName(className:String):Boolean {
			if (isLoaded && !isError)
				return loader.contentLoaderInfo.applicationDomain.hasDefinition(className);
			return false;
		}
	}
}
