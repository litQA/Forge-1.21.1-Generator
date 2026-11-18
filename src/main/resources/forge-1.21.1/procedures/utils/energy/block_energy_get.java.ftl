public static int getEnergyStored(LevelAccessor level, BlockPos pos, Direction direction) {
	if (level instanceof Level levelExtension) {
		IEnergyStorage energyStorage = getBlockCapability(levelExtension, pos, direction, ForgeCapabilities.ENERGY);
		if (energyStorage != null)
			return energyStorage.getEnergyStored();
	}
	return 0;
}