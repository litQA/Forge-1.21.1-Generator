package ${package}.network;

import ${package}.${JavaModName};

import net.minecraft.client.Minecraft;
import net.minecraft.core.RegistryAccess;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.Level;

public final class ClientNetworkHelper {

	private ClientNetworkHelper() {
	}

	public static void sendToServer(CustomPacketPayload payload) {
		${JavaModName}.sendToServer(payload, registryAccess());
	}

	public static RegistryAccess registryAccess() {
		Level level = Minecraft.getInstance().level;
		return level != null ? level.registryAccess() : RegistryAccess.EMPTY;
	}

	public static Player player() {
		return Minecraft.getInstance().player;
	}

}
