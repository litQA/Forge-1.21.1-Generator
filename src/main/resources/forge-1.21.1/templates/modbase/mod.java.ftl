<#-- @formatter:off -->
package ${package};

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

import io.netty.buffer.Unpooled;
import it.unimi.dsi.fastutil.ints.IntObjectImmutablePair;
import it.unimi.dsi.fastutil.ints.IntObjectPair;
import net.minecraft.core.RegistryAccess;
import net.minecraft.network.FriendlyByteBuf;
import net.minecraft.network.RegistryFriendlyByteBuf;
import net.minecraft.network.codec.StreamCodec;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.TickTask;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.level.Level;
import net.minecraftforge.api.distmarker.Dist;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.event.network.CustomPayloadEvent;
import net.minecraftforge.eventbus.api.EventPriority;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.DistExecutor;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.fml.util.thread.SidedThreadGroups;
import net.minecraftforge.network.ChannelBuilder;
import net.minecraftforge.network.PacketDistributor;
import net.minecraftforge.network.SimpleChannel;
import net.minecraftforge.server.ServerLifecycleHooks;

import ${package}.network.ClientNetworkHelper;
import ${package}.network.CustomPacketPayload;
import ${package}.network.ForgePayloadContext;
import ${package}.network.IPayloadContext;
import ${package}.network.IPlayPayloadHandler;
import ${package}.loot.${JavaModName}LootModifiers;
import ${package}.world.biomemodifier.${JavaModName}BiomeModifiers;

@Mod("${modid}") public class ${JavaModName} {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	public ${JavaModName}() {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		IEventBus modEventBus = FMLJavaModLoadingContext.get().getModEventBus();
		MinecraftForge.EVENT_BUS.register(this);

		modEventBus.addListener(EventPriority.LOWEST, this::registerNetworking);

		<@javacompress>
		<#if w.hasSounds()>${JavaModName}Sounds.REGISTRY.register(modEventBus);</#if>
		<#if types.base_blocks?has_content>${JavaModName}Blocks.REGISTRY.register(modEventBus);</#if>
		<#if types.base_blockentities?has_content>${JavaModName}BlockEntities.REGISTRY.register(modEventBus);</#if>
		<#if types.base_items?has_content>${JavaModName}Items.REGISTRY.register(modEventBus);</#if>
		<#if types.base_entities?has_content>${JavaModName}Entities.REGISTRY.register(modEventBus);</#if>
		<#if w.hasItemsInTabs()>${JavaModName}Tabs.REGISTRY.register(modEventBus);</#if>
		<#if types.base_features?has_content>${JavaModName}Features.REGISTRY.register(modEventBus);</#if>
		<#if types.features?filter(e -> e.getModElement().getMetadata("has_nbt_structure")??)?size != 0>StructureFeature.REGISTRY.register(modEventBus);</#if>
		<#if types.potions?has_content>${JavaModName}Potions.REGISTRY.register(modEventBus);</#if>
		<#if types.potioneffects?has_content>${JavaModName}MobEffects.REGISTRY.register(modEventBus);</#if>
		<#if types.guis?has_content>${JavaModName}Menus.REGISTRY.register(modEventBus);</#if>
		<#if types.particles?has_content>${JavaModName}ParticleTypes.REGISTRY.register(modEventBus);</#if>
		<#if types.villagerprofessions?has_content>${JavaModName}VillagerProfessions.PROFESSIONS.register(modEventBus);</#if>
		<#if types.fluids?has_content>
			${JavaModName}Fluids.REGISTRY.register(modEventBus);
			${JavaModName}FluidTypes.REGISTRY.register(modEventBus);
		</#if>
		<#if types.attributes?has_content>${JavaModName}Attributes.REGISTRY.register(modEventBus);</#if>
		${JavaModName}BiomeModifiers.REGISTRY.register(modEventBus);
		${JavaModName}LootModifiers.REGISTRY.register(modEventBus);
		</@javacompress>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods

	<#-- Networking support below -->
	private static boolean networkingRegistered = false;
	private static final Map<ResourceLocation, NetworkMessage<?>> MESSAGES = new HashMap<>();

	private static final SimpleChannel NETWORK = ChannelBuilder.named(ResourceLocation.fromNamespaceAndPath(MODID, "main"))
			.networkProtocolVersion(1).simpleChannel();

	private record NetworkMessage<T extends CustomPacketPayload>(StreamCodec<RegistryFriendlyByteBuf, T> reader, IPlayPayloadHandler<T> handler) {}

	public record NetworkEnvelope(ResourceLocation id, byte[] data) {

		public static void encode(NetworkEnvelope message, FriendlyByteBuf buffer) {
			buffer.writeResourceLocation(message.id());
			buffer.writeByteArray(message.data());
		}

		public static NetworkEnvelope decode(FriendlyByteBuf buffer) {
			return new NetworkEnvelope(buffer.readResourceLocation(), buffer.readByteArray());
		}

