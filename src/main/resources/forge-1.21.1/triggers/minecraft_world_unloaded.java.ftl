<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public class ${name}Procedure {
	@SubscribeEvent public static void onWorldUnload(net.minecraftforge.event.level.LevelEvent.Unload event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"world": "event.getLevel()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}