package com.hope.loader {

	import com.hope.core.hope_internal;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	use namespace hope_internal;

	public class LoaderTask extends EventDispatcher {

		//protected static var _listenerTypes:Object={onOpen: "open", onInit: "init", onComplete: "complete", onProgress: "progress", onCancel: "cancel", onFail: "fail", onError: "error", onSecurityError: "securityError", onHTTPStatus: "httpStatus", onIOError: "ioError", onScriptAccessDenied: "scriptAccessDenied", onChildOpen: "childOpen", onChildCancel: "childCancel", onChildComplete: "childComplete", onChildProgress: "childProgress", onChildFail: "childFail", onRawLoad: "rawLoad", onUncaughtError: "uncaughtError"};
		/**
		 * 可监听事件
		 * @default
		 */
		protected static var _listenerTypes:Object={onComplete: "complete", onProgress: "progress", onChildOpen: "childOpen", onChildComplete: "childComplete", onChildProgress: "childProgress", onChildFail: "childFail"};

		public var vars:Object;
		protected var items:Vector.<LoaderItem>;
		protected var withProgressListen:Boolean;

		public function LoaderTask(vars:Object) {
			this.vars=(vars != null) ? vars : {};
			if (this.vars.isGSVars) {
				this.vars=this.vars.vars;
			}
			for (var p:String in _listenerTypes) {
				if (p in this.vars && this.vars[p] is Function) {
					this.addEventListener(_listenerTypes[p], this.vars[p], false, 0, true);
					if (p == "onProgress")
						this.withProgressListen=true;
				}
			}
			this.items=new Vector.<LoaderItem>;
		}

		public function append(item:LoaderItem):void {
			if (items.indexOf(item) >= 0)
				return;
			items.push(item);
		}

		public function load():void {
			var loaded:Boolean=true;
			for each (var item:LoaderItem in items) {
				if (!item.loaded) {
					loaded=false;
					addEvent(item);
					HopeLoader.instance.addItem(item);
				}
			}
			if (loaded)
				dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onSecurityErrorHandler(event:SecurityErrorEvent):void {
			// 和 onItemErrorHandler 处理逻辑一样，后面在加新的
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_FAIL, event.target as LoaderItem));
			delEvent(event.target as LoaderItem);
			checkComplete();
		}

		private function onItemHttpStatusHandler(event:HTTPStatusEvent):void {
			// TODO Auto-generated method stub
		}

		private function onItemErrorHandler(event:IOErrorEvent):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_FAIL, event.target as LoaderItem));
			delEvent(event.target as LoaderItem);
			checkComplete();
		}

		private function onItemProgressHandler(event:ProgressEvent):void {
			if (!withProgressListen)
				return;
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_PROGRESS, event.target as LoaderItem));
			var byteTotal:int=0;
			var byteLoaded:int=0;
			for each (var item:LoaderItem in items) {
				byteTotal+=item.byteTotal;
				byteLoaded+=item.byteLoaded;
			}
			dispatchEvent(new ProgressEvent(event.type, event.bubbles, event.cancelable, byteLoaded, byteTotal));
		}

		private function onItemCompleteHandler(event:Event):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_COMPLETE, event.target as LoaderItem));
			delEvent(event.target as LoaderItem);
			checkComplete();
		}

		private function onItemOpenHandler(event:Event):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_OPEN, event.target as LoaderItem));
		}

		private function checkComplete():void {
			for each (var item:LoaderItem in items) {
				if (!item.loaded) {
					return;
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function delEvent(item:LoaderItem):void {
			if (withProgressListen)
				item.removeEventListener(ProgressEvent.PROGRESS, onItemProgressHandler);
			item.removeEventListener(Event.OPEN, onItemOpenHandler);
			item.removeEventListener(Event.COMPLETE, onItemCompleteHandler);
			item.removeEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler);
			item.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler);
			item.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
		}

		private function addEvent(item:LoaderItem):void {
			//这里要慎用弱引用，如果task用户不一定会保存，如果不保存的话，这些监听就可能立马会回收，导致出现错误！！
			if (withProgressListen)
				item.addEventListener(ProgressEvent.PROGRESS, onItemProgressHandler);
			item.addEventListener(Event.OPEN, onItemOpenHandler);
			item.addEventListener(Event.COMPLETE, onItemCompleteHandler);
			item.addEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler);
			item.addEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler);
			item.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
		}
	}
}

