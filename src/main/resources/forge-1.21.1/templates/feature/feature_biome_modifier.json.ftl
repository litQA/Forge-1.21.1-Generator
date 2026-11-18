<#assign spawnBiomes = w.filterBrokenReferences(data.restrictionBiomes)>
{
  <#if spawnBiomes?size == 0>
  "type": "${modid}:any_features",
  <#elseif spawnBiomes?size == 1>
  "type": "forge:add_features",
  "biomes": "${spawnBiomes?first}",
  <#else>
  "type": "forge:add_features",
  "biomes": [
    <#list spawnBiomes as spawnBiome>"${spawnBiome}"<#sep>,</#list>
  ],
  </#if>
  "features": "${modid}:${registryname}",
  "step": "${data.generationStep}"
}
