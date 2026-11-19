# Modification Log

Build numbers are cumulative modification counts. The current value is stored in
`docs/BUILD-NUMBER.txt` and mirrored in `src/main/resources/plugin.json`.

| Build | Modification |
| --- | --- |
| 24 | Initialized the cumulative counter at the current development state and applied the Forge 1.21.1 compile fixes for fluids, item and armor client extensions, boats, tools, overlays, and biome source presets. |
| 25 | Corrected custom attribute holder conversion in entity modifier procedures and restored the authlib profile name accessor required by Minecraft 1.21.1. |
| 26 | Added the delivery changelog, migration report, final version metadata, and completed the Forge 1.21.1 compile-fix verification pass. |
| 27 | Switched generated client run JVM options to the ForgeGradle 7 `jvmArgs` launcher API so workspaces configure and build correctly. |
| 28 | Enabled ForgeGradle 7 source-set output merging so generated run configurations load the mod classes and resources from the same mod file. |
| 29 | Initialized custom fluid-type registration from the registry key and assigned generated event subscribers to their matching Forge event bus. |
| 30 | Fixed duplicate custom-payload dispatch by marking decoded messages handled, and added a guarded `LootModifierManager` fallback that loads global loot data when Forge's reload event does not initialize it. |
