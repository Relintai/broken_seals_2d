extends CharacterAtlasEntry
class_name CharacterAtlasEntry2D

export(Rect2) var front_rect : Rect2
export(Rect2) var back_rect : Rect2 
export(Rect2) var right_rect : Rect2
export(Rect2) var left_rect : Rect2

func get_index(facing : int) -> Rect2:
	if facing == CharacterSkeleton2D.CharacterFacing.FACING_FRONT:
		return front_rect
	if facing == CharacterSkeleton2D.CharacterFacing.FACING_BACK:
		return back_rect
	if facing == CharacterSkeleton2D.CharacterFacing.FACING_RIGHT:
		return right_rect
	if facing == CharacterSkeleton2D.CharacterFacing.FACING_LEFT:
		return left_rect
		
	return front_rect
