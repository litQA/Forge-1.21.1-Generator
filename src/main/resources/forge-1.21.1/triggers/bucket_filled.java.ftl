<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public class ${name}Procedure {
	@SubscribeEvent public static void onBucketFill(FillBucketEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntity().getX()",
			"y": "event.getEntity().getY()",
			"z": "event.getEntity().getZ()",
			"world": "event.getLevel()",
			"itemstack": "event.getFilledBucket()",
			"entity": "event.getEntity()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
