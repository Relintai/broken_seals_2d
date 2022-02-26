tool
extends Terrain2DLevelGenerator


func _generate_chunk(chunk : Terrain2DChunk):
	chunk.channel_ensure_allocated(Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE, 1)
	chunk.channel_ensure_allocated(Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS, 0)
	
	chunk.set_voxel(2, 0, 0, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(3, 1, 0, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(4, 1, 1, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(1, 0, 1, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	
	var def_flag : int = Terrain2DChunkDefault.FLAG_CHANNEL_WALL_NORTH | Terrain2DChunkDefault.FLAG_CHANNEL_WALL_SOUTH | Terrain2DChunkDefault.FLAG_CHANNEL_WALL_EAST | Terrain2DChunkDefault.FLAG_CHANNEL_WALL_WEST #| Terrain2DChunkDefault.FLAG_CHANNEL_WALL_HOLE
	var def_flag_back : int = Terrain2DChunkDefault.FLAG_CHANNEL_WALL_NORTH | Terrain2DChunkDefault.FLAG_CHANNEL_WALL_WEST #| Terrain2DChunkDefault.FLAG_CHANNEL_WALL_HOLE
	
	chunk.set_voxel(3, 3, 3, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(def_flag_back, 3, 3, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
	
	chunk.set_voxel(3, 4, 6, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	chunk.set_voxel(def_flag, 4, 6, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
	
	#chunk.set_voxel(1, 3, 4, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
	#chunk.set_voxel(def_flag, 3, 4, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
	
	
#	chunk.set_voxel(1, 3, 3, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
#	chunk.set_voxel(Terrain2DChunkDefault.FLAG_CHANNEL_WALL_EAST, 3, 5, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
#	chunk.set_voxel(1, 3, 3, Terrain2DChunkDefault.DEFAULT_CHANNEL_TYPE)
#	chunk.set_voxel(Terrain2DChunkDefault.FLAG_CHANNEL_WALL_EAST, 3, 5, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
#
#	chunk.set_voxel(Terrain2DChunkDefault.FLAG_CHANNEL_WALL_SOUTH, 6, 4, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
#	chunk.set_voxel(Terrain2DChunkDefault.FLAG_CHANNEL_WALL_SOUTH, 7, 4, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
#	chunk.set_voxel(Terrain2DChunkDefault.FLAG_CHANNEL_WALL_WEST, 8, 4, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)
#	chunk.set_voxel(Terrain2DChunkDefault.FLAG_CHANNEL_WALL_WEST, 9, 4, Terrain2DChunkDefault.DEFAULT_CHANNEL_FLAGS)