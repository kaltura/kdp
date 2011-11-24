package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.plugin.component.IForm;

	public interface ICommand
	{
		function execute(form:IForm):void;
	}
}