<#if w.hasElementsOfType("gui")>
if (${input$entity} instanceof Player _player && _player.containerMenu instanceof ${package}.init.${JavaModName}Menus.MenuAccessor _menu)
	_menu.sendMenuStateUpdate(_player, 2, "${field$slider}", ${input$value}, true);
</#if>
