<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onBlockPlace(BlockEvent.EntityPlaceEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPos().getX()",
			"y": "event.getPos().getY()",
			"z": "event.getPos().getZ()",
			"px": "event.getEntity().getX()",
			"py": "event.getEntity().getY()",
			"pz": "event.getEntity().getZ()",
			"world": "event.getLevel()",
			"entity": "event.getEntity()",
			"blockstate": "event.getState()",
			"placedagainst": "event.getPlacedAgainst()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}