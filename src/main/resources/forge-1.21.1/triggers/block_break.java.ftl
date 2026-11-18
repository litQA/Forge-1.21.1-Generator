<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onBlockBreak(BlockEvent.BreakEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"px": "event.getPlayer() != null ? event.getPlayer().getX() : event.getPos().getX()",
				"py": "event.getPlayer() != null ? event.getPlayer().getY() : event.getPos().getY()",
				"pz": "event.getPlayer() != null ? event.getPlayer().getZ() : event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getPlayer()",
				"blockstate": "event.getState()"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}