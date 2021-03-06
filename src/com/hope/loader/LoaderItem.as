package com.hope.loader {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	public class LoaderItem extends EventDispatcher {

		/**
		 * 错误尝试次数
		 * @default
		 */
		protected static const MAXTRYTIMES:int=3;

		protected var urlRequest:URLRequest;
		protected var errorNum:int;

		public var url:String;
		public var httpStatus:int;
		public var byteTotal:int;
		public var byteLoaded:int;
		public var loaded:Boolean; //对应的资源已经加载过，不管成功与否
		public var errored:Boolean;

		public function LoaderItem(url:String) {
			this.url=url;
		}

		public function load():void {
			//正常情况下，只有在url的length不为0的时候加载才有效！这里先不做判断
			urlRequest=new URLRequest(url);
		}

		public function get content():* {
			return null;
		}

		protected function onSecurityErrorHandler(event:SecurityErrorEvent):void {
			loaded=true;
			errored=true;
			dispatchEvent(new SecurityErrorEvent(event.type, event.bubbles, event.cancelable, event.text, event.errorID));
		}

		protected function onItemHttpStatusHandler(event:HTTPStatusEvent):void {
			httpStatus=event.status;
			dispatchEvent(new HTTPStatusEvent(event.type, event.bubbles, event.cancelable, event.status));
		}

		protected function onItemErrorHandler(event:IOErrorEvent):void {
			errorNum++;
			if (errorNum >= MAXTRYTIMES) {
				loaded=true;
				errored=true;
				dispatchEvent(new IOErrorEvent(event.type, event.bubbles, event.cancelable, event.text, event.errorID));
			} else {
				load();
			}
		}

		protected function onItemProgressHandler(event:ProgressEvent):void {
			byteTotal=event.bytesTotal;
			byteLoaded=event.bytesLoaded;
			dispatchEvent(new ProgressEvent(event.type, event.bubbles, event.cancelable, byteLoaded, byteTotal));
		}

		protected function onItemCompleteHandler(event:Event):void {
			loaded=true;
			dispatchEvent(new Event(event.type, event.bubbles, event.cancelable));
		}

		protected function onItemOpenHandler(event:Event):void {
			dispatchEvent(new Event(event.type, event.bubbles, event.cancelable));
		}
	}
}

