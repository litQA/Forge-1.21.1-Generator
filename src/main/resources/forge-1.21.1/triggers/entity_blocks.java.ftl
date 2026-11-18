<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void whenEntityBlocksWithShield(ShieldBlockEvent event) {
		if (event!=null && event.getEntity()!=null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().getX()",
				"y": "event.getEntity().getY()",
				"z": "event.getEntity().getZ()",
				"world": "event.getEntity().level()",
				"entity": "event.getEntity()",
				"damagesource": "event.getDamageSource()",
				"sourceentity": "event.getDamageSource().getEntity()",
				"immediatesourceentity": "event.getDamageSource().getDirectEntity()",
				"originalblockedamount": "event.getOriginalBlockedDamage()",
				"blockedamount": "event.getBlockedDamage()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}