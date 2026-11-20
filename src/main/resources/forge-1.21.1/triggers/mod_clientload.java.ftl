@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void init(FMLClientSetupEvent event) {
		execute();
	}
