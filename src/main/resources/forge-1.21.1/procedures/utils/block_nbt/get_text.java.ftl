private static String getBlockNBTString(LevelAccessor world, BlockPos pos, String tag) {
	BlockEntity blockEntity = world.getBlockEntity(pos);
	if (blockEntity != null)
		return ${package}.blockentitydata.BlockEntityData.get(world, pos).getString(tag);
	return "";
}