<#include "procedures.java.ftl">
.executes(arguments -> {
    Level world = arguments.getSource().getUnsidedLevel();

    double x = arguments.getSource().getPosition().x();
    double y = arguments.getSource().getPosition().y();
    double z = arguments.getSource().getPosition().z();

    Entity entity = arguments.getSource().getEntity();
    if (entity == null && world instanceof ServerLevel _servLevel)
        entity = new net.minecraft.server.level.ServerPlayer(_servLevel.getServer(), _servLevel, new com.mojang.authlib.GameProfile(java.util.UUID.randomUUID(), "FakePlayer"), net.minecraft.server.level.ClientInformation.createDefault());

    Direction direction = Direction.DOWN;
    if (entity != null)
    	direction = entity.getDirection();

    <@procedureToCode name=procedure dependencies=dependencies/>
    return 0;
})