@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.DEDICATED_SERVER) public class ${name}Procedure {
	static { MinecraftForge.EVENT_BUS.register(${name}Procedure.class); }
	@SubscribeEvent public static void init(FMLDedicatedServerSetupEvent event) {
		execute();
	}