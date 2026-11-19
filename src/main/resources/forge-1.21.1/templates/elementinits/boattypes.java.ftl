<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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
<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign boatsWithTickEvent = specialentities?filter(e -> hasProcedure(e.onTickUpdate))>

<#if boatsWithTickEvent?size gt 0>
@Mod.EventBusSubscriber(modid = ${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.FORGE)
</#if>public class ${JavaModName}BoatTypes {

	<#if boatsWithTickEvent?size gt 0>
	@SubscribeEvent public static void onBoatsTick(TickEvent.LevelTickEvent event) {
		if (event.phase != TickEvent.Phase.END || !(event.level instanceof net.minecraft.server.level.ServerLevel serverLevel)) return;
		for (Entity entity : serverLevel.getAllEntities()) {
			if (entity instanceof Boat boat) {
				<#list boatsWithTickEvent as entity>
				<@procedureCode entity.onTickUpdate, {
					"x": "boat.getX()",
					"y": "boat.getY()",
					"z": "boat.getZ()",
					"entity": "boat",
					"world": "boat.level()"
				}/>
				</#list>
			}
		}
	}
	</#if>
}
