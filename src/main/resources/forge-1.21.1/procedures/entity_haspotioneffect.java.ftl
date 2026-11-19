<#assign effect = generator.map(field$potion, "effects")>
<#assign effectHolder = effect?starts_with("MobEffects.")?then(effect, effect + ".getHolder().orElseThrow()")>
(${input$entity} instanceof LivingEntity _livEnt${cbi} && _livEnt${cbi}.hasEffect(${effectHolder}))