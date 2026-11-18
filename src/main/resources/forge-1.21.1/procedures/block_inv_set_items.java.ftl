<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
if (world instanceof Level _ext && getBlockCapability(_ext, ${toBlockPos(input$x,input$y,input$z)}, null, ForgeCapabilities.ITEM_HANDLER) instanceof IItemHandlerModifiable _itemHandlerModifiable) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	_itemHandlerModifiable.setStackInSlot(${opt.toInt(input$slotid)}, _setstack);
}
<#-- @formatter:on -->