private static boolean getBlockNBTLogic(LevelAccessor world, BlockPos pos, String tag) {
	BlockEntity blockEntity = world.getBlockEntity(pos);
	if (blockEntity != null)
		return ${package}.blockentitydata.BlockEntityData.get(world, pos).getBoolean(tag);
	return false;
}