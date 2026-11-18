<#assign attribute = generator.map(field$attribute, "attributes")>
<#assign attributeHolder = attribute?starts_with("Attributes.")?then(attribute, attribute + ".getHolder().orElseThrow()")>
(${input$entity} instanceof LivingEntity _livingEntity${cbi} && _livingEntity${cbi}.getAttributes().hasAttribute(${attributeHolder}))