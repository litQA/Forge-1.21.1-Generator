<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">

<#assign helmetCustomModel = data.enableHelmet && data.helmetModelName != "Default" && data.getHelmetModel()?? && data.helmetModelPart?has_content>
<#assign bodyCustomModel = data.enableBody && data.bodyModelName != "Default" && data.getBodyModel()?? && data.bodyModelPart?has_content && data.armsModelPartL?has_content && data.armsModelPartR?has_content>
<#assign leggingsCustomModel = data.enableLeggings && data.leggingsModelName != "Default" && data.getLeggingsModel()?? && (data.leggingsModelPartL?has_content || data.leggingsModelPartR?has_content)>
<#assign bootsCustomModel = data.enableBoots && data.bootsModelName != "Default" && data.getBootsModel()?? && data.bootsModelPartL?has_content && data.bootsModelPartR?has_content>

package ${package}.item;

import java.util.function.Consumer;
import net.minecraft.client.model.Model;

<@javacompress>
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public abstract class ${name}Item extends ArmorItem {
	static { MinecraftForge.EVENT_BUS.register(${name}Item.class); }

	private static final ArmorMaterial ARMOR_MATERIAL_VALUE = new ArmorMaterial(
		net.minecraft.Util.make(new EnumMap<>(ArmorItem.Type.class), map -> {
			map.put(ArmorItem.Type.BOOTS, ${data.damageValueBoots});
			map.put(ArmorItem.Type.LEGGINGS, ${data.damageValueLeggings});
			map.put(ArmorItem.Type.CHESTPLATE, ${data.damageValueBody});
			map.put(ArmorItem.Type.HELMET, ${data.damageValueHelmet});
			map.put(ArmorItem.Type.BODY, ${data.damageValueBody});
		}),
		${data.enchantability},
		<#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>
		net.minecraft.core.Holder.direct(net.minecraft.sounds.SoundEvent.createVariableRangeEvent(ResourceLocation.parse("${data.equipSound}"))),
		<#else>
		net.minecraft.sounds.SoundEvents.ARMOR_EQUIP_LEATHER,
		</#if>
		() -> ${mappedMCItemsToIngredient(data.repairItems)},
		List.of(new ArmorMaterial.Layer(ResourceLocation.parse("${modid}:${data.armorTextureFile}"))),
		${data.toughness}f,
		${data.knockbackResistance}f
	);

	public static final Holder<ArmorMaterial> ARMOR_MATERIAL = BuiltInRegistries.ARMOR_MATERIAL.wrapAsHolder(ARMOR_MATERIAL_VALUE);

	@SubscribeEvent public static void registerArmorMaterial(RegisterEvent event) {
		event.register(Registries.ARMOR_MATERIAL,
				registerHelper -> registerHelper.register(ResourceLocation.parse("${modid}:${registryname}"), ARMOR_MATERIAL_VALUE));
	}

	<#if helmetCustomModel || bodyCustomModel || leggingsCustomModel || bootsCustomModel>
	@Override public void initializeClient(Consumer<IClientItemExtensions> consumer) {
		<#if helmetCustomModel>
		if (this.getType() == ArmorItem.Type.HELMET) {
		consumer.accept(new IClientItemExtensions() {
			private HumanoidModel armorModel = null;
			@Override @OnlyIn(Dist.CLIENT) public HumanoidModel getHumanoidArmorModel(LivingEntity living, ItemStack stack, EquipmentSlot slot, HumanoidModel defaultModel) {
				if (armorModel == null) {
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"head", new ${data.helmetModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.helmetModelName}.LAYER_LOCATION)).${data.helmetModelPart},
						"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)))
					<#if data.helmetTranslucency>
					{
						@Override
						public void renderToBuffer(PoseStack poseStack, VertexConsumer buffer, int packedLight, int packedOverlay, int color) {
							VertexConsumer translucentTexture = Minecraft.getInstance().renderBuffers().bufferSource().getBuffer(RenderType.entityTranslucent(
								<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
									${package}.init.${JavaModName}Items.${REGISTRYNAME}_HELMET.get().getArmorTexture(null, null, null, null, false)
								<#else>
									ResourceLocation.parse("${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png")
								</#if>
							));
							super.renderToBuffer(poseStack, translucentTexture, packedLight, packedOverlay, color);
						}
					}
					</#if>;
					armorModel.head.setPos(defaultModel.head.x, defaultModel.head.y, defaultModel.head.z);
					armorModel.head.xRot = defaultModel.head.xRot; armorModel.head.yRot = defaultModel.head.yRot; armorModel.head.zRot = defaultModel.head.zRot;
				}
				armorModel.crouching = living.isShiftKeyDown();
				armorModel.riding = defaultModel.riding;
				armorModel.young = living.isBaby();
				return armorModel;
			}
		});
		}
		</#if>

		<#if bodyCustomModel>
		if (this.getType() == ArmorItem.Type.CHESTPLATE) {
		consumer.accept(new IClientItemExtensions() {
			private HumanoidModel armorModel = null;
			@Override @OnlyIn(Dist.CLIENT) public HumanoidModel getHumanoidArmorModel(LivingEntity living, ItemStack stack, EquipmentSlot slot, HumanoidModel defaultModel) {
				if (armorModel == null) {
					${data.bodyModelName} model = new ${data.bodyModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.bodyModelName}.LAYER_LOCATION));
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"body", model.${data.bodyModelPart},
						"left_arm", model.${data.armsModelPartL},
						"right_arm", model.${data.armsModelPartR},
						"head", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)))
					<#if data.bodyTranslucency>
					{
						@Override
						public void renderToBuffer(PoseStack poseStack, VertexConsumer buffer, int packedLight, int packedOverlay, int color) {
							VertexConsumer translucentTexture = Minecraft.getInstance().renderBuffers().bufferSource().getBuffer(RenderType.entityTranslucent(
								<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
									${package}.init.${JavaModName}Items.${REGISTRYNAME}_CHESTPLATE.get().getArmorTexture(null, null, null, null, false)
								<#else>
									ResourceLocation.parse("${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png")
								</#if>
							));
							super.renderToBuffer(poseStack, translucentTexture, packedLight, packedOverlay, color);
						}
					}
					</#if>;
					armorModel.body.setPos(defaultModel.body.x, defaultModel.body.y, defaultModel.body.z);
					armorModel.body.xRot = defaultModel.body.xRot; armorModel.body.yRot = defaultModel.body.yRot; armorModel.body.zRot = defaultModel.body.zRot;
					armorModel.rightArm.setPos(defaultModel.rightArm.x, defaultModel.rightArm.y, defaultModel.rightArm.z);
					armorModel.rightArm.xRot = defaultModel.rightArm.xRot; armorModel.rightArm.yRot = defaultModel.rightArm.yRot; armorModel.rightArm.zRot = defaultModel.rightArm.zRot;
					armorModel.leftArm.setPos(defaultModel.leftArm.x, defaultModel.leftArm.y, defaultModel.leftArm.z);
					armorModel.leftArm.xRot = defaultModel.leftArm.xRot; armorModel.leftArm.yRot = defaultModel.leftArm.yRot; armorModel.leftArm.zRot = defaultModel.leftArm.zRot;
				}
				armorModel.crouching = living.isShiftKeyDown();
				armorModel.riding = defaultModel.riding;
				armorModel.young = living.isBaby();
				return armorModel;
			}
		});
		}
		</#if>

		<#if leggingsCustomModel>
		if (this.getType() == ArmorItem.Type.LEGGINGS) {
		consumer.accept(new IClientItemExtensions() {
			private HumanoidModel armorModel = null;
			@Override @OnlyIn(Dist.CLIENT) public HumanoidModel getHumanoidArmorModel(LivingEntity living, ItemStack stack, EquipmentSlot slot, HumanoidModel defaultModel) {
				if (armorModel == null) {
					${data.leggingsModelName} model = new ${data.leggingsModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.leggingsModelName}.LAYER_LOCATION));
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"left_leg", <#if data.leggingsModelPartL?has_content>model.${data.leggingsModelPartL}<#else>new ModelPart(Collections.emptyList(), Collections.emptyMap())</#if>,
						"right_leg", <#if data.leggingsModelPartR?has_content>model.${data.leggingsModelPartR}<#else>new ModelPart(Collections.emptyList(), Collections.emptyMap())</#if>,
						"head", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)))
					<#if data.leggingsTranslucency>
					{
						@Override
						public void renderToBuffer(PoseStack poseStack, VertexConsumer buffer, int packedLight, int packedOverlay, int color) {
							VertexConsumer translucentTexture = Minecraft.getInstance().renderBuffers().bufferSource().getBuffer(RenderType.entityTranslucent(
								<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
									${package}.init.${JavaModName}Items.${REGISTRYNAME}_LEGGINGS.get().getArmorTexture(null, null, null, null, false)
								<#else>
									ResourceLocation.parse("${modid}:textures/models/armor/${data.armorTextureFile}_layer_2.png")
								</#if>
							));
							super.renderToBuffer(poseStack, translucentTexture, packedLight, packedOverlay, color);
						}
					}
					</#if>;
					armorModel.leftLeg.setPos(defaultModel.leftLeg.x, defaultModel.leftLeg.y, defaultModel.leftLeg.z);
					armorModel.leftLeg.xRot = defaultModel.leftLeg.xRot; armorModel.leftLeg.yRot = defaultModel.leftLeg.yRot; armorModel.leftLeg.zRot = defaultModel.leftLeg.zRot;
					armorModel.rightLeg.setPos(defaultModel.rightLeg.x, defaultModel.rightLeg.y, defaultModel.rightLeg.z);
					armorModel.rightLeg.xRot = defaultModel.rightLeg.xRot; armorModel.rightLeg.yRot = defaultModel.rightLeg.yRot; armorModel.rightLeg.zRot = defaultModel.rightLeg.zRot;
				}
				armorModel.crouching = living.isShiftKeyDown();
				armorModel.riding = defaultModel.riding;
				armorModel.young = living.isBaby();
				return armorModel;
			}
		});
		}
		</#if>

		<#if bootsCustomModel>
		if (this.getType() == ArmorItem.Type.BOOTS) {
		consumer.accept(new IClientItemExtensions() {
			private HumanoidModel armorModel = null;
			@Override @OnlyIn(Dist.CLIENT) public HumanoidModel getHumanoidArmorModel(LivingEntity living, ItemStack stack, EquipmentSlot slot, HumanoidModel defaultModel) {
				if (armorModel == null) {
					${data.bootsModelName} model = new ${data.bootsModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.bootsModelName}.LAYER_LOCATION));
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"left_leg", model.${data.bootsModelPartL},
						"right_leg", model.${data.bootsModelPartR},
						"head", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)))
					<#if data.bootsTranslucency>
					{
						@Override
						public void renderToBuffer(PoseStack poseStack, VertexConsumer buffer, int packedLight, int packedOverlay, int color) {
							VertexConsumer translucentTexture = Minecraft.getInstance().renderBuffers().bufferSource().getBuffer(RenderType.entityTranslucent(
								<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
									${package}.init.${JavaModName}Items.${REGISTRYNAME}_BOOTS.get().getArmorTexture(null, null, null, null, false)
								<#else>
									ResourceLocation.parse("${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png")
								</#if>
							));
							super.renderToBuffer(poseStack, translucentTexture, packedLight, packedOverlay, color);
						}
					}
					</#if>;
					armorModel.leftLeg.setPos(defaultModel.leftLeg.x, defaultModel.leftLeg.y, defaultModel.leftLeg.z);
					armorModel.leftLeg.xRot = defaultModel.leftLeg.xRot; armorModel.leftLeg.yRot = defaultModel.leftLeg.yRot; armorModel.leftLeg.zRot = defaultModel.leftLeg.zRot;
					armorModel.rightLeg.setPos(defaultModel.rightLeg.x, defaultModel.rightLeg.y, defaultModel.rightLeg.z);
					armorModel.rightLeg.xRot = defaultModel.rightLeg.xRot; armorModel.rightLeg.yRot = defaultModel.rightLeg.yRot; armorModel.rightLeg.zRot = defaultModel.rightLeg.zRot;
				}
				armorModel.crouching = living.isShiftKeyDown();
				armorModel.riding = defaultModel.riding;
				armorModel.young = living.isBaby();
				return armorModel;
			}
		});
		}
		</#if>
	}
	</#if>

	public ${name}Item(ArmorItem.Type type, Item.Properties properties) {
		super(ARMOR_MATERIAL, type, properties);
	}

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {

		public Helmet() {
			super(ArmorItem.Type.HELMET, <@itemProperties "HELMET" data.helmetImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[0]) "helmet" "EquipmentSlotGroup.HEAD" data.damageValueHelmet/>);
		}

		<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
		private final ResourceLocation armorTexture = ResourceLocation.parse("${modid}:textures/entities/${data.helmetModelTexture}");

		@Override public ResourceLocation getArmorTexture(ItemStack stack, Entity entity, EquipmentSlot slot, ArmorMaterial.Layer layer, boolean innerModel) {
			return armorTexture;
		}
		</#if>

		<@addSpecialInformation data.helmetSpecialInformation, "item." + modid + "." + registryname + "_helmet"/>

		<@hasGlow data.helmetGlowCondition/>

		<@piglinNeutral data.helmetPiglinNeutral/>

		<@onArmorTick data.onHelmetTick/>
	}
	</#if>

	<#if data.enableBody>
	public static class Chestplate extends ${name}Item {

		public Chestplate() {
			super(ArmorItem.Type.CHESTPLATE, <@itemProperties "CHESTPLATE" data.bodyImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[1]) "chestplate" "EquipmentSlotGroup.CHEST" data.damageValueBody/>);
		}

		<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
		private final ResourceLocation armorTexture = ResourceLocation.parse("${modid}:textures/entities/${data.bodyModelTexture}");

		@Override public ResourceLocation getArmorTexture(ItemStack stack, Entity entity, EquipmentSlot slot, ArmorMaterial.Layer layer, boolean innerModel) {
			return armorTexture;
		}
		</#if>

		<@addSpecialInformation data.bodySpecialInformation, "item." + modid + "." + registryname + "_chestplate"/>

		<@hasGlow data.bodyGlowCondition/>

		<@piglinNeutral data.bodyPiglinNeutral/>

		<@onArmorTick data.onBodyTick/>
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {

		public Leggings() {
			super(ArmorItem.Type.LEGGINGS, <@itemProperties "LEGGINGS" data.leggingsImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[2]) "leggings" "EquipmentSlotGroup.LEGS" data.damageValueLeggings/>);
		}

		<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
		private final ResourceLocation armorTexture = ResourceLocation.parse("${modid}:textures/entities/${data.leggingsModelTexture}");

		@Override public ResourceLocation getArmorTexture(ItemStack stack, Entity entity, EquipmentSlot slot, ArmorMaterial.Layer layer, boolean innerModel) {
			return armorTexture;
		}
		</#if>

		<@addSpecialInformation data.leggingsSpecialInformation, "item." + modid + "." + registryname + "_leggings"/>

		<@hasGlow data.leggingsGlowCondition/>

		<@piglinNeutral data.leggingsPiglinNeutral/>

		<@onArmorTick data.onLeggingsTick/>
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {

		public Boots() {
			super(ArmorItem.Type.BOOTS, <@itemProperties "BOOTS" data.bootsImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[3]) "boots" "EquipmentSlotGroup.FEET" data.damageValueBoots/>);
		}

		<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
		private final ResourceLocation armorTexture = ResourceLocation.parse("${modid}:textures/entities/${data.bootsModelTexture}");

		@Override public ResourceLocation getArmorTexture(ItemStack stack, Entity entity, EquipmentSlot slot, ArmorMaterial.Layer layer, boolean innerModel) {
			return armorTexture;
		}
		</#if>

		<@addSpecialInformation data.bootsSpecialInformation, "item." + modid + "." + registryname + "_boots"/>

		<@hasGlow data.bootsGlowCondition/>

		<@piglinNeutral data.bootsPiglinNeutral/>

		<@onArmorTick data.onBootsTick/>
	}
	</#if>

}
</@javacompress>
<#-- @formatter:on -->

