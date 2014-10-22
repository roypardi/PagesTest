/**
 * RP 10.12.14
 * 
 * Handles menu system: passing menu command events to timeline code
 * 
 * hack to get around not being able to remove the timeline code
 * in the .fla. Revisit this if/when that code gets moved into
 * a document class 
 * 
 * when a menu action occurs, the command string is stored in 'msgObj'
 * and an event is dispatched. The timeline code has an event listener
 * for this event. It grabs the cmd out of 'msgObj' and life goes on.
 * 
 */

/**
 * TODO:
 * 
 *  - creation/teardown of menu based on data passed in from project XML
 * 		currently no idea @ the format of that or how it will work.
 *  - decision about how menu is to be laid out: sections or what
 * 		> list the case name?
 *  - write recent docs management code 
 * 
 *  - need to test on the PC
 */
package com.WIN.Menu
{
	
	import com.WIN.Menu.Menu_CMD;
	import com.WIN.Menu.WIN_ProjectPicker;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class WIN_Menu extends Sprite
	{
		
		private var WINStudio_instance:MovieClip;
		
		private var WINMenuItem:NativeMenuItem;
		private var projectPicker:WIN_ProjectPicker;
		
		public var msgObj:Object;
		
		private var recentDocuments:Array =  
			new Array(new File("app-storage:/GreatGatsby.pdf"),  
				new File("app-storage:/WarAndPeace.pdf"),  
				new File("app-storage:/Iliad.pdf")); 
		
		
		/**
		 * Init with just an "open..." menu
		 * 
		 * TODO:
		 * -define method to take XML or array of module names/links/refs
		 * to change menu as projects are loaded
		 * 
		 * TODO: handle recent files
		 * 
		 *  
		 * @param s
		 * 
		 */		
		public function WIN_Menu()
		{
			
		}
		
		
		/**
		 * initMenu
		 * @param s: MovieClip
		 * 
		 */		
		public function initMenu(s:MovieClip):void
		{
			projectPicker = new WIN_ProjectPicker(this);
			
			WINStudio_instance = s;
			msgObj = new Object;
			msgObj.cmd = "";
			
			WINMenuItem = new NativeMenuItem("WIN Interactive");
			WINMenuItem.submenu = createWinMenu(); 
			
			var fileMenu:NativeMenuItem; 
			var editMenu:NativeMenuItem; 
			
			loadWinStudioMenu();
			//			if (NativeWindow.supportsMenu){ 
			//				
			//				WINStudio_instance.nativeWindow.menu = new NativeMenu(); 
			//				//WINStudio_instance.nativeWindow.menu.addEventListener(Event.SELECT, selectCommandMenu); 
			//		 		
			//				WINMenuItem = WINStudio_instance.nativeWindow.menu.addItem(new NativeMenuItem("WIN Interactive")); 
			//				WINMenuItem.submenu = createWinMenu(); 
			//				
			////				editMenu = WINStudio_instance.nativeWindow.menu.addItem(new NativeMenuItem("Edit")); 
			////				editMenu.submenu = createEditMenu(); 
			//			} 
			//			
			//			if (NativeApplication.supportsMenu){ 
			//				NativeApplication.nativeApplication.menu = new NativeMenu(); 
			//				//NativeApplication.nativeApplication.menu.addEventListener(Event.SELECT, selectCommandMenu); 
			//				
			//				WINMenuItem = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("WIN Interactive")); 
			//				WINMenuItem.submenu = createWinMenu(); 
			//				
			////				WINMenuItem = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("File")); 
			////				WINMenuItem.submenu = createFileMenu(); 
			////				
			////				WINMenuItem = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("Edit")); 
			////				WINMenuItem.submenu = createEditMenu();
			//	 
			//			} 
		}
		
		
		
		
		public function loadProjectMenu():void
		{
			
			
		}
		
		public function loadWinStudioMenu():void
		{
			// Windows
			if (NativeWindow.supportsMenu){ 
//				WINStudio_instance.nativeWindow.menu = new NativeMenu(); 
//				WINStudio_instance.nativeWindow.menu.addItem(WINMenuItem);
				
				WINStudio_instance.stage.nativeWindow.menu = new NativeMenu(); 
				WINStudio_instance.stage.nativeWindow.menu.addItem(WINMenuItem);
			} 
			
			// OSX
			if (NativeApplication.supportsMenu){ 
				NativeApplication.nativeApplication.menu = new NativeMenu(); 
				NativeApplication.nativeApplication.menu.addItem(WINMenuItem); 
			} 
		}
		
		/**
		 * create "WIN Interactive" category;
		 * 
		 * About - some splash screen 
		 * ---separator---
		 * Open Project... *o
		 * Open Recent >> subMeny
		 * ---separator---
		 * Close Project   - any key cmd?
		 * ---separator---
		 * Quit *q
		 * @return @NativeMenu
		 * 
		 */		
		private function createWinMenu():NativeMenu 
		{ 	
			var menuCategory:NativeMenu = new NativeMenu(); 
			var tmpCmd:NativeMenuItem;
			
			menuCategory.addEventListener(Event.SELECT, selectCommandMenu,false, 0, true); 
			
			// about
			tmpCmd = menuCategory.addItem(new NativeMenuItem(Menu_CMD.ABOUT)); 
			tmpCmd.addEventListener(Event.SELECT, selectCommand); 
			
			// separator
			tmpCmd= menuCategory.addItem(new NativeMenuItem("", true));
			
			// open cmd
			tmpCmd = menuCategory.addItem(new NativeMenuItem(Menu_CMD.OPEN)); 
			tmpCmd.keyEquivalent = "o";
			tmpCmd.addEventListener(Event.SELECT, selectCommand); 
			
			// open recent cmd
			tmpCmd = menuCategory.addItem(new NativeMenuItem(Menu_CMD.OPEN_RECENT));  
			tmpCmd.submenu = new NativeMenu(); 
			tmpCmd.submenu.addEventListener(Event.DISPLAYING, updateRecentDocumentMenu); 
			tmpCmd.submenu.addEventListener(Event.SELECT, selectCommandMenu); 
			
			// separator
			tmpCmd= menuCategory.addItem(new NativeMenuItem("", true)); 
			
			// close
			tmpCmd = menuCategory.addItem(new NativeMenuItem(Menu_CMD.CLOSE)); 
			tmpCmd.addEventListener(Event.SELECT, selectCommand); 
			
			// separator
			tmpCmd= menuCategory.addItem(new NativeMenuItem("", true)); 
			
			// toggle full screen
			tmpCmd = menuCategory.addItem(new NativeMenuItem(Menu_CMD.TOGGLE_FULL_SCREEN)); 
			tmpCmd.keyEquivalent = "t";
			tmpCmd.addEventListener(Event.SELECT, selectCommand); 
			
			// debug window
			tmpCmd = menuCategory.addItem(new NativeMenuItem(Menu_CMD.TOGGLE_DEBUG_WINDOW)); 
			tmpCmd.addEventListener(Event.SELECT, selectCommand); 
			
			// separator
			tmpCmd= menuCategory.addItem(new NativeMenuItem("", true)); 
			
			// Quit cmd
			tmpCmd= menuCategory.addItem(new NativeMenuItem(Menu_CMD.QUIT)); 
			tmpCmd.keyEquivalent = "q";
			tmpCmd.addEventListener(Event.SELECT, selectCommand); 
			
			return menuCategory
		} 
		
		
		private function createFileMenu():NativeMenu { 
			var fileMenu:NativeMenu = new NativeMenu(); 
			fileMenu.addEventListener(Event.SELECT, selectCommandMenu); 
			
			var newCommand:NativeMenuItem = fileMenu.addItem(new NativeMenuItem("New")); 
			newCommand.addEventListener(Event.SELECT, selectCommand); 
			
			var saveCommand:NativeMenuItem = fileMenu.addItem(new NativeMenuItem("Save")); 
			saveCommand.addEventListener(Event.SELECT, selectCommand); 
			
			var openRecentMenu:NativeMenuItem =  
				fileMenu.addItem(new NativeMenuItem("Open Recent")); 
			
			openRecentMenu.submenu = new NativeMenu(); 
			openRecentMenu.submenu.addEventListener(Event.DISPLAYING, 
				updateRecentDocumentMenu); 
			openRecentMenu.submenu.addEventListener(Event.SELECT, selectCommandMenu); 
			
			return fileMenu; 
		} 
		
		private function createEditMenu():NativeMenu { 
			var editMenu:NativeMenu = new NativeMenu(); 
			editMenu.addEventListener(Event.SELECT, selectCommandMenu); 
			
			var copyCommand:NativeMenuItem = editMenu.addItem(new NativeMenuItem("Copy")); 
			copyCommand.addEventListener(Event.SELECT, selectCommand); 
			copyCommand.keyEquivalent = "c"; 
			var pasteCommand:NativeMenuItem =  
				editMenu.addItem(new NativeMenuItem("Paste")); 
			pasteCommand.addEventListener(Event.SELECT, selectCommand); 
			pasteCommand.keyEquivalent = "v"; 
			editMenu.addItem(new NativeMenuItem("", true)); 
			var preferencesCommand:NativeMenuItem =  
				editMenu.addItem(new NativeMenuItem("Preferences")); 
			preferencesCommand.addEventListener(Event.SELECT, selectCommand); 
			
			return editMenu; 
		} 
		
		private function updateRecentDocumentMenu(event:Event):void { 
			trace("Updating recent document menu."); 
			var docMenu:NativeMenu = NativeMenu(event.target); 
			
			for each (var item:NativeMenuItem in docMenu.items) { 
				docMenu.removeItem(item); 
			} 
			
			for each (var file:File in recentDocuments) { 
				var menuItem:NativeMenuItem =  
					docMenu.addItem(new NativeMenuItem(file.name)); 
				menuItem.data = file; 
				menuItem.addEventListener(Event.SELECT, selectRecentDocument); 
			} 
		} 
		
		private function selectRecentDocument(event:Event):void { 
			trace("Selected recent document: " + event.target.data.name); 
			
		} 
		
		public function projectPickerResult(msg:Object):void
		{
		 
			if (msg.result == true){
				trace("directory " + msg.directoryPath );
				trace("projectXMLpath " + msg.projectXMLpath);
			} else {
				trace("not a WIN Studio project")
			}
			
		}
		
		private function selectCommand(event:Event):void { 
			trace("Selected command: " + event.target.label); 
			
			var cmd:String = event.target.label;
			
			switch (cmd) {
				case Menu_CMD.OPEN :
					projectPicker.selectProjectDirectory();

					break;
				
				case Menu_CMD.OPEN_RECENT :
					// need to do a check when this is called that project exists
					break;
				
				default :
					trace("cmd " + cmd);
					msgObj.cmd = cmd;
					dispatchEvent(new Event(Event.SELECT,true));
					break;	
			}
		} 
		
		private function selectCommandMenu(event:Event):void { 
			if (event.currentTarget.parent != null) { 
				var menuItem:NativeMenuItem = 
					findItemForMenu(NativeMenu(event.currentTarget)); 
				if (menuItem != null) { 
					
					trace("Select event for \"" +  
						event.target.label +  
						"\" command handled by menu: " +  
						menuItem.label); 
				} 
			} else { 
				trace("Select event for \"" +  
					event.target.label +  
					"\" command handled by root menu."); 
			} 
		} 
		
		private function findItemForMenu(menu:NativeMenu):NativeMenuItem { 
			for each (var item:NativeMenuItem in menu.parent.items) { 
				if (item != null) { 
					if (item.submenu == menu) { 
						return item; 
					} 
				} 
			} 
			return null; 
		}
	}
}