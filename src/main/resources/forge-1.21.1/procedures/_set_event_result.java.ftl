<#if trigger == "bonemeal_used" || trigger == "entity_grief" || trigger == "crop_attempts_growth" || trigger == "entity_item_pickup">
	if (event != null && event.hasResult())
		event.setResult(Event.Result.${result});
<#elseif trigger == "player_critical_hit">
	if (event instanceof CriticalHitEvent _event) {
		<#if result == "DEFAULT">
		_event.setDamageModifier(_event.getOldDamageModifier());
		<#elseif result == "ALLOW">
		_event.setDamageModifier(1.5f);
		<#elseif result == "DENY">
		_event.setDamageModifier(1.0f);
		</#if>
	}
</#if>
