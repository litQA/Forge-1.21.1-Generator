private static ItemStack getItemStackFromItemStackSlot(int slotID, ItemStack itemStack) {
	IItemHandler itemHandler = itemStack.getCapability(ForgeCapabilities.ITEM_HANDLER).orElse(null);
	if (itemHandler != null)
		return itemHandler.getStackInSlot(slotID).copy();
	return ItemStack.EMPTY;
}