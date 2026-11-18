<#include "mcitems.ftl">
if (${input$entity}.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null) instanceof IItemHandlerModifiable _modHandlerEntSetSlot) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	_modHandlerEntSetSlot.setStackInSlot(${opt.toInt(input$slotid)}, _setstack);
}