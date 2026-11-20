<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE, value = Dist.CLIENT) public class ${name}Procedure {
	@SubscribeEvent public static void onLeftClick(PlayerInteractEvent.LeftClickEmpty event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getEntity()"
			}/>
		</#assign>
		${package}.${JavaModName}.sendToServer(new ${name}Message());
		execute(${dependenciesCode});
	}

	@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD)
	public record ${name}Message() implements CustomPacketPayload {
		public static final CustomPacketPayload.Type<${name}Message> TYPE = new CustomPacketPayload.Type<>(
				ResourceLocation.fromNamespaceAndPath(${package}.${JavaModName}.MODID, "procedure_${registryname}"));
		public static final StreamCodec<RegistryFriendlyByteBuf, ${name}Message> STREAM_CODEC = StreamCodec.unit(new ${name}Message());

		@Override public CustomPacketPayload.Type<? extends CustomPacketPayload> type() {
			return TYPE;
		}

		public static void handleData(final ${name}Message message, final IPayloadContext context) {
			if (context.flow() == PacketFlow.SERVERBOUND) {
				context.enqueueWork(() -> {
					if (!context.player().level().getChunkSource().hasChunk(
						SectionPos.blockToSectionCoord(context.player().getX()),
						SectionPos.blockToSectionCoord(context.player().getZ())
					)) return;
					<#assign dependenciesCode>
						<@procedureDependenciesCode dependencies, {
							"x": "context.player().getX()",
							"y": "context.player().getY()",
							"z": "context.player().getZ()",
							"world": "context.player().level()",
							"entity": "context.player()"
						}/>
					</#assign>
					execute(${dependenciesCode});
				}).exceptionally(e -> {
					context.connection().disconnect(Component.literal(e.getMessage()));
					return null;
				});
			}
		}

		@SubscribeEvent public static void registerMessage(FMLCommonSetupEvent event) {
			${package}.${JavaModName}.addNetworkMessage(${name}Message.TYPE, ${name}Message.STREAM_CODEC, ${name}Message::handleData);
		}
	}

