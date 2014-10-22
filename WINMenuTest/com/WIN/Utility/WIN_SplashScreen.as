package com.WIN.Utility
{
//	import fl.transitions.Fade;
//	import fl.transitions.Transition;
//	import fl.transitions.TransitionManager;
//	import fl.transitions.easing.*;
//	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Screen;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	
	public dynamic class WIN_SplashScreen extends MovieClip
	{
		private var myTarget:MovieClip;
		private var imagePath:String;
		private var splashScreen:Loader;
		
		
		public function WIN_SplashScreen(mc:MovieClip, str:String)
		{
			super();
			
			myTarget = mc;
			imagePath = str;
			this.opaqueBackground = false;
			var rect:Shape = new Shape(); 
//			rect.graphics.lineStyle(12, 0x0000FF);
			rect.graphics.beginFill(0xFFFFFF); 
			rect.graphics.drawRect(0, 0, 1024, 768); 
			rect.graphics.endFill();
			this.addChild(rect);
			rect.x = 0;
			rect.y = 0;
		}
		
		
		public function show():void
		{

			if (splashScreen == null){
				var file:File = File.applicationDirectory.resolvePath(imagePath);
				if (file.exists){
					
					splashScreen = new Loader();
					splashScreen.contentLoaderInfo.addEventListener(Event.COMPLETE, onSplashScreenLoaded, false, 0 , true);
					splashScreen.load(new URLRequest(file.url));
				} else {
					
					trace("splash not found" + file.url);
				}
			}
		}
		
		public function hide():void
		{
			if (splashScreen.parent != null){
				splashScreen.parent.removeChild(splashScreen);
			}
			splashScreen = null;
		}
		
		private function onSplashScreenLoaded(e:Event):void
		{
			splashScreen.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSplashScreenLoaded, false);
			
			addChild(splashScreen);
			myTarget.addChild(this);
 
			var w:int = splashScreen.width;
			var h:int = splashScreen.height;
	 
			var x:int = (this.width - w) /2;
			var y:int = (this.height - h) /2;
 
			splashScreen.x = x;
			splashScreen.y = y;
	 
			
//			TransitionManager.start(this, {type:Fade, direction:Transition.IN, duration:1, easing:Strong.easeIn});
			
		}
		
		
	}
}