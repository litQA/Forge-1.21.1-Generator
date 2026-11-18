private static int getBlockInventorySlotStackLimit(LevelAccessor world, BlockPos pos, int slotId) {
	if (world instanceof Level ext) {
		IItemHandler itemHandler = getBlockCapability(ext, pos, null, ForgeCapabilities.ITEM_HANDLER);
		if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots())
			return itemHandler.getSlotLimit(slotId);
	}
	return 0;
}