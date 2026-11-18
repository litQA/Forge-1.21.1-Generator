package ${package}.network;

import java.util.concurrent.CompletableFuture;

import net.minecraft.network.Connection;
import net.minecraft.network.protocol.PacketFlow;
import net.minecraft.world.entity.player.Player;
import net.minecraftforge.event.network.CustomPayloadEvent;

/**
 * Adapts Forge's custom payload event context to the generator network contract.
 */
public final class ForgePayloadContext implements IPayloadContext {

	private final CustomPayloadEvent.Context context;

	public ForgePayloadContext(CustomPayloadEvent.Context context) {
		this.context = context;
	}

	@Override public PacketFlow flow() {
		return context.getConnection().getReceiving();
	}

	@Override public CompletableFuture<Void> enqueueWork(Runnable runnable) {
		return context.enqueueWork(runnable);
	}

	@Override public Player player() {
		if (context.getSender() != null)
			return context.getSender();
		return ClientNetworkHelper.player();
	}

	@Override public Connection connection() {
		return context.getConnection();
	}

}