<#macro itemProperties armorPart immuneToFire>
new Item.Properties()
<#if immuneToFire>
.fireResistant()
</#if>
<#if data.rarity != "COMMON">
.rarity(Rarity.${data.rarity})
</#if>
<#if data.maxDamage != 0>
.durability(ArmorItem.Type.${armorPart}.getDurability(${data.maxDamage}))
<#else>
.stacksTo(1)
</#if>
</#macro>

<#macro itemAttributeModifiers modifiers armorPart defaultEquipSlot defense>
<#if modifiers?size != 0>
.attributes(
	ItemAttributeModifiers.builder()
	<#-- First add the default armor attributes -->
	.add(Attributes.ARMOR, new AttributeModifier(ResourceLocation.withDefaultNamespace("armor.${armorPart}"), ${defense}, AttributeModifier.Operation.ADD_VALUE), ${defaultEquipSlot})
	<#if data.toughness != 0>.add(Attributes.ARMOR_TOUGHNESS, new AttributeModifier(ResourceLocation.withDefaultNamespace("armor.${armorPart}"), ${data.toughness}, AttributeModifier.Operation.ADD_VALUE), ${defaultEquipSlot})</#if>
	<#if data.knockbackResistance != 0>.add(Attributes.KNOCKBACK_RESISTANCE, new AttributeModifier(ResourceLocation.withDefaultNamespace("armor.${armorPart}"), ${data.knockbackResistance}, AttributeModifier.Operation.ADD_VALUE), ${defaultEquipSlot})</#if>
	<#-- Then add the custom modifiers -->
	<#list modifiers as modifier>
	.add(<#if modifier.attribute?starts_with("Attributes.")>${modifier.attribute}<#else>${modifier.attribute}.getHolder().orElseThrow()</#if>, new AttributeModifier(
			ResourceLocation.fromNamespaceAndPath(${package}.${JavaModName}.MODID, "${registryname}_${modifier?index}.${armorPart}"),
			${modifier.amount}, AttributeModifier.Operation.${modifier.operation}),
			<#if modifier.equipmentSlot.getUnmappedValue() == "default">${defaultEquipSlot}<#else>${modifier.equipmentSlot}</#if>)
	</#list>.build()
)
</#if>
</#macro>



