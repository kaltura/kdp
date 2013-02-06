package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.yahoo.astra.layout.modes.VerticalAlignment;

	import flash.display.Sprite;
	import flash.net.getClassByAlias;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	import org.puremvc.as3.interfaces.IFacade;

	public class ageConsentPlugin extends KHBox implements IPlugin, IPluginFactory
	{
		public var stringToAgeConsent:String = "FSK ab [age] freigegeben";
		public var nonAgeConsent:String = "keine Altersfreigabe verfügbar";
		public var textStyle:String = "onScreenDisneyDescription";
		public var font:String ;
		public var fontSize:Number ;
		public var bold:Boolean ;
		public var notRatedString:String="not rated";
		public var noAgeConsentString:String="No Age Consent";
		private var _ar:AssetsRefferencer;

		private var _textfield:TextField;

		[Bindable]
		public var showConsentMessage:Boolean;

		private var icon:Sprite;

		public function ageConsentPlugin()
		{

		}

		/**
		 * @inheritDoc
		 **/
		public function create(pluginName:String = null):IPlugin
		{
			return this;
		}
		/**
		 * set the given style to all visual parts
		 **/
		override public function setSkin(styleName:String, setSkinSize:Boolean = false):void
		{
		}

		public function initializePlugin(facade:IFacade):void
		{
			verticalAlign = VerticalAlignment.MIDDLE;
			var ageConsentMediator:AgeConsentMediator = new AgeConsentMediator(this);
			facade.registerMediator(ageConsentMediator);
			//get the style from the skin
			var ClassMask:Class	= getDefinitionByName(textStyle) as Class;
			var spr:Sprite	= new ClassMask as Sprite;
			var tf:TextFormat = (spr.getChildAt(0) as TextField).getTextFormat();;
			//tf.bold = true;
			if(font)
				tf.font = font;
			if(fontSize)
				tf.size = fontSize;

			if(bold)
				tf.bold = bold;

			trace("[ageConsent] - initializePlugin");
			_textfield = new TextField();
			_textfield.autoSize = "left";
			_textfield.selectable = false;
			_textfield.defaultTextFormat = tf;
			addChild(_textfield);
		}
		public function clean():void
		{
			if(icon)
				removeChild(icon);
			icon = null;
			showConsentMessage = false;
			_textfield.text = "";
		}
		public function show(obj:Object):void
		{
			if(obj && obj.hasOwnProperty("AgeConsent"))
			{
				var value:String = obj["AgeConsent"];
				if(value == "notRatedString")
				{
					//not rated
					showConsentMessage = true;
					_textfield.text = nonAgeConsent;
					addChild(_textfield)
				} else if (value && value != noAgeConsentString)
				{
					//rated
					showConsentMessage = true;
					_textfield.text = stringToAgeConsent.split("[age]").join(value);

					var ClassMask:Class	= getDefinitionByName("fsk"+value) as Class;
					icon	= new ClassMask as Sprite;
					addChild(icon);
					addChild(_textfield)
				} else
				{
					clean();
				}
			}else
			{
				//missing value
				if(icon)
					removeChild(icon)
				showConsentMessage = false;
				_textfield.text = "";
			}
		}

	}
}