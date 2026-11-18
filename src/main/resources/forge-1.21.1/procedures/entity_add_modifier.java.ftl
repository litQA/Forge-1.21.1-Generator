<#include "mcelements.ftl">
<#assign attr = generator.map(field$attribute, "attributes")>
<#assign attrHolder = attr?starts_with("Attributes.")?then(attr, attr + ".getHolder().orElseThrow()")>
if (${input$entity} instanceof LivingEntity _entity) {
	AttributeModifier modifier = new AttributeModifier(${toResourceLocation('"' + modid + ':' + field$name + '"')}, ${input$value}, AttributeModifier.Operation.${field$operation});
	if (!_entity.getAttribute(${attrHolder}).hasModifier(modifier.id())) {
		<#if field$permanent == "TRUE">
			_entity.getAttribute(${attrHolder}).addPermanentModifier(modifier);
		<#else>
			_entity.getAttribute(${attrHolder}).addTransientModifier(modifier);
		</#if>
	}
}