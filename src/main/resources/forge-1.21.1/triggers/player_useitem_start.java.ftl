<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public class ${name}Procedure {
	@SubscribeEvent public static void onUseItemStart(LivingEntityUseItemEvent.Start event) {
		if (event != null && event.getEntity() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().getX()",
				"y": "event.getEntity().getY()",
				"z": "event.getEntity().getZ()",
				"itemstack": "event.getItem()",
				"duration": "event.getDuration()",
				"world": "event.getEntity().level()",
				"entity": "event.getEntity()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
