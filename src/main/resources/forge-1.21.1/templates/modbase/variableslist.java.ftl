<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import net.minecraft.core.HolderLookup;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.nbt.ListTag;
import net.minecraft.nbt.Tag;
import net.minecraft.network.RegistryFriendlyByteBuf;
import net.minecraft.network.chat.Component;
import net.minecraft.network.codec.StreamCodec;
import net.minecraft.network.protocol.PacketFlow;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.util.datafix.DataFixTypes;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.ServerLevelAccessor;
import net.minecraft.world.level.saveddata.SavedData;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.event.entity.player.PlayerEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;

@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			${JavaModName}.addNetworkMessage(SavedDataSyncMessage.TYPE, SavedDataSyncMessage.STREAM_CODEC, SavedDataSyncMessage::handleData);
		</#if>

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
			${JavaModName}.addNetworkMessage(PlayerVariablesSyncMessage.TYPE, PlayerVariablesSyncMessage.STREAM_CODEC, PlayerVariablesSyncMessage::handleData);
		</#if>
	}

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP") || w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public static class EventBusVariableHandlers {
		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		@SubscribeEvent public static void onPlayerLoggedInSyncPlayerVariables(PlayerEvent.PlayerLoggedInEvent event) {
			if (event.getEntity() instanceof ServerPlayer player)
				${JavaModName}.sendToPlayer(player, new PlayerVariablesSyncMessage(getPlayerVariables(player)));
		}

		@SubscribeEvent public static void onPlayerRespawnedSyncPlayerVariables(PlayerEvent.PlayerRespawnEvent event) {
			if (event.getEntity() instanceof ServerPlayer player)
				${JavaModName}.sendToPlayer(player, new PlayerVariablesSyncMessage(getPlayerVariables(player)));
		}

		@SubscribeEvent public static void onPlayerChangedDimensionSyncPlayerVariables(PlayerEvent.PlayerChangedDimensionEvent event) {
			if (event.getEntity() instanceof ServerPlayer player)
				${JavaModName}.sendToPlayer(player, new PlayerVariablesSyncMessage(getPlayerVariables(player)));
		}

		@SubscribeEvent public static void onPlayerTickUpdateSyncPlayerVariables(TickEvent.PlayerTickEvent event) {
			if (event.phase == TickEvent.Phase.END && event.player instanceof ServerPlayer player && getPlayerVariables(player)._syncDirty) {
				${JavaModName}.sendToPlayer(player, new PlayerVariablesSyncMessage(getPlayerVariables(player)));
				getPlayerVariables(player)._syncDirty = false;
			}
		}

		@SubscribeEvent public static void clonePlayer(PlayerEvent.Clone event) {
			PlayerVariables original = getPlayerVariables(event.getOriginal());
			PlayerVariables clone = PlayerVariablesStore.get(event.getEntity()).get(event.getEntity().getUUID());
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_PERSISTENT">
				clone.${var.getName()} = original.${var.getName()};
				</#if>
			</#list>
			if (!event.isWasDeath()) {
				<#list variables as var>
					<#if var.getScope().name() == "PLAYER_LIFETIME">
					clone.${var.getName()} = original.${var.getName()};
					</#if>
				</#list>
			}
			PlayerVariablesStore.get(event.getEntity()).put(event.getEntity().getUUID(), clone);
		}
		</#if>

		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
		@SubscribeEvent public static void onPlayerLoggedIn(PlayerEvent.PlayerLoggedInEvent event) {
			if (event.getEntity() instanceof ServerPlayer player) {
				SavedData mapdata = MapVariables.get(player.level());
				SavedData worlddata = WorldVariables.get(player.level());
				if (mapdata != null)
					${JavaModName}.sendToPlayer(player, new SavedDataSyncMessage(0, mapdata));
				if (worlddata != null)
					${JavaModName}.sendToPlayer(player, new SavedDataSyncMessage(1, worlddata));
			}
		}

		@SubscribeEvent public static void onPlayerChangedDimension(PlayerEvent.PlayerChangedDimensionEvent event) {
			if (event.getEntity() instanceof ServerPlayer player) {
				SavedData worlddata = WorldVariables.get(player.level());
				if (worlddata != null)
					${JavaModName}.sendToPlayer(player, new SavedDataSyncMessage(1, worlddata));
			}
		}

		@SubscribeEvent public static void onWorldTick(TickEvent.LevelTickEvent event) {
			if (event.phase == TickEvent.Phase.END && event.level instanceof ServerLevel level) {
				WorldVariables worldVariables = WorldVariables.get(level);
				if (worldVariables._syncDirty) {
					${JavaModName}.sendToDimension(level, new SavedDataSyncMessage(1, worldVariables));
					worldVariables._syncDirty = false;
				}

				MapVariables mapVariables = MapVariables.get(level);
				if (mapVariables._syncDirty) {
					${JavaModName}.sendToAll(new SavedDataSyncMessage(0, mapVariables));
					mapVariables._syncDirty = false;
				}
			}
		}
		</#if>
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public static WorldVariables load(CompoundTag tag, HolderLookup.Provider lookupProvider) {
			WorldVariables data = new WorldVariables();
			data.read(tag, lookupProvider);
			return data;
		}

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
			this._syncDirty = true;
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level) {
				return level.getDataStorage().computeIfAbsent(new SavedData.Factory<WorldVariables>(WorldVariables::new, WorldVariables::load, DataFixTypes.LEVEL), DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class MapVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public static MapVariables load(CompoundTag tag, HolderLookup.Provider lookupProvider) {
			MapVariables data = new MapVariables();
			data.read(tag, lookupProvider);
			return data;
		}

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
			_syncDirty = true;
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(LevelAccessor world) {
			if (world instanceof ServerLevelAccessor serverLevelAcc) {
				return serverLevelAcc.getLevel().getServer().getLevel(Level.OVERWORLD).getDataStorage()
						.computeIfAbsent(new SavedData.Factory<MapVariables>(MapVariables::new, MapVariables::load, DataFixTypes.LEVEL), DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class SavedDataSyncMessage implements CustomPacketPayload {

		private final int dataType;
		private final SavedData data;

		public static final CustomPacketPayload.Type<SavedDataSyncMessage> TYPE = new CustomPacketPayload.Type<>(ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "saved_data_sync"));

		public static final StreamCodec<RegistryFriendlyByteBuf, SavedDataSyncMessage> STREAM_CODEC = StreamCodec.of(SavedDataSyncMessage::encode, SavedDataSyncMessage::decode);

		public SavedDataSyncMessage(int dataType, SavedData data) {
			this.dataType = dataType;
			this.data = data;
		}

		static void encode(RegistryFriendlyByteBuf buffer, SavedDataSyncMessage message) {
			buffer.writeInt(message.dataType);
			if (message.data != null)
				buffer.writeNbt(message.data.save(new CompoundTag(), buffer.registryAccess()));
		}

		static SavedDataSyncMessage decode(RegistryFriendlyByteBuf buffer) {
			int dataType = buffer.readInt();
			CompoundTag nbt = buffer.readNbt();
			SavedData data = null;
			if (nbt != null) {
				if (dataType == 0) {
					MapVariables mapVariables = new MapVariables();
					mapVariables.read(nbt, buffer.registryAccess());
					data = mapVariables;
				} else {
					WorldVariables worldVariables = new WorldVariables();
					worldVariables.read(nbt, buffer.registryAccess());
					data = worldVariables;
				}
			}
			return new SavedDataSyncMessage(dataType, data);
		}

		@Override public CustomPacketPayload.Type<? extends CustomPacketPayload> type() {
			return TYPE;
		}

		public static void handleData(final SavedDataSyncMessage message, final IPayloadContext context) {
			if (context.flow() == PacketFlow.CLIENTBOUND && message.data != null) {
				context.enqueueWork(() -> {
					Player player = context.player();
					if (player == null)
						return;
					HolderLookup.Provider lookupProvider = player.registryAccess();
					CompoundTag nbt = message.data.save(new CompoundTag(), lookupProvider);
					if (message.dataType == 0)
						MapVariables.clientSide.read(nbt, lookupProvider);
					else
						WorldVariables.clientSide.read(nbt, lookupProvider);
				}).exceptionally(e -> {
					context.connection().disconnect(Component.literal(e.getMessage()));
					return null;
				});
			}
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	public static class PlayerVariables {

		private final UUID playerUUID;
		private final PlayerVariablesStore store;
		boolean _syncDirty = false;

		public PlayerVariables(UUID playerUUID, PlayerVariablesStore store) {
			this.playerUUID = playerUUID;
			this.store = store;
		}

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		public CompoundTag serializeNBT(HolderLookup.Provider lookupProvider) {
			CompoundTag nbt = new CompoundTag();
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void deserializeNBT(HolderLookup.Provider lookupProvider, CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

		public void markSyncDirty() {
			_syncDirty = true;
			if (store != null)
				store.setDirty();
		}
	}

	public static class PlayerVariablesStore extends SavedData {

		public static final String DATA_NAME = "${modid}_playervars";

		private final Map<UUID, PlayerVariables> values = new HashMap<>();

		public static PlayerVariablesStore load(CompoundTag tag, HolderLookup.Provider lookupProvider) {
			PlayerVariablesStore store = new PlayerVariablesStore();
			ListTag list = tag.getList("players", Tag.TAG_COMPOUND);
			for (int i = 0; i < list.size(); i++) {
				CompoundTag entry = list.getCompound(i);
				UUID uuid = entry.getUUID("uuid");
				PlayerVariables vars = new PlayerVariables(uuid, store);
				vars.deserializeNBT(lookupProvider, entry.getCompound("data"));
				store.values.put(uuid, vars);
			}
			return store;
		}

		@Override public CompoundTag save(CompoundTag tag, HolderLookup.Provider lookupProvider) {
			ListTag list = new ListTag();
			for (Map.Entry<UUID, PlayerVariables> entry : values.entrySet()) {
				CompoundTag item = new CompoundTag();
				item.putUUID("uuid", entry.getKey());
				item.put("data", entry.getValue().serializeNBT(lookupProvider));
				list.add(item);
			}
			tag.put("players", list);
			return tag;
		}

		public PlayerVariables get(UUID uuid) {
			return values.computeIfAbsent(uuid, id -> new PlayerVariables(id, this));
		}

		public void put(UUID uuid, PlayerVariables variables) {
			values.put(uuid, variables);
			setDirty();
		}

		public static PlayerVariablesStore get(ServerLevel level) {
			return level.getServer().getLevel(Level.OVERWORLD).getDataStorage()
					.computeIfAbsent(new SavedData.Factory<PlayerVariablesStore>(PlayerVariablesStore::new, PlayerVariablesStore::load, DataFixTypes.LEVEL), DATA_NAME);
		}

		public static PlayerVariablesStore get(ServerPlayer player) {
			return get(player.serverLevel());
		}

		public static PlayerVariablesStore get(Player player) {
			if (player instanceof ServerPlayer serverPlayer)
				return get(serverPlayer);
			throw new IllegalStateException("Player variables are only available on the server");
		}
	}

	public static PlayerVariables getPlayerVariables(Entity entity) {
		if (entity instanceof Player player)
			return getPlayerVariables(player);
		return new PlayerVariables(entity.getUUID(), null);
	}

	public static PlayerVariables getPlayerVariables(Player player) {
		if (player instanceof ServerPlayer serverPlayer)
			return PlayerVariablesStore.get(serverPlayer).get(player.getUUID());

		PlayerVariables client = CLIENT_PLAYER_VARIABLES.get(player.getUUID());
		if (client == null) {
			client = new PlayerVariables(player.getUUID(), null);
			CLIENT_PLAYER_VARIABLES.put(player.getUUID(), client);
		}
		return client;
	}

	private static final Map<UUID, PlayerVariables> CLIENT_PLAYER_VARIABLES = new HashMap<>();

	public record PlayerVariablesSyncMessage(PlayerVariables data) implements CustomPacketPayload {

		public static final CustomPacketPayload.Type<PlayerVariablesSyncMessage> TYPE = new CustomPacketPayload.Type<>(ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "player_variables_sync"));

		public static final StreamCodec<RegistryFriendlyByteBuf, PlayerVariablesSyncMessage> STREAM_CODEC = StreamCodec.of(
				(RegistryFriendlyByteBuf buffer, PlayerVariablesSyncMessage message) -> {
					buffer.writeUUID(message.data.playerUUID);
					buffer.writeNbt(message.data.serializeNBT(buffer.registryAccess()));
				},
				(RegistryFriendlyByteBuf buffer) -> {
					UUID uuid = buffer.readUUID();
					PlayerVariables data = new PlayerVariables(uuid, null);
					CompoundTag nbt = buffer.readNbt();
					if (nbt != null)
						data.deserializeNBT(buffer.registryAccess(), nbt);
					return new PlayerVariablesSyncMessage(data);
				}
		);

		@Override public CustomPacketPayload.Type<? extends CustomPacketPayload> type() {
			return TYPE;
		}

		public static void handleData(final PlayerVariablesSyncMessage message, final IPayloadContext context) {
			if (context.flow() == PacketFlow.CLIENTBOUND && message.data != null) {
				context.enqueueWork(() -> CLIENT_PLAYER_VARIABLES.put(message.data.playerUUID, message.data))
						.exceptionally(e -> {
							context.connection().disconnect(Component.literal(e.getMessage()));
							return null;
						});
			}
		}
	}
	</#if>
}
<#-- @formatter:on -->
