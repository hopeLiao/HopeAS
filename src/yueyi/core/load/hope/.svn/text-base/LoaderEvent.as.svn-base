package com.yueyi.core.load.hope
{
	import flash.events.Event;

	public class LoaderEvent extends Event
	{

		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children begins loading. **/
		public static const CHILD_OPEN:String = "childOpen";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children dispatches a <code>PROGRESS</code> Event. **/
		public static const CHILD_PROGRESS:String = "childProgress";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children aborts its loading. This can happen when the loader fails, when <code>cancel()</code> is manually called, or when another loader is prioritized in the loading queue.  **/
		public static const CHILD_CANCEL:String = "childCancel";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children finishes loading. **/
		public static const CHILD_COMPLETE:String = "childComplete";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children fails to load. **/
		public static const CHILD_FAIL:String = "childFail";
//		/** Dispatched when the loader begins loading, like when its <code>load()</code> method is called. **/
//		public static const OPEN:String="open";
//		/** Dispatched when the loader's <code>bytesLoaded</code> changes. **/
//		public static const PROGRESS:String="progress";
//		/** Dispatched when the loader aborts its loading. This can happen when the loader fails, when <code>cancel()</code> is manually called, or when another loader is prioritized in the loading queue. **/
//		public static const CANCEL:String="cancel";
//		/** Dispatched when the loader fails. **/
//		public static const FAIL:String="fail";
//		/** Dispatched when the loader initializes which means different things for different loaders. For example, a SWFLoader dispatches <code>INIT</code> when it downloads enough of the swf to render the first frame. When a VideoLoader receives MetaData, it dispatches its <code>INIT</code> event, as does an MP3Loader when it receives ID3 data. See the docs for each class for specifics. **/
//		public static const INIT:String="init";
//		/** Dispatched when the loader finishes loading. **/
//		public static const COMPLETE:String="complete";
//		/** Dispatched when the loader (or one of its children) receives an HTTP_STATUS event (see Adobe docs for specifics). **/
//		public static const HTTP_STATUS:String="httpStatus";
//		/** When script access is denied for a particular loader (like if an ImageLoader or SWFLoader tries loading from another domain and the crossdomain.xml file is missing or doesn't grant permission properly), a SCRIPT_ACCESS_DENIED LoaderEvent will be dispatched. **/
//		public static const SCRIPT_ACCESS_DENIED:String="scriptAccessDenied";
//		/** Dispatched when the loader (or one of its children) throws any error, like an IO_ERROR or SECURITY_ERROR. **/
//		public static const ERROR:String="error";
//		/** Dispatched when the the loader (or one of its children) encounters an IO_ERROR (typically when it cannot find the file at the specified <code>url</code>). **/
//		public static const IO_ERROR:String="ioError";
//		/** Dispatched when the loader (or one of its children) encounters a SECURITY_ERROR (see Adobe's docs for details). **/
//		public static const SECURITY_ERROR:String="securityError";
//		/** Dispatched when a swf that's loaded by a SWFLoader encounters an UncaughtErrorEvent which is basically any Error that gets thrown outside of a try...catch statement. This can be useful when subloading swfs from a 3rd party that may contain errors. However, UNCAUGHT_ERROR events will only be dispatched if the parent swf is published for Flash Player 10.1 or later! See SWFLoader's <code>suppressUncaughtErrors</code> special property if you'd like to have it automatically suppress these errors. The original UncaughtErrorEvent is stored in the LoaderEvent's <code>data</code> property. So, for example, if you'd like to call <code>preventDefault()</code> on that event, you'd do <code>myLoaderEvent.data.preventDefault()</code>. **/
//		public static const UNCAUGHT_ERROR:String="uncaughtError";

		public var item:LoaderItem;

		public function LoaderEvent(type:String, item:LoaderItem, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.item = item;
		}

		override public function clone():Event {
			return new LoaderEvent(this.type, this.item, this.bubbles, this.cancelable);
		}
	}
}
