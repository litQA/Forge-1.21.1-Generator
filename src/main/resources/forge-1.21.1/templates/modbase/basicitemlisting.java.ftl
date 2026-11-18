<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
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

package ${package}.trade;

import java.util.Optional;

import net.minecraft.util.RandomSource;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.npc.VillagerTrades;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.trading.ItemCost;
import net.minecraft.world.item.trading.MerchantOffer;

public class BasicItemListing implements VillagerTrades.ItemListing {
	private final ItemStack price;
	private final ItemStack price2;
	private final ItemStack forSale;
	private final int maxUses;
	private final int xp;
	private final float priceMultiplier;

	public BasicItemListing(ItemStack price, ItemStack forSale, int maxUses, int xp, float priceMultiplier) {
		this(price, ItemStack.EMPTY, forSale, maxUses, xp, priceMultiplier);
	}

	public BasicItemListing(ItemStack price, ItemStack price2, ItemStack forSale, int maxUses, int xp, float priceMultiplier) {
		this.price = price;
		this.price2 = price2;
		this.forSale = forSale;
		this.maxUses = maxUses;
		this.xp = xp;
		this.priceMultiplier = priceMultiplier;
	}

	@Override public MerchantOffer getOffer(Entity entity, RandomSource random) {
		Optional<ItemCost> secondCost = this.price2.isEmpty() ? Optional.empty()
				: Optional.of(new ItemCost(this.price2.getItem(), this.price2.getCount()));
		return new MerchantOffer(new ItemCost(this.price.getItem(), this.price.getCount()), secondCost,
				this.forSale, this.maxUses, this.xp, this.priceMultiplier);
	}
}
