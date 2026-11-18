<#include "mcelements.ftl">
<#-- @formatter:off -->
if (world instanceof Level _ext && getBlockCapability(_ext, ${toBlockPos(input$x,input$y,input$z)}, null, ForgeCapabilities.ITEM_HANDLER) instanceof IItemHandlerModifiable _itemHandlerModifiable)
	_itemHandlerModifiable.setStackInSlot(${opt.toInt(input$slotid)}, ItemStack.EMPTY);
<#-- @formatter:on -->