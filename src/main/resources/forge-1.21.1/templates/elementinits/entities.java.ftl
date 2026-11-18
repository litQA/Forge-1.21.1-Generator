<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign hasLivingEntities = types.livingentities?has_content>
<#assign entitiesWithInventory = types.livingentities?filter(e -> e.guiBoundTo?has_content)>

<#if hasLivingEntities || entitiesWithInventory?size != 0>
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD)
</#if>
public class ${JavaModName}Entities {
	static { MinecraftForge.EVENT_BUS.register(${JavaModName}Entities.class); }

	public static final DeferredRegister<EntityType<?>> REGISTRY = DeferredRegister.create(ForgeRegistries.ENTITY_TYPES, ${JavaModName}.MODID);

	<#list entities as entity>
		<#if entity.getModElement().getTypeString() == "projectile">
			public static final RegistryObject<EntityType<${entity.getModElement().getName()}Entity>> ${entity.getModElement().getRegistryNameUpper()} =
				register("${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}Entity>
						of(${entity.getModElement().getName()}Entity::new, MobCategory.MISC)
						.setShouldReceiveVelocityUpdates(true).setTrackingRange(64).setUpdateInterval(1).sized(${entity.modelWidth}f, ${entity.modelHeight}f));
		<#elseif entity.getModElement().getTypeString() == "livingentity">
			public static final RegistryObject<EntityType<${entity.getModElement().getName()}Entity>> ${entity.getModElement().getRegistryNameUpper()} =
				register("${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}Entity>
						of(${entity.getModElement().getName()}Entity::new, ${entity.mobSpawningType})
							.setShouldReceiveVelocityUpdates(true).setTrackingRange(${entity.trackingRange}).setUpdateInterval(3)
							<#if entity.immuneToFire>.fireImmune()</#if>
							<#if entity.mobModelName == "Biped">.ridingOffset(-0.6f)</#if>
							.sized(${entity.modelWidth}f, ${entity.modelHeight}f)
						);
			<#if entity.hasCustomProjectile()>
			public static final RegistryObject<EntityType<${entity.getModElement().getName()}EntityProjectile>> ${entity.getModElement().getRegistryNameUpper()}_PROJECTILE =
				register("projectile_${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}EntityProjectile>
					of(${entity.getModElement().getName()}EntityProjectile::new, MobCategory.MISC).setShouldReceiveVelocityUpdates(true).setTrackingRange(64)
						.setUpdateInterval(1).sized(0.5f, 0.5f));
			</#if>
		</#if>
	</#list>

	// Start of user code block custom entities
	// End of user code block custom entities

	private static <T extends Entity> RegistryObject<EntityType<T>> register(String registryname, EntityType.Builder<T> entityTypeBuilder) {
		return REGISTRY.register(registryname, () -> (EntityType<T>) entityTypeBuilder.build(registryname));
	}

	<#if hasLivingEntities>
	@SubscribeEvent public static void init(SpawnPlacementRegisterEvent event) {
		<#list entities as entity>
			<#if entity.getModElement().getTypeString() == "livingentity">
				${entity.getModElement().getName()}Entity.init(event);
			</#if>
		</#list>
	}

	@SubscribeEvent public static void registerAttributes(EntityAttributeCreationEvent event) {
		<#list entities as entity>
			<#if entity.getModElement().getTypeString() == "livingentity">
				event.put(${entity.getModElement().getRegistryNameUpper()}.get(), ${entity.getModElement().getName()}Entity.createAttributes().build());
			</#if>
		</#list>
	}
	</#if>

}
<#-- @formatter:on -->