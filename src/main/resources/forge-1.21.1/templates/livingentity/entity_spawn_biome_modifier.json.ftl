<#assign spawnBiomes = w.filterBrokenReferences(data.restrictionBiomes)>
{
  <#if spawnBiomes?size == 0>
  "type": "${modid}:any_spawns",
  <#elseif spawnBiomes?size == 1>
  "type": "forge:add_spawns",
  "biomes": "${spawnBiomes?first}",
  <#else>
  "type": "forge:add_spawns",
  "biomes": [
    <#list spawnBiomes as spawnBiome>"${spawnBiome}"<#sep>,</#list>
  ],
  </#if>
  "spawners": {
    "type": "${modid}:${registryname}",
    "weight": ${data.spawningProbability},
    "minCount": ${data.minNumberOfMobsPerGroup},
    "maxCount": ${data.maxNumberOfMobsPerGroup}
  }
}
