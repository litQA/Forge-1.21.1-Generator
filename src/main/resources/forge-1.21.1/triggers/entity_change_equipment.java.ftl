<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public class ${name}Procedure {
	@SubscribeEvent public static void whenEntityChangeEquipment(LivingEquipmentChangeEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().getX()",
				"y": "event.getEntity().getY()",
				"z": "event.getEntity().getZ()",
				"world": "event.getEntity().level()",
				"entity": "event.getEntity()",
				"equipmentslot": "event.getSlot().getFilterFlag()",
				"olditemstack": "event.getFrom()",
				"newitemstack": "event.getTo()",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
