<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
if (world instanceof Level _ext) {
	IFluidHandler _fluidHandler = getBlockCapability(_ext, ${toBlockPos(input$x,input$y,input$z)}, ${input$direction}, ForgeCapabilities.FLUID_HANDLER);
	if (_fluidHandler != null)
		_fluidHandler.drain(${opt.toInt(input$amount)}, IFluidHandler.FluidAction.EXECUTE);
}
<#-- @formatter:on -->