<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onEntityTamed(AnimalTameEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getAnimal().getX()",
			"y": "event.getAnimal().getY()",
			"z": "event.getAnimal().getZ()",
			"world": "event.getAnimal().level()",
			"entity": "event.getAnimal()",
			"sourceentity": "event.getTamer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}