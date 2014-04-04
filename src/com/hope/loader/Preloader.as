package com.hope.loader
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	/**
	 * 项目自加载
	 * 在文档类中加上这句就可以 [Frame(factoryClass="Preloader")]
	 * @author hope
	 */
	public class Preloader extends MovieClip 
	{

		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			// show loader
		}

		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}

		private function progress(e:ProgressEvent):void 
		{
			// update loader
		}

		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				// hide loader
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				stop();
				startup();
			}
		}

		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;	//“main”是文档类类名
			addChild(new mainClass() as DisplayObject);
		}		
	}
}

