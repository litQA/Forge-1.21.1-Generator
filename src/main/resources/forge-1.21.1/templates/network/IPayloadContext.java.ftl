package ${package}.network;

import java.util.concurrent.CompletableFuture;

import net.minecraft.network.Connection;
import net.minecraft.network.protocol.PacketFlow;
import net.minecraft.world.entity.player.Player;

/**
 * Side-independent context passed to generated payload handlers.
 */
public interface IPayloadContext {

	PacketFlow flow();

	CompletableFuture<Void> enqueueWork(Runnable runnable);

	Player player();

	Connection connection();

}
