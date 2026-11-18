private static int getFluidTankLevel(LevelAccessor level, BlockPos pos, int tank, Direction direction) {
	if (level instanceof Level levelExtension) {
		IFluidHandler fluidHandler = getBlockCapability(levelExtension, pos, direction, ForgeCapabilities.FLUID_HANDLER);
		if (fluidHandler != null)
			return fluidHandler.getFluidInTank(tank).getAmount();
	}
	return 0;
}