		public void handle(CustomPayloadEvent.Context context) {
			NetworkMessage<?> message = MESSAGES.get(id());
			if (message == null)
				return;
			RegistryAccess registryAccess = context.getSender() != null ? context.getSender().serverLevel().registryAccess() : ClientNetworkHelper.registryAccess();
			RegistryFriendlyByteBuf buffer = new RegistryFriendlyByteBuf(Unpooled.wrappedBuffer(data()), registryAccess);
			dispatch(message, buffer, new ForgePayloadContext(context));
		}

	}

	public static <T extends CustomPacketPayload> void addNetworkMessage(CustomPacketPayload.Type<T> id, StreamCodec<RegistryFriendlyByteBuf, T> reader, IPlayPayloadHandler<T> handler) {
		if (networkingRegistered)
			throw new IllegalStateException("Cannot register new network messages after networking has been registered");
		MESSAGES.put(id.id(), new NetworkMessage<>(reader, handler));
	}

	@SuppressWarnings({"rawtypes", "unchecked"})
	private static void dispatch(NetworkMessage<?> message, RegistryFriendlyByteBuf buffer, IPayloadContext context) {
		NetworkMessage raw = message;
		raw.handler().handle(raw.reader().decode(buffer), context);
	}

	@SuppressWarnings({"rawtypes", "unchecked"})
	private static NetworkEnvelope envelope(CustomPacketPayload payload, RegistryAccess registryAccess) {
		NetworkMessage message = MESSAGES.get(payload.type().id());
		if (message == null)
			throw new IllegalArgumentException("Unknown network message: " + payload.type().id());
		RegistryFriendlyByteBuf buffer = new RegistryFriendlyByteBuf(Unpooled.buffer(), registryAccess);
		message.reader().encode(buffer, payload);
		byte[] data = new byte[buffer.readableBytes()];
		buffer.readBytes(data);
		return new NetworkEnvelope(payload.type().id(), data);
	}

	private void registerNetworking(final FMLCommonSetupEvent event) {
		if (networkingRegistered)
			return;
		NETWORK.messageBuilder(NetworkEnvelope.class, 0)
				.encoder(NetworkEnvelope::encode)
				.decoder(NetworkEnvelope::decode)
				.consumer(NetworkEnvelope::handle)
				.add();
		networkingRegistered = true;
	}

	private static void ensureNetworkInitialized() {
		if (!networkingRegistered)
			throw new IllegalStateException("Networking has not been initialized yet");
	}

	public static void sendToPlayer(ServerPlayer player, CustomPacketPayload payload) {
		ensureNetworkInitialized();
		NETWORK.send(envelope(payload, player.serverLevel().registryAccess()), PacketDistributor.PLAYER.with(player));
	}

	public static void sendToServer(CustomPacketPayload payload) {
		ensureNetworkInitialized();
		DistExecutor.unsafeRunWhenOn(Dist.CLIENT, () -> () -> ClientNetworkHelper.sendToServer(payload));
	}

	public static void sendToServer(CustomPacketPayload payload, RegistryAccess registryAccess) {
		ensureNetworkInitialized();
		NETWORK.send(envelope(payload, registryAccess), PacketDistributor.SERVER.noArg());
	}

	public static void sendToAll(CustomPacketPayload payload) {
		ensureNetworkInitialized();
		var server = ServerLifecycleHooks.getCurrentServer();
		RegistryAccess registryAccess = server != null ? server.overworld().registryAccess() : RegistryAccess.EMPTY;
		NETWORK.send(envelope(payload, registryAccess), PacketDistributor.ALL.noArg());
	}

	public static void sendToDimension(Level level, CustomPacketPayload payload) {
		ensureNetworkInitialized();
		NETWORK.send(envelope(payload, level.registryAccess()), PacketDistributor.DIMENSION.with(level.dimension()));
	}

	<#-- Wait procedure block support below -->
	private static final Queue<IntObjectPair<Runnable>> workToBeScheduled = new ConcurrentLinkedQueue<>();
	private static final PriorityQueue<TickTask> workQueue = new PriorityQueue<>(Comparator.comparingInt(TickTask::getTick));

	public static void queueServerWork(int delay, Runnable action) {
		if (Thread.currentThread().getThreadGroup() == SidedThreadGroups.SERVER)
			workToBeScheduled.add(new IntObjectImmutablePair<>(delay, action));
	}

	@SubscribeEvent public void tick(TickEvent.ServerTickEvent event) {
		if (event.phase != TickEvent.Phase.END)
			return;

		int currentTick = event.getServer().getTickCount();

		IntObjectPair<Runnable> work;
		while ((work = workToBeScheduled.poll()) != null) {
			workQueue.add(new TickTask(currentTick + work.leftInt(), work.right()));
		}

		while (!workQueue.isEmpty() && currentTick >= workQueue.peek().getTick()) {
			workQueue.poll().run();
		}
	}

}
<#-- @formatter:on -->
