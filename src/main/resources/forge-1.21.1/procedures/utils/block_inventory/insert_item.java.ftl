private static int insertInBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, ItemStack itemstack, boolean simulate) {
	if (world instanceof Level ext) {
		IItemHandler itemHandler = getBlockCapability(ext, pos, null, ForgeCapabilities.ITEM_HANDLER);
		if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots()) {
			ItemStack inserted = itemstack.copy();
			inserted.setCount(amount);
			return itemHandler.insertItem(slotId, inserted, simulate).getCount();
		}
	}
	return itemstack.getCount();
}