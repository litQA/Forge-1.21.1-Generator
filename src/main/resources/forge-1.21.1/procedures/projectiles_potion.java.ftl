<@addTemplate file="utils/projectiles/potion.java.ftl"/>
<#assign potion = generator.map(field$potion, "potions")>
createPotionProjectile(projectileLevel, PotionContents.createItemStack(Items.${field$potionType}, ${potion?starts_with("Potions.")?then(potion, potion + ".getHolder().orElseThrow()")}), ${input$shooter}, new Vec3(${input$ax}, ${input$ay}, ${input$az}))