package com.kaltura.kdpfl.plugin.component
{

import com.kaltura.kdpfl.component.IComponent;

import fl.controls.List;
import fl.controls.SelectableList;
import fl.core.InvalidationType;
import fl.events.ComponentEvent;

import flash.utils.getDefinitionByName;


public class KList extends List implements IComponent
{

	private var _itemContentFactory:Function; 
	private var _itemContentLayout:XML; 
	
	public function KList()
	{
		super();
	}
	
	public function initialize():void
	{	
	}
		
	public function setSkin( skinName:String, setSkinSize:Boolean=false ):void
	{
		var styleType:String;
		var styleName:String;
		
//		_setSkinSize = setSkinSize;
		
		for( var current:String in defaultStyles )
		{
			if( defaultStyles[current] is String && verifyStyle(defaultStyles[current]) )
			{
				styleType = getStyleType( defaultStyles[current] );
				styleName = styleType + "_" + skinName;
				setStyle( current, styleName );
			}
			// else case of Number values like style sliderVerticalGap
			// or skin not verified (possibly display object class not loaded to mem)
		}
	}

	/**
     * @private
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	protected static var defaultStyles:Object = 
	{
		skin: "List_background_default",
		trackUpSkin: "List_scrollTrack_default",
		trackOverSkin: "List_scrollTrack_default",
		trackDownSkin: "List_scrollTrack_default",
		trackDisabledSkin: "List_scrollTrack_default",
		thumbUpSkin: "List_scrollThumbUp_default",
		thumbOverSkin: "List_scrollThumbOver_default",
		thumbDownSkin: "List_scrollThumbDown_default",
		thumbDisabledSkin: "List_scrollThumbUp_default",
		thumbIcon: "List_scrollThumbIcon_default",
		upArrowUpSkin: "List_scrollUpArrowUp_default",
		upArrowOverSkin: "List_scrollUpArrowOver_default",
		upArrowDownSkin: "List_scrollUpArrowDown_default",
		upArrowDisabledSkin: "List_scrollUpArrowDisabled_default",
		downArrowUpSkin: "List_scrollDownArrowUp_default",
		downArrowOverSkin: "List_scrollDownArrowOver_default",
		downArrowDownSkin: "List_scrollDownArrowDown_default",
		downArrowDisabledSkin: "List_scrollDownArrowDisabled_default",
		repeatDelay: 500,
		disabledAlpha: 0.5,
		repeatInterval: 35,
		focusRectSkin: null,
		focusRectPadding: null,
		contentPadding: 0		
	};
	
    /**
     * @copy fl.core.UIComponent#getStyleDefinition()
     *
	 * @includeExample ../core/examples/UIComponent.getStyleDefinition.1.as -noswf
	 *
     * @see fl.core.UIComponent#getStyle()
     * @see fl.core.UIComponent#setStyle()
     * @see fl.managers.StyleManager
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	public static function getStyleDefinition():Object
	{ 
		return mergeStyles(defaultStyles, SelectableList.getStyleDefinition());
	}

	private function getStyleType( styleName:String ):String
	{
		var type:String = styleName = styleName.slice( 0, styleName.lastIndexOf('_') );
		return( type );
	}
	
	private function verifyStyle( name:String ):Boolean
	{
		try
		{
			var styleClass:Class = getDefinitionByName(name) as Class;
		}
		catch( e:Error )
		{
			// TODO return warning of style not found
			return( false );
		}
		return( true );
	}
	
	override public function setStyle( type:String, name:Object ):void
	{
		if( name is Class || verifyStyle(name as String) )
			super.setStyle( type, name );
	}	
	
	public function set itemContentFactory( f:Function ):void
	{
	    clearRendererStyle("contentFactory");
		_itemContentFactory = f;
		setRendererStyle( "contentFactory", f );
	}

	public function set itemContentLayout( layout:XML ):void
	{
		clearRendererStyle("contentLayout");
		_itemContentLayout = layout;
		setRendererStyle( "contentLayout", layout );
	}
	
	// fix bug that list doesnt resize height on fullscreen (or probably any change height)
	override public function set height( value:Number ):void
	{
		super.height = value;	
		this.invalidateList();
	}
	
}
}