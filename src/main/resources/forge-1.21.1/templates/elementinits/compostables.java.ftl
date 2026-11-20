<#-- @formatter:off -->

<#include "../mcitems.ftl">

package ${package}.init;

import net.minecraft.world.level.block.ComposterBlock;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}Compostables {
	static { net.minecraftforge.common.MinecraftForge.EVENT_BUS.register(${JavaModName}Compostables.class); }

	@SubscribeEvent public static void registerCompostables(FMLCommonSetupEvent event) {
		event.enqueueWork(() -> {
			<@javacompress>
			<#list itemextensions?filter(e -> e.compostLayerChance gt 0) as extension>
			ComposterBlock.COMPOSTABLES.put(${mappedMCItemToItem(extension.item)}, ${extension.compostLayerChance}f);
			</#list>
			</@javacompress>
		});
	}
}

