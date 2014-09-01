package com.yueyi.core.load.hope
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	public class LoaderTask extends EventDispatcher
	{

		//protected static var _listenerTypes:Object={onOpen: "open", onInit: "init", onComplete: "complete", onProgress: "progress", onCancel: "cancel", onFail: "fail", onError: "error", onSecurityError: "securityError", onHTTPStatus: "httpStatus", onIOError: "ioError", onScriptAccessDenied: "scriptAccessDenied", onChildOpen: "childOpen", onChildCancel: "childCancel", onChildComplete: "childComplete", onChildProgress: "childProgress", onChildFail: "childFail", onRawLoad: "rawLoad", onUncaughtError: "uncaughtError"};
		//public static const LISTENERTYPES:Object = {onComplete: "complete", onProgress: "progress", onChildOpen: "childOpen", onChildComplete: "childComplete", onChildProgress: "childProgress", onChildFail: "childFail"};

		protected var _vars:Object;
		protected var _rootLoader:HopeLoader;
		protected var _doLoaded:Boolean; //这个任务是否已经开始加载

		protected var _withProgressListen:Boolean;
		protected var _auditedSize:int;
		protected var _priority:int;
		protected var _items:Vector.<LoaderItem>;

		public function get vars():Object {
			return _vars;
		}

		public function LoaderTask(vars:Object, rootLoader:HopeLoader) {
			this._vars = vars;
			this._rootLoader = rootLoader;
			for (var p:String in HopeLoader.LISTENERTYPES) {
				if (p in this._vars && this._vars[p] is Function) {
					this.addEventListener(HopeLoader.LISTENERTYPES[p], this._vars[p], false, 0, true);
					if (p == HopeLoader.ONPROGRESS) {
						this._withProgressListen = true;
						this._auditedSize = this._vars[HopeLoader.AUDITEDSIZE];
					}
				}
			}
			if (HopeLoader.PRIORITY in this._vars)
				this._priority = this._vars[HopeLoader.PRIORITY];
			else
				this._priority = HopeLoader.NMLPRIORITY;
			this._items = new Vector.<LoaderItem>;
		}

		public function cancel(url:String = null):void {
			if (!_doLoaded)
				return;
			for each (var item:LoaderItem in _items) {
				if (item.isLoaded)
					continue;
				if (url) {
					if (item.url == url) {
						delEvent(item);
						_rootLoader.delItem(item, _priority);
					}
				} else {
					delEvent(item);
					_rootLoader.delItem(item, _priority);
				}
			}
		}

		public function append(item:LoaderItem):void {
			if (_items.indexOf(item) >= 0)
				return;
			_items.push(item);

			if (_doLoaded) {
				if (item.isLoaded) {
					dispatchEvent(new Event(Event.COMPLETE));
				} else {
					addEvent(item);
					_rootLoader.addItem(item, _priority);
				}
			}
		}

		public function load():void {
			if (_doLoaded)
				return;
			_doLoaded = true;

			var loaded:Boolean = true;
			for each (var item:LoaderItem in _items) {
				if (!item.isLoaded) {
					loaded = false;
					addEvent(item);
					_rootLoader.addItem(item, _priority);
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
			if (!_withProgressListen)
				return;
			//dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_PROGRESS, event.target as LoaderItem));
			var byteTotal:int = 0;
			var byteLoaded:int = 0;
			for each (var item:LoaderItem in _items) {
				if (item.byteLoaded == 0 && item.byteTotal == 0) {
					byteTotal += _auditedSize;
				} else {
					byteTotal += item.byteTotal;
					byteLoaded += item.byteLoaded;
				}
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
			for each (var item:LoaderItem in _items) {
				if (!item.isLoaded) {
					return;
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function delEvent(item:LoaderItem):void {
			if (_withProgressListen)
				item.removeEventListener(ProgressEvent.PROGRESS, onItemProgressHandler);
			item.removeEventListener(Event.OPEN, onItemOpenHandler);
			item.removeEventListener(Event.COMPLETE, onItemCompleteHandler);
			item.removeEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler);
			item.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler);
			item.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
		}

		private function addEvent(item:LoaderItem):void {
			//这里要慎用弱引用，如果task用户不一定会保存，如果不保存的话，这些监听就可能立马会回收，导致出现错误！！
			if (_withProgressListen)
				item.addEventListener(ProgressEvent.PROGRESS, onItemProgressHandler);
			item.addEventListener(Event.OPEN, onItemOpenHandler);
			item.addEventListener(Event.COMPLETE, onItemCompleteHandler);
			item.addEventListener(IOErrorEvent.IO_ERROR, onItemErrorHandler);
			item.addEventListener(HTTPStatusEvent.HTTP_STATUS, onItemHttpStatusHandler);
			item.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
		}

		public function traceItem():void {
			trace("===============tracetask==================");
			for (var k:Object in vars)
				trace(k, vars[k]);
			for each (var item:LoaderItem in _items)
				trace(item.url, item.isError, item.isLoaded, item.httpStatus);
		}
	}
}

