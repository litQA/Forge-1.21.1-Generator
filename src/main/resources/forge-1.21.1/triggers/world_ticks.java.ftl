<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onWorldTick(TickEvent.LevelTickEvent event) {
		if (event.phase==TickEvent.Phase.END) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"world": "event.level",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}