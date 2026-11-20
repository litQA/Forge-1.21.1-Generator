<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

<#include "../mcitems.ftl">

package ${package}.world.features.treedecorators;

@Mod.EventBusSubscriber(modid = ${package}.${JavaModName}.MODID, bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}FruitDecorator extends CocoaDecorator {
	static { MinecraftForge.EVENT_BUS.register(${name}FruitDecorator.class); }

    public static MapCodec<${name}FruitDecorator> CODEC = MapCodec.unit(${name}FruitDecorator::new);

    public static TreeDecoratorType<?> DECORATOR_TYPE = new TreeDecoratorType<>(CODEC);

    @SubscribeEvent public static void registerTreeDecorator(RegisterEvent event) {
        event.register(Registries.TREE_DECORATOR_TYPE, ResourceLocation.parse("${modid}:${registryname}_tree_fruit_decorator"), () -> DECORATOR_TYPE);
    }

    public ${name}FruitDecorator() {
        super(0.2f);
    }

    @Override protected TreeDecoratorType<?> type() {
        return DECORATOR_TYPE;
    }

    @Override public void place(TreeDecorator.Context context) {
        RandomSource random = context.random();
        if (random.nextFloat() >= 0.2F)
            return;
        List<BlockPos> logs = context.logs();
        if (logs.isEmpty())
            return;
        int baseY = logs.get(0).getY();
        logs.stream().filter(pos -> pos.getY() - baseY <= 2).forEach(pos -> {
            for (Direction direction : Direction.Plane.HORIZONTAL) {
                if (random.nextFloat() <= 0.25F) {
                    Direction opposite = direction.getOpposite();
                    BlockPos target = pos.offset(opposite.getStepX(), 0, opposite.getStepZ());
                    if (context.isAir(target))
                        context.setBlock(target, oriented(${mappedBlockToBlockStateCode(data.treeFruits)}, direction));
                }
            }
        });
    }

    @SuppressWarnings("deprecation") private static BlockState oriented(BlockState blockstate, Direction direction) {
        return switch (direction) {
            case SOUTH -> blockstate.rotate(Rotation.CLOCKWISE_180);
            case EAST -> blockstate.rotate(Rotation.CLOCKWISE_90);
            case WEST -> blockstate.rotate(Rotation.COUNTERCLOCKWISE_90);
            default -> blockstate;
        };
    }

}
<#-- @formatter:on -->

