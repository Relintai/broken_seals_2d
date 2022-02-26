tool
extends Terrain2DLevelGenerator


func _generate_chunk(chunk : Terrain2DChunk):
	chunk.channel_ensure_allocated(Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	
	chunk.set_voxel(2, 0, 0, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(3, 1, 0, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(4, 1, 1, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
