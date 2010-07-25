package 
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.TabBarKdp3;
	import com.kaltura.kdpfl.plugin.component.TabBarKdp3Mediator;
	import com.kaltura.kdpfl.style.TextFormatManager;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class tabBarCodePlugin extends UIComponent implements IPlugin
	{
		private var _tabBarKdp3Mediator : TabBarKdp3Mediator;
		private var _dataProvider:DataProvider;
		private var _selectedDataProvider:DataProvider;
		public var rightArrowLabel:String;
		public var rightArrowStyleName:String;
		public var rightArrowIcon:String;
		public var rightArrowUpIcon:String;
		public var rightArrowDownIcon:String;
		public var rightArrowDisabledIcon:String;
		public var rightArrowSelectedIcon:String;
		public var rightArrowSelectedUpIcon:String;
		public var rightArrowSelectedDownIcon:String;
		public var rightArrowSelectedDisabledIcon:String;
		public var leftArrowLabel:String;
		public var leftArrowStyleName:String;
		public var leftArrowIcon:String;
		public var leftArrowUpIcon:String;
		public var leftArrowDownIcon:String;
		public var leftArrowDisabledIcon:String;
		public var leftArrowSelectedIcon:String;
		public var leftArrowSelectedUpIcon:String;
		public var leftArrowSelectedDownIcon:String;
		public var leftArrowSelectedDisabledIcon:String;
		public var font:String;
		public var color1:String;
		public var color2:String;
		public var color3:String;
		public var color4:String;
		public var color5:String;
		public var buttonType:String;
		public var color2Selected:String = "false";

		/**
		 * 
		 * Constructor 
		 * 
		 */		
		public function tabBarCodePlugin()
		{
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			// Register Mideator
			_tabBarKdp3Mediator = new TabBarKdp3Mediator( new TabBarKdp3() );
			
			if (_dataProvider != null)
			{
				(_tabBarKdp3Mediator.view as TabBarKdp3).initialize(_dataProvider);
			}
 			var tb:TabBarKdp3 = _tabBarKdp3Mediator.view as TabBarKdp3;
		
			if(rightArrowStyleName)
			{
				tb.nextBut.setSkin(rightArrowStyleName); 
			} 
			if(rightArrowIcon)
			{
				tb.nextBut.setStyle("icon",rightArrowIcon); 
			} 
			if(rightArrowUpIcon)
			{
				tb.nextBut.setStyle("upIcon",rightArrowUpIcon); 
			} 
			if(rightArrowDownIcon)
			{
				tb.nextBut.setStyle("downIcon",rightArrowDownIcon); 
			} 
			if(rightArrowDisabledIcon)
			{
				tb.nextBut.setStyle("disabledIcon",rightArrowDisabledIcon); 
			} 

			if(leftArrowStyleName)
			{
				tb.prevBut.setSkin(leftArrowStyleName); 
			} 
			if(leftArrowIcon)
			{
				tb.prevBut.setStyle("icon",leftArrowIcon); 
			} 
			if(leftArrowUpIcon)
			{
				tb.prevBut.setStyle("upIcon",leftArrowUpIcon); 
			} 
			if(leftArrowDownIcon)
			{
				tb.prevBut.setStyle("downIcon",leftArrowDownIcon); 
			} 
			if(leftArrowDisabledIcon)
			{
				tb.prevBut.setStyle("disabledIcon",leftArrowDisabledIcon); 
			} 
			if(buttonType)
			{
				tb.nextBut.buttonType =  buttonType;
				tb.prevBut.buttonType =  buttonType;
			}
				
			facade.registerMediator( _tabBarKdp3Mediator);
			addChild( _tabBarKdp3Mediator.view );
			//hack to redraw the tabBar. if this was synced colors would not be renderered well 
			setTimeout(setLabelsStyle,100);
		}
		
		private function setLabelsStyle():void
		{
			var tb:TabBarKdp3 = _tabBarKdp3Mediator.view as TabBarKdp3;
			// labels
			var tf:TextFormat = TextFormatManager.getInstance().getTextFormat("tabBarLabel");
			var tfSelected:TextFormat = TextFormatManager.getInstance().getTextFormat("tabBarLabelSelected");
			var hasSelectedDefinition:Boolean = true;
			try{
				//this skin has a selected tab definition 
				//if this skin does not have a selected tab definition it will inharits from the 
				//regular on and will be bolded
				var tfSelectedClass:Class = getDefinitionByName("tabBarLabelSelected") as Class;
			} catch (e:Error)
			{
				hasSelectedDefinition = false;
			}
			if(!hasSelectedDefinition)
				tfSelected.bold = true; 
		 	//override colors if they were defined 
			if(color1)
			{
				tfSelected.color = Number(color1);
				tb.nextBut.color1 =  Number(color1);
				tb.prevBut.color1 =  Number(color1);
			}
			if(color2)
			{
				// appstudio players should not apply color2 to selected
				if( color2Selected == "true")
					tf.color = Number(color2);
				tb.nextBut.color2 =  Number(color2);
				tb.prevBut.color2 =  Number(color2);
			}
			//override font if it was set on the XML tag
			if(font)
			{
				tf.font = font;
				tfSelected.font = font;
			}
			
			tb.tabBar.setStyle("textFormat",tf);
			tb.tabBar.setStyle("selectedTextFormat",tfSelected);
		}

		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		} 

		override public function set width(value:Number):void
		{
			(_tabBarKdp3Mediator.view as TabBarKdp3).width = value;;
		}	
		public function set padding(value:Number):void
		{
			(_tabBarKdp3Mediator.view as TabBarKdp3).padding = value;;
		}	
		
		
		override public function set height(value:Number):void
		{
		}					
	
		[Bindable]
		public function set dataProvider( value:DataProvider ):void
		{
			
			_dataProvider = value;
			if (_tabBarKdp3Mediator != null)
			{
				(_tabBarKdp3Mediator.view as TabBarKdp3).initialize(_dataProvider);
			}
		}
		
		
		public function get dataProvider():DataProvider
		{
			return( _dataProvider );
		}	
	
		[Bindable]
		public function set selectedDataProvider( value:DataProvider ):void
		{
			_selectedDataProvider = value;
		}
		
		public function get selectedDataProvider():DataProvider
		{
			return( _selectedDataProvider );
		}	

	}
}
