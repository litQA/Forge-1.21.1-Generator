package ${package}.world.biomemodifier;

import java.util.List;
import java.util.function.Function;

import com.mojang.datafixers.util.Either;
import com.mojang.serialization.Codec;
import com.mojang.serialization.MapCodec;
import com.mojang.serialization.codecs.RecordCodecBuilder;

import net.minecraft.core.Holder;
import net.minecraft.core.HolderSet;
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.level.biome.Biome;
import net.minecraft.world.level.biome.MobSpawnSettings.SpawnerData;
import net.minecraft.world.level.levelgen.GenerationStep.Decoration;
import net.minecraft.world.level.levelgen.placement.PlacedFeature;
import net.minecraftforge.common.world.BiomeModifier;
import net.minecraftforge.common.world.ModifiableBiomeInfo.BiomeInfo.Builder;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

import ${package}.${JavaModName};

public final class ${JavaModName}BiomeModifiers {

	public static final DeferredRegister<MapCodec<? extends BiomeModifier>> REGISTRY = DeferredRegister
			.create(ForgeRegistries.BIOME_MODIFIER_SERIALIZERS.getKey(), ${package}.${JavaModName}.MODID);

	public static final RegistryObject<MapCodec<? extends BiomeModifier>> ANY_FEATURES = REGISTRY
			.register("any_features", () -> AnyFeatures.CODEC);

	public static final RegistryObject<MapCodec<? extends BiomeModifier>> ANY_SPAWNS = REGISTRY
			.register("any_spawns", () -> AnySpawns.CODEC);

	public record AnyFeatures(HolderSet<PlacedFeature> features, Decoration step) implements BiomeModifier {
		public static final MapCodec<AnyFeatures> CODEC = RecordCodecBuilder.mapCodec(instance -> instance.group(
				PlacedFeature.LIST_CODEC.fieldOf("features").forGetter(AnyFeatures::features),
				Decoration.CODEC.fieldOf("step").forGetter(AnyFeatures::step)).apply(instance, AnyFeatures::new));

		@Override public void modify(Holder<Biome> biome, Phase phase, Builder builder) {
			if (phase == Phase.ADD)
				this.features.forEach(feature -> builder.getGenerationSettings().addFeature(this.step, feature));
		}

		@Override public MapCodec<? extends BiomeModifier> codec() {
			return CODEC;
		}
	}

	public record AnySpawns(List<SpawnerData> spawners) implements BiomeModifier {
		public static final MapCodec<AnySpawns> CODEC = RecordCodecBuilder.mapCodec(instance -> instance.group(
				Codec.either(SpawnerData.CODEC.listOf(), SpawnerData.CODEC).xmap(
						either -> either.map(Function.identity(), List::of),
						list -> list.size() == 1 ? Either.right(list.get(0)) : Either.left(list))
						.fieldOf("spawners").forGetter(AnySpawns::spawners))
				.apply(instance, AnySpawns::new));

		@Override public void modify(Holder<Biome> biome, Phase phase, Builder builder) {
			if (phase == Phase.ADD) {
				for (SpawnerData spawner : this.spawners)
					builder.getMobSpawnSettings().addSpawn(spawner.type.getCategory(), spawner);
			}
		}

		@Override public MapCodec<? extends BiomeModifier> codec() {
			return CODEC;
		}
	}
}

