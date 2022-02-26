tool
extends Terrain2DLevelGenerator


func _generate_chunk(chunk : Terrain2DChunk):
	chunk.channel_ensure_allocated(Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	
	#chunk.set_voxel(2, 1, 1, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
