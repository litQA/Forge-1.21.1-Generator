<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public class ${name}Procedure {
	@SubscribeEvent public static void onEntityAttacked(LivingHurtEvent event) {
		if (event!=null && event.getEntity()!=null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().getX()",
				"y": "event.getEntity().getY()",
				"z": "event.getEntity().getZ()",
				"amount": "event.getAmount()",
				"world": "event.getEntity().level()",
				"entity": "event.getEntity()",
				"damagesource": "event.getSource()",
				"sourceentity": "event.getSource().getEntity()",
				"immediatesourceentity": "event.getSource().getDirectEntity()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
