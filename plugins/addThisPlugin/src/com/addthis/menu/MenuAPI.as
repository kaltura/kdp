package com.addthis.menu {
	import com.addthis.menu.services.Services;
	import com.addthis.menu.ui.controls.MenuBar;
	import com.addthis.menu.ui.util.Constants;
	import com.addthis.menu.util.Utils;
	import com.addthis.share.ShareAPI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

    /**
     * MenuAPI
     *
     * This class provides a Flash sharing menu implementation, that leverages the AddThis Sharing Endpoints.
     * 
     * See http://www.addthis.com/help/flash-examples for additional information
     */ 
    public class MenuAPI extends Sprite {

        //Menu drawing constants
        private var displayStyle:int = 1;
        private var rowCount:int;
        private var columnCount:int;
        private var menuWidth:int;
        private var menuHeight:int;
        private var servicesInRow:int;
        private var serviceButtonWidth:int;      
          
        //Share class instance for sharing
        private var addthisShare:ShareAPI;
        
        //Url to be shared
        public var shareUrl:String="";
        
        //Content to be shared- expecting embed
        public var shareParams:Object;
         
        /**
        * Constructor
        **/ 
		public function MenuAPI(){}
		
		/**
		* Drawing the menu according to the display style
		**/  
		public function display(profileID:String = '',rows:int = 1, display:int = 3):void{
			//Variables
			var servicesList:Array= Services.SHARING_LIST;
			var grid:MenuBar;
			var getAndShare:MenuBar;
			var i:int =0;
			var servicesCount:int;
			var yPosMult:int; 
			var j:int =0;
			var k:Number; 
			
			//Share service instance with username 
			addthisShare =new ShareAPI(profileID);
			
			//Updating rows and display styles
			rowCount = rows;
			displayStyle = display;
			
			//Populating menu drawing constants 
			serviceButtonWidth = getServiceButtonWidth(displayStyle); 
			servicesCount = Utils.getObjectCount(servicesList);
            columnCount = Utils.getUpperRoundedValue(servicesCount,rowCount);
			menuHeight = (columnCount * Constants.MENU_ROW_HEIGHT) + Constants.DOCK_HEIGHT + Constants.BOTTOM_SPACING;
            menuWidth = (!(rowCount == 1) || (displayStyle != 1 && displayStyle != 0))? rowCount * (serviceButtonWidth + Constants.MENU_SPACING) + Constants.MENU_LEFT_PADDING:serviceButtonWidth + Constants.MENU_SPACING + Constants.MINIMUM_GET_AND_SHARE_WIDTH + Constants.MENU_LEFT_PADDING;
            
            //Drawing menu background    	
			grid = new MenuBar(null);
			grid.drawRoundedRectangle(menuWidth,menuHeight,'menu');
			
			//Drawing Get & share header   
			getAndShare = new MenuBar(null);
			getAndShare.drawRoundedRectangle(menuWidth,Constants.DOCK_HEIGHT,'dock');
			getAndShare.setLabel("Share","dock");
			
			//Adding to stage
			addChild(grid);
			addChild(getAndShare); 
			
			//Close button
			var closeButton:MenuBar = new MenuBar(null);
            closeButton.setLabel("X");
			closeButton.addEventListener(MouseEvent.CLICK,closeMenu);
            closeButton.x = menuWidth - (Constants.CLOSE_BUTTON_WIDTH + 16 );
            addChild(closeButton);
            
            //Drawing according to display style		
			for(var item:int = 0; item < servicesList.length;item++)
			{
			   var serviceButton:MenuBar = new MenuBar(servicesList[item]);
	           switch(displayStyle){
		          case 1:
		             serviceButton.loadImage(servicesList[item].id,displayStyle);
		             break;
		          case 2:
		             serviceButton.setLabel(servicesList[item].displayName);
		             break;
		          case 3:
		             serviceButton.loadImage(servicesList[item].id,displayStyle);   
		             serviceButton.setLabel(servicesList[item].displayName,"comp");
		             break;
				  case 4:
				  	 serviceButton.setIcon(servicesList[item].id,displayStyle);   
				     serviceButton.setLabel(servicesList[item].displayName,"comp");
				     break;   
		          default:
		             serviceButton.loadImage(servicesList[item].id,displayStyle);
	           }
               
               //Row column handling
               k = i/rowCount;
               k.toString().indexOf(".") < 0 ? j = 0:null;
               yPosMult = i/rowCount;
               
               //Position handling 
               serviceButton.x = j !=0 ? Constants.SERVICE_BUTTON_LEFT_SPACING + (j * serviceButtonWidth) + (Constants.BUTTON_SPACING * j):Constants.SERVICE_BUTTON_LEFT_SPACING + (j * serviceButtonWidth);
               serviceButton.y = Constants.SERVICE_BUTTON_TOP_SPACING + yPosMult * Constants.MENU_ROW_HEIGHT;
               
               //Listners 
               serviceButton.addEventListener(MouseEvent.CLICK,clickedEvent);
               serviceButton.addEventListener(MouseEvent.MOUSE_OVER,mouseOverEvent);
               serviceButton.addEventListener(MouseEvent.MOUSE_OUT,mouseOutEvent);
               
               //Adding to stage
               addChild(serviceButton);
               
               //Increment handlers for row column
               i++;
               j++;
        	}
 		}
		
		/**
		* Handling click event of service buttons
		**/  
		private function clickedEvent(e:Event):void{
			e.currentTarget.id != "more" ? addthisShare.share(shareUrl,e.currentTarget.id,shareParams):addthisShare.share(shareUrl,'menu',shareParams);
		}
		
		/**
		* Handling mouse over event of service buttons
		**/  
		private function mouseOverEvent(e:Event):void{
			e.currentTarget.drawRoundedRectangle(menuWidth/rowCount,Constants.SERVICE_BUTTON_HEIGHT,'button','hover');
		}
		
		/**
		* Handling mouse out event of service buttons
		**/  
		private function mouseOutEvent(e:Event):void{
			e.currentTarget.drawRoundedRectangle(menuWidth/rowCount,Constants.SERVICE_BUTTON_HEIGHT,'button','normal');
		}
		
		/**
		* Closing menu
		**/  
		private function closeMenu(e:Event):void{
			if(this.parent){
			   parent.removeChild(this);
			}
		}
	
		/**
		* Gets the width of the service button to draw 
		* according to the user passed value or default value
		**/
		private function getServiceButtonWidth(style:int):int{
			switch(style){
				case 1:
					return Constants.SERVICE_BUTTON_ICON_WIDTH ;
					break;
				case 2:
				    return Constants.SERVICE_BUTTON_TEXT_WIDTH ;
				    break;
				case 3:
				    return Constants.SERVICE_BUTTON_ICON_AND_TEXT_WIDTH ;
				    break;
				default:
				    return Constants.SERVICE_BUTTON_ICON_WIDTH ;
				    break;    
			}        
		}
		
		/**
		* Configuring the content to be shared
		**/  
		public function configure(url:String,params:Object =null):void{
			shareUrl = url;
			shareParams = params;
		}
		
		/**
		* 	Getters and Setters
		*/		
		override public function get width():Number	{
			return menuWidth;
		} 
		override public function get height():Number {
			return menuHeight;
		}
	}
}