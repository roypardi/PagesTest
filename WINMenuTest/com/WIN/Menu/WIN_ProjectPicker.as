package com.WIN.Menu
{
	import com.WIN.Menu.WIN_Menu;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	
	
	
	public class WIN_ProjectPicker
	{
		// defines the name of the file indictating a "WIN Studio project'
		private static const WIN_STUDIO_PROJECT:String = "WIN_Project.txt";
		
		// used to start the file picker at the last directory selected
		private var lastDirectoryPath:String; 
		private var winMenu:WIN_Menu;
		
		public function WIN_ProjectPicker(m:WIN_Menu)
		{
			winMenu = m;
		}
		
		/**
		 * Called from WIN_Menu to open directory picker 
		 */		
		public function selectProjectDirectory():void
		{
			var directory:File;
			if (lastDirectoryPath) {
				directory = new File(lastDirectoryPath);
			} else {
				// start in documents directory
				directory = File.documentsDirectory; 
			}
			
			directory.addEventListener(Event.SELECT, handleDirectorySelectorClose); 
			directory.addEventListener(Event.CANCEL, handleDirectorySelectorClose);
			directory.browseForDirectory("Select a WIN Studio project..."); 
		}
		
		/**
		 *  Called after directory picker closed. If user did not cancel
		 *  then look for the WIN_STUDIO_PROJECT file and if found,
		 *  build some paths and call WIN_Menu instance
		 * @param e Event
		 * 
		 */		
		private function handleDirectorySelectorClose(e:Event):void 
		{ 
			var msg:Object = new Object;
			var projectXMLpath:String = "";
			var result:Boolean = false;
			var directory:File = e.target as File;
			directory.removeEventListener(Event.SELECT, handleDirectorySelectorClose); 
			directory.removeEventListener(Event.CANCEL, handleDirectorySelectorClose); 
			
			// if user didn't cancel then check their selection 
			if (e.type == "select") {
				
				var files:Array = directory.getDirectoryListing();
				for each (var item in files){
					if (item.name == WIN_STUDIO_PROJECT){
						result = true;
						projectXMLpath = readTextFile(item);
						break;
					}
				}
				
				msg["result"] = result;
				
				if (result){
					var xmlFile:File = directory.resolvePath(directory.nativePath + projectXMLpath);
					
					// used to return user to troot of last directory selected
					var tmpArray:Array = directory.url.split("/");
					tmpArray = tmpArray.slice(0, tmpArray.length - 1);
					lastDirectoryPath= tmpArray.join("/");
					
					msg["directoryPath"] =  directory.nativePath;
					msg["projectXMLpath"] = xmlFile.nativePath;
				}
				
				winMenu.projectPickerResult(msg);
			}
		}
		
		private function readTextFile(fileObj:File):String
		{
			var returnString:String = "";
			var fs:FileStream = new FileStream();
			fs.open(fileObj,FileMode.READ);
			returnString = fs.readMultiByte(fs.bytesAvailable, "iso-8859-1"); 
			fs.close();
			
			return returnString;
		}
		
		
		
	} // class end
} // package end