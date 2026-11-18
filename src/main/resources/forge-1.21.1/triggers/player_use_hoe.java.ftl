<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void onUseHoe(BlockEvent.BlockToolModificationEvent event) {
		if (!event.isSimulated() && event.getToolAction() == ToolActions.HOE_TILL && event.getPlayer() != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "event.getContext().getClickedPos().getX()",
				"y": "event.getContext().getClickedPos().getY()",
				"z": "event.getContext().getClickedPos().getZ()",
				"world": "event.getContext().getLevel()",
				"entity": "event.getPlayer()",
				"blockstate": "event.getContext().getLevel().getBlockState(event.getContext().getClickedPos())",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}