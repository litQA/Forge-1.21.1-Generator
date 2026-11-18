private static int getBlockTanks(LevelAccessor level, BlockPos pos, Direction direction) {
	if (level instanceof Level levelExtension) {
		IFluidHandler fluidHandler = getBlockCapability(levelExtension, pos, direction, ForgeCapabilities.FLUID_HANDLER);
		if (fluidHandler != null)
			return fluidHandler.getTanks();
	}
	return 0;
}