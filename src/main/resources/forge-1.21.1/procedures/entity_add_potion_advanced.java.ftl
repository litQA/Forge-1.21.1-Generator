<#assign effect = generator.map(field$potion, "effects")>
if(${input$entity} instanceof LivingEntity _entity && !_entity.level().isClientSide())
	_entity.addEffect(new MobEffectInstance(${effect?starts_with("MobEffects.")?then(effect, effect + ".getHolder().orElseThrow()")}, ${opt.toInt(input$duration)}, ${opt.toInt(input$level)}, ${input$ambient}, ${input$particles}));