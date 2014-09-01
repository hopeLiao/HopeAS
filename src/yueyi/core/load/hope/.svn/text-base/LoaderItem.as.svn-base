package com.yueyi.core.load.hope
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	public class LoaderItem extends EventDispatcher
	{

		protected var urlRequest:URLRequest;
		protected var errorNum:int;

		public var loadTimes:int;

		public var url:String;
		public var vars:Object;

		public var httpStatus:int;
		public var byteTotal:int;
		public var byteLoaded:int;
		public var isLoaded:Boolean; //对应的资源已经加载过，不管成功与否
		public var isError:Boolean;

		public function LoaderItem(url:String, vars:Object) {
			this.url = url;
			this.vars = vars;
		}

		public function load():void {
			//正常情况下，只有在url的length不为0的时候加载才有效！这里先不做判断
			var realUrl:String = url;
			if (HopeLoader.VERSION in this.vars) {
				var ver:int = this.vars[HopeLoader.VERSION];
				if (ver == 0)
					ver = Math.random() * 100000;
				realUrl += "?ver=" + ver;
			}
			//trace("loadurl", realUrl);
			urlRequest = new URLRequest(realUrl);
		}

		public function get content():* {
			return null;
		}

		protected function onSecurityErrorHandler(event:SecurityErrorEvent):void {
			isLoaded = true;
			isError = true;
			trace("[[[loaditem error]]]", url);
			dispatchEvent(new SecurityErrorEvent(event.type, event.bubbles, event.cancelable, event.text, event.errorID));
		}

		protected function onItemHttpStatusHandler(event:HTTPStatusEvent):void {
			httpStatus = event.status;
			dispatchEvent(new HTTPStatusEvent(event.type, event.bubbles, event.cancelable, event.status));
		}

		protected function onItemErrorHandler(event:IOErrorEvent):void {
			errorNum++;
			trace("[[[loaditem error]]]", url);
			if (errorNum >= HopeLoader.MAXTRYTIMES) {
				isLoaded = true;
				isError = true;
				dispatchEvent(new IOErrorEvent(event.type, event.bubbles, event.cancelable, event.text, event.errorID));
			} else {
				load();
			}
		}

		protected function onItemProgressHandler(event:ProgressEvent):void {
			byteTotal = event.bytesTotal;
			byteLoaded = event.bytesLoaded;
			dispatchEvent(new ProgressEvent(event.type, event.bubbles, event.cancelable, byteLoaded, byteTotal));
		}

		protected function onItemCompleteHandler(event:Event):void {
			isLoaded = true;
			dispatchEvent(new Event(event.type, event.bubbles, event.cancelable));
		}

		protected function onItemOpenHandler(event:Event):void {
			dispatchEvent(new Event(event.type, event.bubbles, event.cancelable));
		}
	}
}

