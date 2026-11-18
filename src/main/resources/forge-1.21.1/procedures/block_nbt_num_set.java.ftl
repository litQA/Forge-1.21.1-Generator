<#include "mcelements.ftl">
<@head>
if (!world.isClientSide()) {
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	BlockEntity _blockEntity = world.getBlockEntity(_bp);
	BlockState _bs = world.getBlockState(_bp);
	if(_blockEntity != null) {
</@head>
		${package}.blockentitydata.BlockEntityData.get(world, _bp).putDouble(${input$tagName}, ${input$tagValue});
		${package}.blockentitydata.BlockEntityData.markDirty(world);
<@tail>
	}
	if(world instanceof Level _level)
		_level.sendBlockUpdated(_bp, _bs, _bs, 3);
}</@tail>