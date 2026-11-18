private static int getBlockInventorySlotCount(LevelAccessor world, BlockPos pos) {
	if (world instanceof Level ext) {
		IItemHandler itemHandler = getBlockCapability(ext, pos, null, ForgeCapabilities.ITEM_HANDLER);
		if (itemHandler != null)
			return itemHandler.getSlots();
	}
	return 0;
}