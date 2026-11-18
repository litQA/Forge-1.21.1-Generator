private static int fillTankSimulate(LevelAccessor level, BlockPos pos, int amount, Direction direction, Fluid fluid) {
	if (level instanceof Level levelExtension) {
		IFluidHandler fluidHandler = getBlockCapability(levelExtension, pos, direction, ForgeCapabilities.FLUID_HANDLER);
		if (fluidHandler != null)
			return fluidHandler.fill(new FluidStack(fluid, amount), IFluidHandler.FluidAction.SIMULATE);
	}
	return 0;
}