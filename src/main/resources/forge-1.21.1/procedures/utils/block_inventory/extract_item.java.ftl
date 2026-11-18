private static ItemStack extractFromBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, boolean simulate) {
	if (world instanceof Level ext) {
		IItemHandler itemHandler = getBlockCapability(ext, pos, null, ForgeCapabilities.ITEM_HANDLER);
		if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots()) {
			return itemHandler.extractItem(slotId, amount, simulate);
		}
	}
	return ItemStack.EMPTY;
}