package
{
	import caurina.transitions.Tweener;
	
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.util.DateTimeUtils;
	import com.kaltura.kdpfl.view.controls.ToolTipManager;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import fl.controls.BaseButton;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.media.MediaPlayer;
	import org.puremvc.as3.interfaces.IFacade;
	
	public class AnimatedScrubberThumbCode extends UIComponent implements IPlugin
	{
		public var color1:uint;
		
		private var _mediator:AnimatedScrubberThumbMediator;
		
		private var _thumb:BaseButton;
		
		private var _thumbDown:Boolean	= false;
		
		public var duration:Number	= -1;
		
		public var yOffset:Number	= 6;
		public var xOffset:Number	= 0;
		
		public var intialThumbYPos:Number	= 20;
		
		[Bindable]
		public function set position(val:Point):void{
			_thumb.x		= globalToLocal(val).x+xOffset;
			_thumb.y		= globalToLocal(val).y+yOffset;
		}
		
		public function get position():Point{
			return new Point(_thumb.x, _thumb.y);
		}
		
		public function AnimatedScrubberThumbCode()
		{
			super();
		}
		
		public var track:UIComponent;
		
		private var _newPosition:Number;
		
		[Bindable]
		public function set newPosition(pt:Number):void{
			_newPosition	= pt;
		}
		
		public function get newPosition():Number{
			return _newPosition;
		}
		
		private var _f:IFacade;
		
		/**
		 * @private
		 */
		protected static var defaultStyles:Object =
			{
				thumbUpSkin: "Scrubber_thumbUp_default",
				thumbOverSkin: "Scrubber_thumbOver_default",
				thumbDownSkin: "Scrubber_thumbDown_default",
				thumbDisabledSkin: "Scrubber_thumbDisabled_default",
				focusRectSkin:null,
				focusRectPadding:null		
			};			
		
		public function initializePlugin(facade:IFacade):void
		{
			_f				= facade;
			_mediator		= new AnimatedScrubberThumbMediator("animatedScrubberThumbMediator", this);
			facade.registerMediator(_mediator);
			
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			_thumb = new BaseButton();
			_thumb.addEventListener(MouseEvent.MOUSE_OVER,scrubButtonMouseOver);
			_thumb.addEventListener(MouseEvent.MOUSE_OUT,scrubButtonMouseOut);
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN,scrubButtonMouseDown);
			_thumb.addEventListener(MouseEvent.MOUSE_UP,scrubButtonMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, scrubButtonMouseUp);
			
			addChild( _thumb );
			
			var ClassThumbOver:Class	= getDefinitionByName("Scrubber_thumbOver") as Class;
			var ClassThumbDown:Class	= getDefinitionByName("Scrubber_thumbDown") as Class;
			var ClassThumbDisabled:Class= getDefinitionByName("Scrubber_thumbDisabled") as Class;
			var ClassThumbUp:Class		= getDefinitionByName("Scrubber_thumbUp") as Class;
			
			var thumbClasses:Array		= [ClassThumbDown,ClassThumbDisabled,ClassThumbUp,ClassThumbOver];
			var thumbSkins:Array			= new Array();
			var updatedThumbStyles:Object	= new Object();
			
			for(var i:int=0;i<thumbClasses.length;i++){
				var mc:MovieClip		= new thumbClasses[i]() as MovieClip;
				updateColors(mc);
				switch(thumbClasses[i]){
					case ClassThumbDown:
						_thumb.setStyle("downSkin",mc);
						break;
					case ClassThumbOver: 
						_thumb.setStyle("overSkin",mc);
						break;
					case ClassThumbDisabled:
						_thumb.setStyle("disabledSkin",mc);
						break;
					case ClassThumbUp:
						_thumb.setStyle("upSkin",mc);
						_thumb.setSize( mc.width, mc.height );
						break;
					
				}
			}
			if(tooltip == "00:00")//indicates tooltip that gets updated with time at mouse x position.
				this.addEventListener(MouseEvent.MOUSE_MOVE,onToolTip);
			
		}
		
		
		private function onToolTip(e:MouseEvent):void{
			var relativePercentage:Number	= (track.mouseX/track.width);
			var localTime:Number			= Math.ceil(relativePercentage*duration);
			ToolTipManager.getInstance().follow	= true;
			ToolTipManager.getInstance().updateTitle(DateTimeUtils.formatTime(localTime));
		}
		
		
		protected function scrubButtonMouseOver(event:MouseEvent):void{
			Tweener.addTween(event.target, {width:35, height:35, time:.25, transition:"easeOutQuart"});
		}
		
		protected function scrubButtonMouseOut(event:MouseEvent):void{
			Tweener.addTween(event.target, {width:30, height:30, time:.25, transition:"easeOutQuart"});
		}
		
		protected function scrubButtonMouseDown(event:MouseEvent):void{
			_thumbDown	= true;
			//_thumb.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, scrubButtonMouseUp, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			
			
		}
		
		protected function onMouseMove(event:MouseEvent = null):void{
			
			var globalTrackPt:Point	= track.localToGlobal(new Point(track.x, track.y));
			var rightWall:Number	= globalTrackPt.x+track.width;
			if(mouseX > rightWall+10)
				_thumb.x	= rightWall;
			else if(mouseX < globalTrackPt.x)
				_thumb.x	= globalTrackPt.x;
			else
				_thumb.x	= mouseX;

			var localTrackPt:Point	= 	track.globalToLocal(new Point(_thumb.x, _thumb.y));

			var p:Number			= 	localTrackPt.x / track.width;
			
			var newSeekTime:Number	= duration * p;
			
			newPosition				= localTrackPt.x;
			
		} 
		
		public function playbackComplete():void{
			var globalTrackPt:Point	= track.localToGlobal(new Point(track.x, track.y));
			var rightWall:Number	= globalTrackPt.x+track.width;
			_thumb.x	= rightWall;
			
			var localTrackPt:Point	= 	track.globalToLocal(new Point(_thumb.x, _thumb.y));
			
			var p:Number			= 	localTrackPt.x / track.width;
			
			var newSeekTime:Number	= duration;
			
		//	newPosition				= newSeekTime;
			
		}
		
		protected function scrubButtonMouseUp(event:MouseEvent):void{
			if(!_thumbDown)
				return; 
			else
				_thumbDown	= false;
			
			onMouseMove();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//_thumb.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		
		private function updateColors(arg0:MovieClip):void{
			for(var i:int=0;i<arg0.numChildren;i++){
				if(arg0.getChildAt(i) is MovieClip){
					if((arg0.getChildAt(i) as MovieClip).numChildren > 0)
						updateColors(arg0.getChildAt(i) as MovieClip);
				}
				
				if(arg0.getChildAt(i).name.indexOf("dynamicColor") > -1){
					var ct:ColorTransform	= arg0.getChildAt(i).transform.colorTransform;
					ct.color	= color1;
					arg0.getChildAt(i).transform.colorTransform	= ct;
				}
			}
		}
	}
}