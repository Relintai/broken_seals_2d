tool
extends Resource

export(Texture) var input : Texture
export(String) var output_image_name : String = "output"
export(float) var shear_amount : float = 0.3
export(int) var image_count : int = 1
export(int) var image_size_x : int = 32
export(int) var image_size_y : int = 64
export(bool) var alpha_crop : bool = true

export(bool) var generate : bool = false setget set_generate, get_generate

static func shear(uv : Vector2, center : Vector2, amount : float,  direction : Vector2) -> Vector2:
	return uv + Vector2(amount, amount) * (Vector2(uv.y, uv.x) - center) * direction

static func shear_vertical(uv : Vector2, center : Vector2, amount : float) -> Vector2:
	return uv + Vector2(amount, amount) * (Vector2(uv.y, uv.x) - center) * Vector2(0, 1)
	
static func shear_horizontal(uv : Vector2, center : Vector2, amount : float) -> Vector2:
	return uv + Vector2(amount, amount) * (Vector2(uv.y, uv.x) - center) * Vector2(1, 0)

#from mat_maker_gd
static func rotate(uv : Vector2, center : Vector2, rotate : float) -> Vector2:
	var rv : Vector2 = Vector2()
	uv -= center
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y
	rv += center
	return rv

#from mat_maker_gd
static func scale(uv : Vector2, center : Vector2, scale : Vector2) -> Vector2:
	uv -= center
	uv /= scale
	uv += center
	return uv

func generate():
	if !input:
		return
	
	var inimg : Image = input.get_data()
	var img : Image = null
	
	if image_count > 1:
		pass
	else:
		img = Image.new()
		img.create(inimg.get_width() * 3, inimg.get_height() * 3, false, Image.FORMAT_RGBA8)
	
	var ofsx : int = inimg.get_width()
	var ofsy : int = inimg.get_height()
	
	img.lock()
	inimg.lock()
	
	for x in range(inimg.get_width()):
		for y in range(inimg.get_height()):
			var np : Vector2 = shear_vertical(Vector2(x, y), Vector2(x / 2, y / 2), shear_amount)
			np += Vector2(ofsx, ofsy)
			
			var c : Color = inimg.get_pixel(x, y)
			
			img.set_pixel(np.x, np.y, c)
	
	img.unlock()
	inimg.unlock()
	
	img = crop_image(img)
	
	img.resize(image_size_x, image_size_y, Image.INTERPOLATE_CUBIC)
	
	if alpha_crop:
		alpha_crop(img)
	
	img.save_png(resource_path.get_base_dir() + "/" + output_image_name + ".png")

func alpha_crop(img : Image) -> void:
	img.lock()

	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var c : Color = img.get_pixel(x, y)
			
			if c.a < 0.5:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
			elif c.a < 1:
				c.a = 1
				img.set_pixel(x, y, c)
			
	img.unlock()

func crop_image(img : Image) -> Image:
	img.lock()
	
	var xmin : int = img.get_width() + 1
	var xmax : int = 0
	var ymin : int = img.get_height() + 1
	var ymax : int = 0
	
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var c : Color = img.get_pixel(x, y)
			
			if c.a < 0.02:
				continue
				
			if xmin > x:
				xmin = x
				
			if xmax < x:
				xmax = x
				
			if ymin > y:
				ymin = y
				
			if ymax < y:
				ymax = y
	
	img.unlock()
	
	var w : int = xmax - xmin
	var h : int = ymax - ymin
	
	var rimg : Image = Image.new()
	rimg.create(w, h, false, Image.FORMAT_RGBA8)
	
	rimg.blit_rect(img, Rect2(xmin, ymin, w, h), Vector2())
	
	return rimg

func set_generate(val):
	if val:
		generate()

func get_generate():
	return false
