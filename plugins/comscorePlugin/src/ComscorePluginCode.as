package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.view.ComscoreMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class ComscorePluginCode extends Sprite implements IPlugin
	{
		protected var _comscoreMediator : ComscoreMediator;
		
		protected var _c1 : String;
		protected var _c2 : String;
		protected var _c3 : String;
		protected var _c4 : String;
		protected var _c5 : String;
		protected var _c6 : String;
		protected var _c10 : String;
		protected var _comscoreVersion : String = "2.0";
		
		public function ComscorePluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_comscoreMediator = new ComscoreMediator(null, this);
			facade.registerMediator(_comscoreMediator);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		[Bindable]
		public function get c1():String
		{
			return _c1;
		}

		public function set c1(value:String):void
		{
			_c1 = value;
		}
		[Bindable]
		public function get c2():String
		{
			return _c2;
		}

		public function set c2(value:String):void
		{
			_c2 = value;
		}
		[Bindable]
		public function get c3():String
		{
			return _c3;
		}

		public function set c3(value:String):void
		{
			_c3 = value;
		}
		[Bindable]
		public function get c4():String
		{
			return _c4;
		}

		public function set c4(value:String):void
		{
			_c4 = value;
		}
		[Bindable]
		public function get c5():String
		{
			return _c5;
		}

		public function set c5(value:String):void
		{
			_c5 = value;
		}
		[Bindable]
		public function get c6():String
		{
			return _c6;
		}

		public function set c6(value:String):void
		{
			_c6 = value;
		}
		[Bindable]
		public function get c10():String
		{
			return _c10;
		}

		public function set c10(value:String):void
		{
			_c10 = value;
		}

		public function get comscoreVersion():String
		{
			return _comscoreVersion;
		}

		public function set comscoreVersion(value:String):void
		{
			_comscoreVersion = value;
		}


	}
}