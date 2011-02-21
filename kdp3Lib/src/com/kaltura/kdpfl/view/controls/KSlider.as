package com.kaltura.kdpfl.view.controls
{

import com.kaltura.kdpfl.component.IComponent;
import com.kaltura.kdpfl.util.KColorUtil;

import fl.controls.Slider;
import fl.controls.SliderDirection;
import fl.core.InvalidationType;

import flash.display.Sprite;
import flash.utils.getDefinitionByName;


public class KSlider extends Slider implements IComponent
{
	public var progress:Sprite;
	public var color1:Number = -1;
	public var color2:Number = -1;

	protected static var defaultStyles:Object =
	{
		thumbUpSkin: "Slider_thumbUp_default",
		thumbOverSkin : "Slider_thumbOver_default", 
		thumbDownSkin: "Slider_thumbDown_default",
		thumbDisabledSkin: "Slider_thumbDisabled_default",
		sliderTrackSkin: "Slider_track_default",
		sliderTrackDisabledSkin: "Slider_trackDisabled_default",
		progress: "Slider_progress_default",
		tickSkin: null,
		focusRectSkin:null,
		focusRectPadding:null
	}

	public static function getStyleDefinition():Object
	{ 
		return mergeStyles( defaultStyles, Slider.getStyleDefinition() );
	}
	
	public function KSlider()
	{
		super();
	}

	public function setSkin( skinName:String, setSkinSize:Boolean=false ):void
	{
		var styleType:String;
		var styleName:String;
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
		if( verifyStyle(name as String) )
			super.setStyle( type, name );
	}

	public function initialize():void {}
	
	override protected function setStyles():void
	{
		super.setStyles();
		
		// override thumb size to its upSkin size.
		// otherwise hardcoded to 13,13 in configUI		
		var thumbSkin:Sprite = Sprite( getDisplayObjectInstance( getStyleValue("thumbUpSkin") ));
		thumb.setSize( thumbSkin.width, thumbSkin.height );	
				
		// add support for progress bar		
		var oldProgress:Sprite = progress;
		progress = Sprite( getDisplayObjectInstance( getStyleValue("progress") ) );
		progress.width = 0;
		progress.mouseChildren = false;
		progress.mouseEnabled = false;
		addChildAt( progress, 1 );
		//color the progress bar
		if(oldProgress && color1!=-1)
			 KColorUtil.colorDisplayObject(oldProgress , color1);
		if(progress  && color1!=-1)
			 KColorUtil.colorDisplayObject(progress , color1);
		
		if( oldProgress!=null && oldProgress!=progress )
		{
		 	removeChild(oldProgress);
		}
		//color the track
		//consult Shlomit if we want 2 colors or only one
/* 		if(track && color2!=-1)
			 KColorUtil.colorDisplayObject(track , color2); */
	}
	
	override protected function configUI():void
	{
		super.configUI();
		thumb.useHandCursor = true;		
		track.useHandCursor = true;
	}
	
	override protected function draw():void
	{
		if (isInvalid(InvalidationType.STYLES))
		{ 
			setStyles();
			invalidate(InvalidationType.SIZE, false);
		}
		
		if (isInvalid(InvalidationType.SIZE))
		{
			// change so slider track height is equal to slider height
			// (not hardcoded to 4 as set in configUI)
			// this allows setting track height to track skin height 
			track.setSize( _width, _height );

			track.drawNow();
			
			thumb.drawNow();
		}
		positionThumb();
		super.draw();
	}
	
	override protected function positionThumb():void
	{
		super.positionThumb();
		
		thumb.y = track.height/2;
		if( _direction == SliderDirection.VERTICAL )
		{
			// setup so bottom = minimum / top = maximum 
			progress.x = thumb.x;
			progress.width = _width-thumb.x;
		}
		else
		{
			progress.x = 0;
			progress.width = thumb.x;
		}
	}	
	
	override public function get width():Number
	{
		if( direction==SliderDirection.VERTICAL )
			return( super.height );
		else
			return( super.width );
	}
	
	override public function get height():Number
	{
		if( direction==SliderDirection.VERTICAL )
			return( super.width );
		else
			return( super.height );
	}
	
}
}