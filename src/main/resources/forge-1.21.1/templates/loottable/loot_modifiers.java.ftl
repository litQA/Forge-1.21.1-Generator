package ${package}.loot;

import com.mojang.serialization.MapCodec;
import com.mojang.serialization.codecs.RecordCodecBuilder;

import it.unimi.dsi.fastutil.objects.ObjectArrayList;

import net.minecraft.core.registries.Registries;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.MinecraftServer;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.storage.loot.LootContext;
import net.minecraft.world.level.storage.loot.LootTable;
import net.minecraft.world.level.storage.loot.predicates.LootItemCondition;
import net.minecraftforge.common.loot.IGlobalLootModifier;
import net.minecraftforge.common.loot.LootModifier;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

import ${package}.${JavaModName};

public final class ${JavaModName}LootModifiers {

	public static final DeferredRegister<MapCodec<? extends IGlobalLootModifier>> REGISTRY = DeferredRegister
			.create(ForgeRegistries.GLOBAL_LOOT_MODIFIER_SERIALIZERS.getKey(), ${JavaModName}.MODID);

	public static final RegistryObject<MapCodec<? extends IGlobalLootModifier>> ADD_TABLE = REGISTRY
			.register("add_table", () -> AddTable.CODEC);

	public static final class AddTable extends LootModifier {
		public static final MapCodec<AddTable> CODEC = RecordCodecBuilder.mapCodec(instance -> codecStart(instance)
				.and(ResourceLocation.CODEC.fieldOf("table").forGetter(modifier -> modifier.table))
				.apply(instance, AddTable::new));

		private final ResourceLocation table;

		protected AddTable(LootItemCondition[] conditions, ResourceLocation table) {
			super(conditions);
			this.table = table;
		}

		@Override protected ObjectArrayList<ItemStack> doApply(ObjectArrayList<ItemStack> generatedLoot, LootContext context) {
			MinecraftServer server = context.getLevel().getServer();
			LootTable lootTable = server.reloadableRegistries()
					.getLootTable(ResourceKey.create(Registries.LOOT_TABLE, this.table));
			lootTable.getRandomItems(context, generatedLoot::add);
			return generatedLoot;
		}

		@Override public MapCodec<? extends IGlobalLootModifier> codec() {
			return CODEC;
		}
	}
}
