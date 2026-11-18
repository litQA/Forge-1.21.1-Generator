private static ItemStack itemFromBlockInventory(LevelAccessor world, BlockPos pos, int slot) {
	if (world instanceof Level ext) {
		IItemHandler itemHandler = getBlockCapability(ext, pos, null, ForgeCapabilities.ITEM_HANDLER);
		if (itemHandler != null)
			return itemHandler.getStackInSlot(slot);
	}
	return ItemStack.EMPTY;
}