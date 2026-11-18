{
  "type": "${modid}:add_table",
  "conditions": [
    {
      "condition": "forge:loot_table_id",
      "loot_table_id": "${w.resolveModNamespace(data.lootTableToModify)}"
    }
  ],
  "table": "${data.getResourceLocation()}"
}
