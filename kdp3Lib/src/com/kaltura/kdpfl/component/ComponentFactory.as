package com.kaltura.kdpfl.component
{
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	
	import flash.utils.getDefinitionByName;KButton;
	import com.kaltura.kdpfl.view.containers.KVBox;KVBox;
	import com.kaltura.kdpfl.view.containers.KHBox;KHBox;
	import com.kaltura.kdpfl.view.containers.KCanvas;KCanvas;
	import com.kaltura.kdpfl.view.containers.KTile;KTile;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;KMediaPlayer;
	import com.kaltura.kdpfl.view.controls.KScrubber;KScrubber;
	import com.kaltura.kdpfl.view.controls.KVolumeBar;KVolumeBar;
	import com.kaltura.kdpfl.view.controls.KTimer;KTimer;
	import com.kaltura.kdpfl.view.controls.KLabel;KLabel;
	import com.kaltura.kdpfl.view.controls.Screens;Screens;
	import com.kaltura.kdpfl.view.controls.Watermark;Watermark;
	import com.kaltura.kdpfl.view.media.KThumbnail;KThumbnail;
	import com.kaltura.kdpfl.view.controls.KFlavorComboBox;KFlavorComboBox;
	import fl.core.UIComponent;
	import com.kaltura.kdpfl.view.controls.KTextField;KTextField;
	import com.kaltura.kdpfl.view.controls.KTrace;


	////////////////////////////////////////////////////////
	/**
	 * The ComponentFactory class contains the mapping between the xml tag names used in the config.xml file
	 * and the classes constructed for them in the layout building process. 
	 * @author Hila
	 * 
	 */	
	public class ComponentFactory
	{
		/**
		 * Map object between the config.xml tag names and the KDP associated classes. 
		 */		
		public static var _componentMap : Object = 
		{
			Button:"com.kaltura.kdpfl.view.controls.KButton",
			VBox:"com.kaltura.kdpfl.view.containers.KVBox",
			HBox:"com.kaltura.kdpfl.view.containers.KHBox",
			Canvas:"com.kaltura.kdpfl.view.containers.KCanvas",
			Tile:"com.kaltura.kdpfl.view.containers.KTile",
			Video:"com.kaltura.kdpfl.view.media.KMediaPlayer",
			Scrubber:"com.kaltura.kdpfl.view.controls.KScrubber",
			VolumeBar:"com.kaltura.kdpfl.view.controls.KVolumeBar",
			Label:"com.kaltura.kdpfl.view.controls.KLabel",
			Timer:"com.kaltura.kdpfl.view.controls.KTimer",
			Screens:"com.kaltura.kdpfl.view.controls.Screens",
			Watermark:"com.kaltura.kdpfl.view.controls.Watermark",
			Image:"com.kaltura.kdpfl.view.media.KThumbnail",
			Spacer:"fl.core.UIComponent",
			FlavorCombo:"com.kaltura.kdpfl.view.controls.KFlavorComboBox",
			Text:"com.kaltura.kdpfl.view.controls.KTextField",
			ComboBox:"com.kaltura.kdpfl.view.controls.KComboBox"
		}
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ComponentFactory(){}
		
		
		/**
		 * Creates the components supported by the KDP 
		 * @param UIComponent type
		 * @return KDP UIComponent 
		 * 
		 */		
		public function getComponent(type:String):UIComponent
		{
			var uiComponent:UIComponent;
			
			if( _componentMap[type] != null )
			{
				try{
					//creating the class from the type sent in the signature
					var ClassReference:Class = getDefinitionByName( _componentMap[type] ) as Class;
				}
				catch(e:Error){
					KTrace.getInstance().log("ComponentFactory >> getComponent >> Error: class not found, " + _componentMap[type]);
				//	trace ("ComponentFactory >> getComponent >> Error: class not found");
					return null;
				}
				
				uiComponent = new ClassReference();	
			
				return uiComponent;
			}
			else
			{
				KTrace.getInstance().log("ComponentFactory >> getComponent >> Error: no class is mapped for this component name.");
			//	trace ("ComponentFactory >> getComponent >> Error: no class is mapped for this component name.");
			}
			
			return null;	
		}
	}
}