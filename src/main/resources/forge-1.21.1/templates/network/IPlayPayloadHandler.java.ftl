package ${package}.network;

/**
 * Handles one decoded payload type.
 */
@FunctionalInterface
public interface IPlayPayloadHandler<T> {

	void handle(T payload, IPayloadContext context);

}
