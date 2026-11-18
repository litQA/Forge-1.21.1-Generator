<#include "mcelements.ftl">
<#-- @formatter:off -->
if (world instanceof Level _ext) {
	IEnergyStorage _entityStorage = getBlockCapability(_ext, ${toBlockPos(input$x,input$y,input$z)}, ${input$direction}, ForgeCapabilities.ENERGY);
	if (_entityStorage != null)
		_entityStorage.extractEnergy(${opt.toInt(input$amount)}, false);
}
<#-- @formatter:on -->