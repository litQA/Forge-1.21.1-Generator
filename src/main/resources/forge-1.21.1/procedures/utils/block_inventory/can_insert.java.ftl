public static boolean canInsertInBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, ItemStack itemstack) {
	if (world instanceof Level ext) {
		IItemHandler itemHandler = getBlockCapability(ext, pos, null, ForgeCapabilities.ITEM_HANDLER);
		if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots()) {
			itemstack.setCount(amount);
			return itemHandler.isItemValid(slotId, itemstack);
		}
	}
	return false;
}