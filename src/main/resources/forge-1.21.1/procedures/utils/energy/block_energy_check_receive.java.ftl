private static int receiveEnergySimulate(LevelAccessor level, BlockPos pos, int amount, Direction direction) {
	if (level instanceof Level levelExtension) {
		IEnergyStorage energyStorage = getBlockCapability(levelExtension, pos, direction, ForgeCapabilities.ENERGY);
		if (energyStorage != null)
			return energyStorage.receiveEnergy(amount, true);
	}
	return 0;
}