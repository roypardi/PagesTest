package
{
	/*
	* Testbed for WIN menu system for standalone tool
	* v 01
	* 11.12.14
	*
	* added to git
	*/
	
	
	import com.WIN.Debug.WIN_debug;
	import com.WIN.Menu.Menu_CMD;
	import com.WIN.Menu.WIN_Menu;
	import com.WIN.Utility.WIN_SplashScreen;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Screen;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	public class WINMenuTestbed extends MovieClip
	{
		var winMenu:WIN_Menu;
		var winDebug:WIN_debug;
		var winDebugEnabled:Boolean = true
		private var mainContent:MovieClip;
		private var splashScreenPath:String = "appAssets/WINLogo.png"
		private var winSplashScreen:WIN_SplashScreen;
		
		private var projectLoaded:Boolean = false;
		
		public function WINMenuTestbed()
		{
			
			onInit();
			

		}
		
		private function onInit():void
		{
			centreApp();
			
			var sfile:File = File.applicationDirectory.resolvePath(splashScreenPath);			
//			trace("Splash image found: " + sfile.exists);
			
//			trace("stage.stageWidth ", stage.stageWidth, "stage.stageHeight", stage.stageHeight);
			mainContent = new MovieClip;
//			mainContent.width = stage.stageWidth;
//			mainContent.height = stage.stageHeight;
			mainContent.x = 0;
			mainContent.y = 0;
			mainContent.opaqueBackground = true;
			addChild(mainContent);
		 
			
			winSplashScreen = new WIN_SplashScreen(mainContent, splashScreenPath);
			winSplashScreen.show();
			
			trace("mainContent ", mainContent.width, mainContent.height);
			winMenu = new WIN_Menu;
			winMenu.initMenu(this);
			addChild(winMenu);// does WIN Studio clear al children?
			
			addEventListener(Event.SELECT, this.handleMenuCmd,true, 0, true);
			
			if (winDebugEnabled)
			{
				winDebug = new WIN_debug  ;
				winDebug.createDebuggerWindow();
				winDebug.toggleDebugVisible();
			}
		}
		
		private function centreApp():void
		{
			var screenBounds:Rectangle = Screen.mainScreen.visibleBounds;
	
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			var x:int = screenBounds.x + ((screenBounds.width-w)/2);
			var y:int = screenBounds.y + ((screenBounds.height-h)/2);

			this.stage.nativeWindow.x =x;
			stage.nativeWindow.y = y;
			visible = true;
		}
		

		
		public function handleMenuCmd(e:Event):void
		{
			trace(e.target + " target");
			trace(e.currentTarget + " current target");
			var menu:WIN_Menu = e.target as WIN_Menu;
			var cmd:String = menu.msgObj.cmd;
			
			winDebug.addToLog(cmd);
			
			switch (cmd)
			{
				case Menu_CMD.ABOUT :
					//does nothing yet
					break;
				
				case Menu_CMD.OPEN :
					//projectPicker.selectProjectDirectory();
					break;
				
				case Menu_CMD.OPEN_RECENT :
					// need to do a check when this is called that project exists
					break;
				
				case Menu_CMD.CLOSE :
					
					break;
				
				case Menu_CMD.TOGGLE_FULL_SCREEN :
					
					if (stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED){
						
						stage.nativeWindow.restore();
						
					} else if (stage.nativeWindow.displayState == NativeWindowDisplayState.NORMAL){
						
						stage.nativeWindow.maximize();
					}
					
					//					NativeWindowDisplayState.NORMAL
					//			NativeWindowDisplayState.MINIMIZED
					//			NativeWindowDisplayState.MAXIMIZED
					
					//					if (stage.
					//						if(stage.displayState == StageDisplayState.NORMAL){
					//							stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					//						} else {
					//							stage.displayState = StageDisplayState.NORMAL;
					//						}
					break;
				
				case Menu_CMD.TOGGLE_DEBUG_WINDOW :
					if (winDebugEnabled)
					{
						winDebug.toggleDebugVisible();
					}
					break;
				
				case Menu_CMD.QUIT :
					if (winDebugEnabled)
					{
						winDebug.killDebug();
					}
					
					NativeApplication.nativeApplication.exit();
					break;
				
				default :
					
					break;
				
			}
			trace("cmd " + menu.msgObj.cmd);
			trace("**********handleMenuExit");
		}
		
		
		private function onOpenProject(s:String):void
		{
			trace("onOpenProject " + s);
		}
	} // end class
} // end package






