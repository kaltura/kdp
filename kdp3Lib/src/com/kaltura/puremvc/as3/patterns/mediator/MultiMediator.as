package com.kaltura.puremvc.as3.patterns.mediator
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * when there are multi Mediators to multi components we need to retrive them by a new name
	 * so we will use the Multi mediator to  
	 * @author Boaz
	 * 
	 */	
	public class MultiMediator extends Mediator
	{
		private static var nameIndex:int = 0;
		public static var NAME:String = "MultiMediator";
		public function MultiMediator( viewComponent:Object=null )
		{
			super(NAME + (++nameIndex).toString() , viewComponent);
		}
	}
}