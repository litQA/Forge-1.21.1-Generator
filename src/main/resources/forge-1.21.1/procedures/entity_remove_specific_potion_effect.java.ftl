<#assign effect = generator.map(field$potion, "effects")>
<#assign effectHolder = effect?starts_with("MobEffects.")?then(effect, effect + ".getHolder().orElseThrow()")>
if (${input$entity} instanceof LivingEntity _entity) _entity.removeEffect(${effectHolder});