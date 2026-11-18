package ${package}.blockentitydata;

import java.util.HashMap;
import java.util.Map;

import net.minecraft.core.BlockPos;
import net.minecraft.core.HolderLookup;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.nbt.ListTag;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.util.datafix.DataFixTypes;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.saveddata.SavedData;

/**
 * Per-level persistent storage for procedure-accessible block entity data.
 */
public class BlockEntityData extends SavedData {

	private static final String DATA_NAME = "${modid}_block_entity_data";
	private final Map<Long, CompoundTag> data = new HashMap<>();

	public static BlockEntityData get(ServerLevel level) {
		return level.getDataStorage().computeIfAbsent(
				new SavedData.Factory<>(BlockEntityData::new, BlockEntityData::load, DataFixTypes.LEVEL), DATA_NAME);
	}

	public static CompoundTag get(LevelAccessor world, BlockPos pos) {
		if (world instanceof ServerLevel level) {
			return get(level).data.computeIfAbsent(pos.asLong(), key -> new CompoundTag());
		}
		return new CompoundTag();
	}

	public static void markDirty(LevelAccessor world) {
		if (world instanceof ServerLevel level) {
			get(level).setDirty();
		}
	}

	public static BlockEntityData load(CompoundTag tag, HolderLookup.Provider registries) {
		BlockEntityData storage = new BlockEntityData();
		ListTag entries = tag.getList("entries", CompoundTag.TAG_COMPOUND);
		for (int i = 0; i < entries.size(); i++) {
			CompoundTag entry = entries.getCompound(i);
			storage.data.put(entry.getLong("pos"), entry.getCompound("data"));
		}
		return storage;
	}

	@Override
	public CompoundTag save(CompoundTag tag, HolderLookup.Provider registries) {
		ListTag entries = new ListTag();
		data.forEach((pos, value) -> {
			CompoundTag entry = new CompoundTag();
			entry.putLong("pos", pos);
			entry.put("data", value.copy());
			entries.add(entry);
		});
		tag.put("entries", entries);
		return tag;
	}
}
