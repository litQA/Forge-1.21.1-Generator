<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onExplode(ExplosionEvent.Detonate event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getExplosion().center().x()",
			"y": "event.getExplosion().center().y()",
			"z": "event.getExplosion().center().z()",
			"world": "event.getLevel()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}