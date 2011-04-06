package
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.Annotation;
	import com.kaltura.kdpfl.view.AnnotationBoxMediator;
	import com.kaltura.kdpfl.view.AnnotationsBox;
	import com.kaltura.kdpfl.view.EditAnnotationForm;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.kaltura.kdpfl.view.strings.Notifications;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class annotationsPluginCode extends KVBox implements IPlugin
	{
		protected var _userMode : String;
		protected var _annotationsBox : AnnotationsBox;
		protected var _annotationsBoxMediator : AnnotationBoxMediator;
		protected var _annotationEditForm : EditAnnotationForm;
		protected var _showAnnotationsPlugin : Boolean = false;
		protected var _inEditMode : Boolean = false;
		protected var _inViewMode : Boolean = true;
		protected var _isReviewer : Boolean = false;
		protected var _titleText : String = AnnotationStrings.ANNOTATION_BOX_TITLE;
		protected var _messageText : String = "";
		
		public function annotationsPluginCode()
		{
			//TODO: implement function
			super();
			Security.allowDomain("*");
		}

		public function initializePlugin(facade:IFacade):void
		{
			_annotationsBox = new AnnotationsBox();
			_annotationEditForm = new EditAnnotationForm();
			_annotationsBoxMediator = new AnnotationBoxMediator(this);
			facade.registerMediator(_annotationsBoxMediator);
			addVisualComponents();
			
		}
		
		override public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		public function get annotationsBox():AnnotationsBox {return _annotationsBox;}
		public function get annotationEditForm():EditAnnotationForm {return _annotationEditForm;}
		
		[Bindable]
		public function get userMode():String {return _userMode;}
		public function set userMode(value:String):void
		{
			_userMode = value;
			Annotation.userMode = value;
			if (_userMode != AnnotationStrings.REVIEWER )
			{
				isReviewer = false;
				if (inEditMode)
				{
					_annotationsBoxMediator.sendNotification(Notifications.CANCEL_ANNOTATION);
					
				}
				annotationsBox.changeAnnotationsViewMode(AnnotationStrings.VIEW_MODE);
			}
			else
			{
				
				isReviewer = true;
				annotationsBox.changeAnnotationsViewMode(AnnotationStrings.VIEW_MODE);
			}
		}
		
		[Bindable]
		public function get isReviewer () : Boolean { return _isReviewer; }
		public function set isReviewer ( value : Boolean ) : void { _isReviewer = value;}
		
		[Bindable]
		public function get inViewMode():Boolean {return _inViewMode;}
		public function set inViewMode(value:Boolean):void {_inViewMode = value;}
		
		[Bindable]
		public function get inEditMode():Boolean {return _inEditMode;}
		public function set inEditMode(value:Boolean):void {_inEditMode = value;}
		
		[Bindable]
		public function get showAnnotationsPlugin():Boolean
		{
			return _showAnnotationsPlugin;
		}
		
		public function set showAnnotationsPlugin(value:Boolean):void
		{
			_showAnnotationsPlugin = value;
		}
		
		[Bindable]
		public function get titleText () : String
		{
			return _titleText;
		}
		
		public function set titleText (n_title : String) : void
		{
			_titleText = n_title;
		}
		
		[Bindable]
		public function get messageText () : String
		{
			return _messageText;
		}
		
		public function set messageText (message : String) : void
		{
			_messageText = message;
		}
		
		public function gotoEditMode (): void
		{
			inEditMode = true;
			inViewMode = false;
			annotationEditForm.visible = true;
			titleText = "<b>Compose Annotation</b>";
			messageText = "";
		}
		
		public function gotoViewMode () : void
		{
			inEditMode = false;
			inViewMode = true;
			annotationEditForm.visible = false;
			titleText = AnnotationStrings.ANNOTATION_BOX_TITLE;
		}
		
		private function addVisualComponents () : void
		{
			_annotationEditForm.visible = false;
			var boxesContainer : KCanvas = new KCanvas();
			KAstraAdvancedLayoutUtil.appendToLayout(boxesContainer, _annotationsBox,100, 100);
			KAstraAdvancedLayoutUtil.appendToLayout(boxesContainer, _annotationEditForm, 100, 100);
			KAstraAdvancedLayoutUtil.appendToLayout(this, boxesContainer, 100, 100);
			this.addEventListener( AnnotationStrings.INVALID_ANNOTATION_TEXT_EVENT, onInvalidAnnotationSaveAttempt );
			this.addEventListener( AnnotationStrings.INVALID_ANNOTATION_INTIME_EVENT, onInvalidAnnotationIntime );
			
		}
		
		private function onInvalidAnnotationSaveAttempt (e : Event) : void
		{
			messageText = AnnotationStrings.INVALID_ANNOTATION_TEXT_MESSAGE;
		}
		
		private function onInvalidAnnotationIntime (e : Event) : void
		{
			messageText = AnnotationStrings.INVALID_ANNOTATION_INTIME_MESSAGE;
		}

	}
}