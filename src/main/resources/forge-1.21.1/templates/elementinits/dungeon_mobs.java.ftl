<#-- @formatter:off -->

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.minecraftforge.common.DungeonHooks;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;

@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}DungeonMobs {
	static { net.minecraftforge.common.MinecraftForge.EVENT_BUS.register(${JavaModName}DungeonMobs.class); }

	@SubscribeEvent public static void registerDungeonMobs(FMLCommonSetupEvent event) {
		event.enqueueWork(() -> {
			<@javacompress>
			<#list livingentities?filter(e -> e.spawnInDungeons) as livingentity>
			DungeonHooks.addDungeonMob(${JavaModName}Entities.${livingentity.getModElement().getRegistryNameUpper()}.get(), 100);
			</#list>
			</@javacompress>
		});
	}
}
