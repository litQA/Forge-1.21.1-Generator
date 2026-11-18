<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onVillageSiege(VillageSiegeEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getAttemptedSpawnPos().x",
			"y": "event.getAttemptedSpawnPos().y",
			"z": "event.getAttemptedSpawnPos().z",
			"world": "event.getLevel()",
			"entity": "event.getPlayer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}