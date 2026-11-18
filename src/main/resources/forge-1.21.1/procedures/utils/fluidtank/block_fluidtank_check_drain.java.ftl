private static int drainTankSimulate(LevelAccessor level, BlockPos pos, int amount, Direction direction) {
	if (level instanceof Level levelExtension) {
		IFluidHandler fluidHandler = getBlockCapability(levelExtension, pos, direction, ForgeCapabilities.FLUID_HANDLER);
		if (fluidHandler != null)
			return fluidHandler.drain(amount, IFluidHandler.FluidAction.SIMULATE).getAmount();
	}
	return 0;
}