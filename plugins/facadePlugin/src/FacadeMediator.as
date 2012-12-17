package
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class FacadeMediator extends Mediator
	{
		public function FacadeMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
	}
}