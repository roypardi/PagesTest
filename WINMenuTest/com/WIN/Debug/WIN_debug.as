package com.WIN.Debug
{
	
	import fl.controls.Button;
	
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class WIN_debug extends MovieClip
	{
		public var debugWindow:NativeWindow;
		private var txt:TextField;
		private var margin = 10;
		private var copyBtn:Button;
		private var saveBtn:Button;
		private var bkgnd:Shape;
		
		private const DEFAULT_EXTENSION:String = "txt";
		
		public function WIN_debug()
		{
			super();
		}
		
		
		public function toggleDebugVisible():void { 
			
			// if user closed window using close button 
			// we have killed window so recreate it
			if (debugWindow == null){
				createDebuggerWindow();
				debugWindow.activate();
			} else if (debugWindow.visible){
				debugWindow.visible = false;
			} else {
				debugWindow.activate();
			}
		}
		
		public function killDebug():void
		{
			debugWindow.removeEventListener(NativeWindowBoundsEvent.RESIZING, boundsChanging_handler, false);
			debugWindow.removeEventListener(NativeWindowBoundsEvent.RESIZE, boundsChanging_handler, false);

			saveBtn.removeEventListener(MouseEvent.CLICK, onSaveLog, false);
			copyBtn.removeEventListener(MouseEvent.CLICK, copySelection, false);
			debugWindow.removeEventListener(Event.CLOSE, handleCLoseEvent, false);
			
			if (!debugWindow.closed){
				debugWindow.close();
			}
			debugWindow = null;
			
		}
		
		public function handleCLoseEvent(e:Event):void
		{
			killDebug();
		}
		
		public function createDebuggerWindow():void 
		{ 	
			var options:NativeWindowInitOptions = new NativeWindowInitOptions(); 
			options.transparent = false; 
			options.systemChrome = NativeWindowSystemChrome.STANDARD; 
			options.type = NativeWindowType.UTILITY; 
			options.maximizable = false;
			options.minimizable = false;
			
			//create the window 
			debugWindow = new NativeWindow(options); 
			debugWindow.title = "A Bug's Life"; 
			debugWindow.width = 250; 
			debugWindow.height = 400; 
			debugWindow.stage.align = StageAlign.TOP_LEFT; 
			debugWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			
			createWindowContent();
			debugWindow.stage.addChild(this);
			
			debugWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, boundsChanging_handler, false, 0, true);
			debugWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, boundsChanging_handler, false, 0, true);
			debugWindow.addEventListener(Event.CLOSE, handleCLoseEvent, false, 0, true);			
		} 
		
		
		private function createWindowContent():void
		{	 
			var w:int = 250;
			var h:int = 400;
			
			bkgnd = new Shape;
			
			bkgnd.graphics.beginFill(0xdcd9d2);
			bkgnd.graphics.drawRect(0, 0, w, h);
			bkgnd.graphics.endFill();
			bkgnd.x = 0;
			bkgnd.y = 0;
			addChild(bkgnd);
			
			txt = new TextField();
			txt.width = w - (margin*2);
			txt.height = h - (margin* 7);
			txt.x = margin;
			txt.y = margin;
			
			txt.background = true;
			txt.backgroundColor = 0xFFFFFF;
			txt.border = true;
			txt.borderColor = 0x000000;
			
			txt.alwaysShowSelection = true;
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.size = 16;
			txt.defaultTextFormat = txtFormat;
			addChild(txt);
			
			saveBtn = new Button();
			saveBtn.label = "Save Log File";
			
			saveBtn.x = w - (saveBtn.width + margin);
			saveBtn.y = h - (saveBtn.height+ margin * 3);
			saveBtn.addEventListener(MouseEvent.CLICK, onSaveLog, false, 0, true);
			addChild(saveBtn)
			
			copyBtn = new Button();
			copyBtn.label = "Copy Selection";
			
			copyBtn.x = 0 + margin;
			copyBtn.y = h - (copyBtn.height+ margin * 3);
			copyBtn.addEventListener(MouseEvent.CLICK, copySelection, false, 0, true);
			addChild(copyBtn)
			
		}
		
		
		/**
		 * Resize window items when window size changes 
		 * @param boundsEvent
		 * 
		 */		
		function boundsChanging_handler(boundsEvent:NativeWindowBoundsEvent):void
		{
			switch(boundsEvent.type){
				
				case NativeWindowBoundsEvent.RESIZING:
				case NativeWindowBoundsEvent.RESIZE:
					
					var w:int = boundsEvent.afterBounds.width;
					var h:int = boundsEvent.afterBounds.height;
					
					if (w <= 225 || h <= 200){
						boundsEvent.preventDefault();
					} else {
						
						bkgnd.width = w;
						bkgnd.height = h;
						
						txt.width = w - (margin*2);;
						txt.height = h - (margin * 7);
						
						saveBtn.x = w - (saveBtn.width + margin);
						saveBtn.y = h - (saveBtn.height+ margin * 3);
						
						copyBtn.x = 0 + margin;
						copyBtn.y = h - (copyBtn.height+ margin * 3);
					}
					break;
				
				default:
					
					break;
			}
		}
	
		function onSelectedSave(evt:Event):void
		{
			evt.target.removeEventListener(Event.SELECT, onSelectedSave);
			evt.target.removeEventListener(Event.CANCEL, onCancelSave);
			
			var tmpArr:Array = File(evt.target).nativePath.split(File.separator); 
			var fileName:String = tmpArr.pop();//remove last array item and return its content 
			
			var conformedFileDef:String = conformExtension(fileName);
			var finalName:String = "file://" + tmpArr.join(File.separator) + File.separator +  conformedFileDef;
			var conformedFile:File = new File(finalName);
			
			var myStream:FileStream = new FileStream();
			myStream.addEventListener(Event.COMPLETE, onCompleteSave, false, 0, true);
			myStream.openAsync(conformedFile, FileMode.WRITE);
			myStream.writeUTFBytes(txt.text);		
		}
		
		function onCancelSave(evt:Event):void
		{
			evt.target.removeEventListener(Event.SELECT, onSelectedSave);
			evt.target.removeEventListener(Event.CANCEL, onCancelSave);
		}
		
		
		function onCompleteSave(evt:Event):void
		{
			evt.target.close();
			evt.target.removeEventListener(Event.COMPLETE, onCompleteSave);
		}
		
		private function onSaveLog(e:MouseEvent):void
		{
			
			var saveFile:File = File.desktopDirectory;
			saveFile.addEventListener(Event.SELECT, onSelectedSave, false, 0, true);
			saveFile.addEventListener(Event.CANCEL, onCancelSave, false, 0, true);
			saveFile.browseForSave("Save log file");
			
		}
		
		public function addToLog(s:String):void
		{
			txt.appendText(s + "\n");
			
		}
		
		private function copySelection(e:MouseEvent):void {
			System.setClipboard(txt.selectedText);
		}
		
		private function conformExtension(fileDef:String):String 
		{ 
			var fileExtension:String = fileDef.split(".")[1]; 
			
			if( fileExtension == DEFAULT_EXTENSION){
				return fileDef; 
			} else {
				return fileDef.split(".")[0] + "." + DEFAULT_EXTENSION; 
			}
		} 
		
		
		
	}
	
	
}

