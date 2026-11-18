<#include "mcelements.ftl">
<#-- @formatter:off -->
if (world instanceof Level _ext && getBlockCapability(_ext, ${toBlockPos(input$x,input$y,input$z)}, null, ForgeCapabilities.ITEM_HANDLER) instanceof IItemHandlerModifiable _itemHandlerModifiable) {
	int _slotid = ${opt.toInt(input$slotid)};
	ItemStack _stk = _itemHandlerModifiable.getStackInSlot(_slotid).copy();
	_stk.shrink(${opt.toInt(input$amount)});
	_itemHandlerModifiable.setStackInSlot(_slotid, _stk);
}
<#-- @formatter:on -->