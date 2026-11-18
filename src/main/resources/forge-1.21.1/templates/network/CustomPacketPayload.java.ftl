package ${package}.network;

import net.minecraft.resources.ResourceLocation;

/**
 * Minimal payload contract shared by all generated network messages.
 */
public interface CustomPacketPayload {

	Type<? extends CustomPacketPayload> type();

	record Type<T extends CustomPacketPayload>(ResourceLocation id) {
	}

}
