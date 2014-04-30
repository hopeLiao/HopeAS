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

		public function LoaderTask(vars:Object) {
			this.vars=(vars != null) ? vars : {};
			if (this.vars.isGSVars) {
				this.vars=this.vars.vars;
			}
			for (var p:String in _listenerTypes) {
				if (p in this.vars && this.vars[p] is Function) {
					this.addEventListener(_listenerTypes[p], this.vars[p], false, 0, true);
				}
			}
			this.items=new Vector.<LoaderItem>;
		}

		public function append(item:LoaderItem):void {
			if (items.indexOf(item) < 0)
				items.push(item);
			item.push(this);
		}

		public function load():void {
			var loaded:Boolean=true;
			for each (var item:LoaderItem in items) {
				if (!item.loaded) {
					HopeLoader.instance.loadItem(item);
					loaded=false;
				}
			}
			if (loaded)
				dispatchEvent(new Event(Event.COMPLETE));
		}

		public function onSecurityErrorHandler(item:LoaderItem, event:SecurityErrorEvent):void {
			// 和 onItemErrorHandler 处理逻辑一样，后面在加新的
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_FAIL, item));
			checkComplete();
		}

		public function onItemHttpStatusHandler(item:LoaderItem, event:HTTPStatusEvent):void {
			// TODO Auto-generated method stub
		}

		public function onItemErrorHandler(item:LoaderItem, event:IOErrorEvent):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_FAIL, item));
			checkComplete();
		}

		public function onItemProgressHandler(item:LoaderItem, event:ProgressEvent):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_PROGRESS, item));
			var byteTotal:int=0;
			var byteLoaded:int=0;
			for each (var item:LoaderItem in items) {
				byteTotal+=item.byteTotal;
				byteLoaded+=item.byteLoaded;
			}
			dispatchEvent(new ProgressEvent(event.type, event.bubbles, event.cancelable, byteLoaded, byteTotal));
			HopeLoader.instance.debug();
		}

		public function onItemCompleteHandler(item:LoaderItem, event:Event):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_COMPLETE, item));
			checkComplete();
		}

		public function onItemOpenHandler(item:LoaderItem, event:Event):void {
			dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_OPEN, item));
		}

		private function checkComplete():void {
			for each (var item:LoaderItem in items) {
				if (!item.loaded) {
					return;
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}

