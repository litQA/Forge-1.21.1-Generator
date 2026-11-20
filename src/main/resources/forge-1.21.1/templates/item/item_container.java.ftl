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
package ${package}.item.inventory;

import javax.annotation.Nonnull;
import net.minecraft.core.Direction;
import net.minecraft.core.NonNullList;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.component.ItemContainerContents;
import net.minecraft.core.component.DataComponents;
import net.minecraftforge.common.capabilities.Capability;
import net.minecraftforge.common.capabilities.ForgeCapabilities;
import net.minecraftforge.common.capabilities.ICapabilityProvider;
import net.minecraftforge.common.util.LazyOptional;
import net.minecraftforge.items.ItemStackHandler;

<@javacompress>
@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE) public class ${name}InventoryCapability extends ItemStackHandler implements ICapabilityProvider {

	public ${name}InventoryCapability(ItemStack stack) {
		super(${data.inventorySize});
		this.stack = stack;
		ItemContainerContents contents = stack.get(DataComponents.CONTAINER);
		if (contents != null) {
			NonNullList<ItemStack> items = NonNullList.withSize(getSlots(), ItemStack.EMPTY);
			contents.copyInto(items);
			for (int i = 0; i < getSlots(); i++) {
				super.setStackInSlot(i, items.get(i));
			}
		}
	}

	private final ItemStack stack;

	<#if data.inventoryStackSize != 99>
	@Override public int getSlotLimit(int slot) {
		return ${data.inventoryStackSize};
	}
	</#if>

	@Override public boolean isItemValid(int slot, @Nonnull ItemStack stack) {
		return stack.getItem() != ${package}.init.${JavaModName}Items.${REGISTRYNAME}.get();
	}

	@Override protected void onContentsChanged(int slot) {
		NonNullList<ItemStack> items = NonNullList.withSize(getSlots(), ItemStack.EMPTY);
		for (int i = 0; i < getSlots(); i++) {
			items.set(i, getStackInSlot(i));
		}
		stack.set(DataComponents.CONTAINER, ItemContainerContents.fromItems(items));
	}

	@Override public <T> LazyOptional<T> getCapability(Capability<T> capability, Direction side) {
		return capability == ForgeCapabilities.ITEM_HANDLER ? LazyOptional.of(() -> this).cast() : LazyOptional.empty();
	}

}
</@javacompress>

<#-- @formatter:on -->

