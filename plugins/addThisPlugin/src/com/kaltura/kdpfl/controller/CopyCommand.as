package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.plugin.component.IForm;
	
	import flash.system.System;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class CopyCommand extends AbstractCommand  implements ICommand
	{
		public static const NAME:String	= "CopyCommand";
		
		protected var _copyContent:Object			= {};
			
		public function CopyCommand(f:IFacade)
		{
			super(f);
		}
		
		override public function execute(form:IForm):void{
			var success:Boolean	= false;
			
			_form			= form;
			if(assignContents()){
				System.setClipboard(_copyContent["text"]);
			}
			//loop through params seeking for the textfield to copy
		}
		
		//this parses through the params, finds the physical component and grabs the text
		protected function assignContents():Boolean{
			var success:Boolean		= false;
			try{
				for(var i:int= 0;i<_form.formComponents.length;i++){
					
					for (var key:String	in _form.formParams){
						if(_form.formComponents[i].name	== _form.formParams[key]){
							_copyContent[String(key).toLowerCase()]		= _form.formComponents[i].text;
						}

					}
				}
				success				= true;
			}catch(e:Error){
				trace("AddThis Error: CopyCommand - problem assigning form textfields to expected email properties.  Please ensure email properties are correctly define.");
				success				= false;
			}
			return success;
		}
	}
}