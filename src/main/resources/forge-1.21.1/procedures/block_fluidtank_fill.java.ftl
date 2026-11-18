<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
if (world instanceof Level _ext) {
	IFluidHandler _fluidHandler = getBlockCapability(_ext, ${toBlockPos(input$x,input$y,input$z)}, ${input$direction}, ForgeCapabilities.FLUID_HANDLER);
	if (_fluidHandler != null)
		_fluidHandler.fill(new FluidStack(${generator.map(field$fluid, "fluids")}, ${opt.toInt(input$amount)}), IFluidHandler.FluidAction.EXECUTE);
}
<#-- @formatter:on -->