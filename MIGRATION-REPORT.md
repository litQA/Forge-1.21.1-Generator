# Forge 1.21.1 Generator Migration Report

## Baseline and Target

| Item | Value |
| --- | --- |
| Baseline generator | MCreator 2026.3.44621 NeoForge 1.21.1 generator |
| Baseline platform | NeoForge 21.1.265 |
| Target generator | `generator-forge-1.21.1` |
| Target platform | Minecraft Forge 52.1.21 |
| Target Minecraft | 1.21.1 |
| Target MCreator | 2026.3.44621 |
| Generator project Gradle | 9.9.1 |
| Generated project Gradle | 9.9.1 |
| Generated project Java | 21 |

The baseline generator is the official 2026.3 NeoForge 1.21.1 generator. The target generator keeps its mod-element coverage and 1.21.1 data pack resources, then replaces every NeoForge platform surface with the Forge 52.1.21 equivalent.

## Architecture

- `forge-1.21.1` is the only discoverable generator. It owns all mod-element definitions, platform templates, mappings, triggers, procedures, and workspace files.
- `forge-datapack-1.21.1` is an import-only resource tree. It has no `generator.yaml`, no definitions, and no workspace base, so it supplies recipes, loot tables, tags, dimensions, features, structures, advancements, damage types, enchantments, functions, and utility templates without becoming a second generator.
- The generated workspace uses ForgeGradle 7, Gradle 9.9.1, Java 21, `mods.toml`, `META-INF`, and the Forge `runClient` / `runServer` tasks.
- Forge mechanisms replace NeoForge mechanisms for registries, capabilities, networking, events, variables, biome modifiers, loot modifiers, client extensions, and data attachments.

## New-Features Applicability

The baseline MCreator version is 2026.3.44621 and the target MCreator version is the same. The interval defined by `new_features_from_2021.md` as "after baseline, through target" is therefore empty. A per-item blocking-feature table is not applicable for this migration.

The baseline 2026.3 feature surface is retained in full. All mod-element generation, trigger, procedure, variable, JSON, resource, import-organization, and code-provider phases pass in the integration harness.

## Platform Adaptation Table

| Area | Baseline mechanism | Target mechanism | Status |
| --- | --- | --- | --- |
| Mod entrypoint | NeoForge `@Mod` with `IEventBus` | Forge `@Mod` with `FMLJavaModLoadingContext` | Complete |
| Registries | `DeferredRegister.Blocks` / `DeferredRegister.Items` | `DeferredRegister` with `ForgeRegistries` | Complete |
| Registry values | `DeferredHolder` / `DeferredBlock` / `DeferredItem` | `RegistryObject` | Complete |
| Item and block capabilities | `RegisterCapabilitiesEvent` item registration | `initCapabilities` and `getCapability` overrides | Complete |
| Networking | `RegisterPayloadHandlersEvent` / `PayloadRegistrar` | `SimpleChannel` envelope and payload adapter | Complete |
| Event buses | NeoForge `@EventBusSubscriber` | Forge `@Mod.EventBusSubscriber` with both bus registrations | Complete |
| Player variables | `AttachmentType` | SavedData and UUID maps | Complete |
| Block entity data | `getPersistentData` | Per-level SavedData store | Complete |
| Fluids | `BaseFlowingFluid` | `ForgeFlowingFluid` | Complete |
| Client item and armor models | `RegisterClientExtensionsEvent` | `Item#initializeClient` / `IForgeItem` | Complete |
| Client fluid extensions | `RegisterClientExtensionsEvent` | `FluidType#initializeClient` | Complete |
| Mob effect extensions | `RegisterClientExtensionsEvent` | `MobEffect#initializeClient` | Complete |
| Biome modifiers | NeoForge biome modifier codecs | Forge codecs and private `any_features` / `any_spawns` serializers | Complete |
| Global loot modifiers | NeoForge `add_table` | Private Forge `add_table` serializer | Complete |
| Compostables | NeoForge data map | `ComposterBlock.COMPOSTABLES` population | Complete |
| Dungeon mobs | NeoForge data map | `DungeonHooks` population | Complete |
| Villager trades | NeoForge listing classes | Generated `VillagerTrades.ItemListing` implementation | Complete |
| Mixins | NeoForge mixin configuration | Forge-compatible mixin configuration with isolated package | Complete with optional refmap limitation |

## Destructive Changes

- Forge `IForgeBlock#getExpDrop` uses the six-argument `(BlockState, LevelReader, RandomSource, BlockPos, int, int)` form.
- Forge `IForgeItem#onEntitySwing` takes two arguments.
- Forge `ItemStack` does not expose the NeoForge attachment and component-wrapper API. Generated code uses Forge capabilities and `DataComponents`.
- Forge has no `RegisterClientExtensionsEvent`; client behavior is provided by `initializeClient` callbacks.
- Forge has no `EffectCure` type, no `ModifyDefaultComponentsEvent`, no `Boat.Type` extension, and no NeoForge `BlockEntityTypeAddBlocksEvent`.
- Forge `CriticalHitEvent` exposes only the damage modifier setter.
- Forge `RenderLevelStageEvent` exposes a `Matrix4f` pose and a float partial tick; the generated skybox renderer rebuilds a `PoseStack`.
- Forge `mods.toml` uses `mandatory` dependency entries and the `javafml` loader. The generated dependency range targets Forge `52.1.21` and Minecraft `1.21.1`.

## Validation

- The integration harness loaded the generator, created a workspace, generated every supported mod element variant, generated base resources and data pack files, organized imports, formatted Java, and resolved every code-provider request.
- The integration harness reported success for workspace setup, texture references, base generation, resource setup, sample elements, mod-element generation, pack maker tools, procedure triggers, procedure blocks, variables, JSON triggers, command arguments, feature blocks, enchantment effects, AI task blocks, regeneration, JSON verification, import organization, and code provider.
- Generated Java was checked against the Forge 52.1.21 source tree. The remaining offline javac diagnostics are attributable to the proxy classpath lacking Forge's `ItemStack` capability patch, Forge's item client callback, and Forge's client GUI event; each call site was verified against the 52.1.21 sources.
- A complete ForgeGradle build and dedicated-server launch could not run in this execution sandbox. ForgeGradle's AccessTransformer child process opens its output as read-only because the sandbox reports every Java path as non-writable. The failure occurs in the ForgeGradle task, before generated-source compilation.

## Known Limitations

- Custom boat variants use the vanilla oak boat type. Forge 1.21.1 has no public boat type extension point; custom boat tick procedures are applied to boats in the level.
- Honey cure metadata is omitted because Forge 1.21.1 has no `EffectCure`.
- Unbreakable tools remove the maximum damage component through a generated `components()` override.
- Forge's critical hit event does not expose sweep disabling or critical-hit disabling. Those event parameter mappings are unavailable.
- Custom raider types use Forge's runtime enum extension through reflection because the nested vanilla enum is package-private.
- Mixin configurations are optional and use `defaultRequire=0`. Refmaps are not generated by the offline workspace.
- The custom biome preset bridge uses reflection over the private preset provider field. It is runtime-guarded and falls back to the original provider on failure.
- Block entity persistent data is stored in a generator-owned SavedData map keyed by dimension and block position. It is not the NeoForge per-block-entity persistent data map.
- The execution sandbox blocks ForgeGradle AccessTransformer writes. A full build and client launch must be repeated in a normal writable environment.
