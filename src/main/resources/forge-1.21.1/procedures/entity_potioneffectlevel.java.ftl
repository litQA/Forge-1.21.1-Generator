<#assign effect = generator.map(field$potion, "effects")>
<#assign effectHolder = effect?starts_with("MobEffects.")?then(effect, effect + ".getHolder().orElseThrow()")>
/*@int*/(${input$entity} instanceof LivingEntity _livEnt && _livEnt.hasEffect(${effectHolder}) ?
    _livEnt.getEffect(${effectHolder}).getAmplifier() : 0)