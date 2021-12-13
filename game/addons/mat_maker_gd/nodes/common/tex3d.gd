tool
extends Reference

const Commons = preload("res://addons/mat_maker_gd/nodes/common/commons.gd")

#----------------------
#tex3d_apply.mmg
#Applies 3D textures to a rendered 3D signed distance function scene.

#		"inputs": [
#			{
#				"default": "0.0",
#				"label": "Height",
#				"longdesc": "The height map generated by the Render node",
#				"name": "z",
#				"shortdesc": "HeightMap",
#				"type": "f"
#			},
#			{
#				"default": "0.0",
#				"label": "Color",
#				"longdesc": "The color map generated by the Render node",
#				"name": "c",
#				"shortdesc": "ColorMap",
#				"type": "f"
#			},
#			{
#				"default": "vec3(1.0)",
#				"label": "Texture",
#				"longdesc": "The 3D texture",
#				"name": "t",
#				"shortdesc": "Tex3D",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The textured 3D scene",
#				"rgb": "$t(vec4($uv, $z($uv), $c($uv)))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],

#----------------------
#tex3d_apply_invuvmap.mmg
#This node applies a 3D texture to an object using its inverse UV map.

#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "Texture",
#				"longdesc": "The input 3D texture",
#				"name": "t",
#				"shortdesc": "Texture",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "Inv. UV Map",
#				"longdesc": "The inverse UV map of the object",
#				"name": "map",
#				"shortdesc": "InvUVMap",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated texture",
#				"rgb": "$t(vec4($map($uv), 0.0))",
#				"shortdesc": "Output",
#				"type": "rgb"
#			}
#		],

#----------------------
#tex3d_blend.mmg
#Blends its 3D texture inputs, using an optional mask

#		"inputs": [
#			{
#				"default": "vec3($uv.x, 1.0, 1.0)",
#				"label": "Source1",
#				"longdesc": "The foreground input",
#				"name": "s1",
#				"shortdesc": "Foreground",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(1.0, $uv.y, 1.0)",
#				"label": "Source2",
#				"longdesc": "The background input",
#				"name": "s2",
#				"shortdesc": "Background",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(1.0)",
#				"label": "Opacity",
#				"longdesc": "The optional opacity mask",
#				"name": "a",
#				"shortdesc": "Mask",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The 3D texture generated by the blend operation",
#				"shortdesc": "Output",
#				"tex3d": "blend3d_$blend_type($s1($uv).rgb, $s2($uv).rgb, $amount*dot($a($uv), vec3(1.0))/3.0)",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "",
#				"longdesc": "The algorithm used to blend the inputs",
#				"name": "blend_type",
#				"shortdesc": "Blend mode",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Normal",
#						"value": "normal"
#					},
#					{
#						"name": "Multiply",
#						"value": "multiply"
#					},
#					{
#						"name": "Screen",
#						"value": "screen"
#					},
#					{
#						"name": "Overlay",
#						"value": "overlay"
#					},
#					{
#						"name": "Hard Light",
#						"value": "hard_light"
#					},
#					{
#						"name": "Soft Light",
#						"value": "soft_light"
#					},
#					{
#						"name": "Burn",
#						"value": "burn"
#					},
#					{
#						"name": "Dodge",
#						"value": "dodge"
#					},
#					{
#						"name": "Lighten",
#						"value": "lighten"
#					},
#					{
#						"name": "Darken",
#						"value": "darken"
#					},
#					{
#						"name": "Difference",
#						"value": "difference"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "3:",
#				"longdesc": "The opacity of the blend operation",
#				"max": 1,
#				"min": 0,
#				"name": "amount",
#				"shortdesc": "Opacity",
#				"step": 0,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_colorize.mmg
#Remaps a greyscale 3D texture to a custom gradient

#		"inputs": [
#			{
#				"default": "vec3($uv.x+0.5)",
#				"label": "",
#				"longdesc": "The input greyscale 3D texture",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The remapped color 3D texture ",
#				"shortdesc": "Output",
#				"tex3d": "$g(dot($in($uv), vec3(1.0))/3.0).rgb",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": {
#					"interpolation": 1,
#					"points": [
#						{
#							"a": 1,
#							"b": 0,
#							"g": 0,
#							"pos": 0,
#							"r": 0
#						},
#						{
#							"a": 1,
#							"b": 1,
#							"g": 1,
#							"pos": 1,
#							"r": 1
#						}
#					],
#					"type": "Gradient"
#				},
#				"label": "",
#				"longdesc": "The gradient to which the input is remapped",
#				"name": "g",
#				"shortdesc": "Gradient",
#				"type": "gradient"
#			}
#		],

#----------------------
#tex3d_distort.mmg
#Distorts its input 3D texture using another 3D texture

#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "",
#				"longdesc": "The 3D texture to be distorted",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.0)",
#				"label": "",
#				"longdesc": "The 3D texture used to distort Input1",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The distorted 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "$in1(vec4($uv.xyz+($in2($uv)*$Distort*0.5-0.5), 0.0))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Distort",
#				"longdesc": "The strength of the distort effect",
#				"max": 1,
#				"min": 0,
#				"name": "Distort",
#				"shortdesc": "Strength",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_fbm.mmg
#Generates a 3D noise made of several octaves of a simple noise

#		"instance": "float $(name)_fbm(vec3 coord, vec3 size, int octaves, float persistence, float seed) {\n\tfloat normalize_factor = 0.0;\n\tfloat value = 0.0;\n\tfloat scale = 1.0;\n\tfor (int i = 0; i < octaves; i++) {\n\t\tvalue += tex3d_fbm_$noise(coord*size, size, seed) * scale;\n\t\tnormalize_factor += scale;\n\t\tsize *= 2.0;\n\t\tscale *= persistence;\n\t}\n\treturn value / normalize_factor;\n}\n",
#		"outputs": [
#			{
#				"longdesc": "Shows a greyscale 3D texture of the generated noise",
#				"shortdesc": "Output",
#				"tex3d": "vec3($(name)_fbm($(uv).xyz, vec3($(scale_x), $(scale_y), $(scale_z)), int($(iterations)), $(persistence), float($(seed))))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 2,
#				"label": "Noise",
#				"longdesc": "The simple noise type",
#				"name": "noise",
#				"shortdesc": "Noise type",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Value",
#						"value": "value"
#					},
#					{
#						"name": "Perlin",
#						"value": "perlin"
#					},
#					{
#						"name": "Cellular",
#						"value": "cellular"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale X",
#				"longdesc": "The scale of the first octave along the X axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_x",
#				"shortdesc": "Scale.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale Y",
#				"longdesc": "The scale of the first octave along the Y axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_y",
#				"shortdesc": "Scale.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "Scale Z",
#				"longdesc": "The scale of the first octave along the Z axis",
#				"max": 32,
#				"min": 1,
#				"name": "scale_z",
#				"shortdesc": "Scale.z",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 3,
#				"label": "Iterations",
#				"longdesc": "The number of noise octaves",
#				"max": 10,
#				"min": 1,
#				"name": "iterations",
#				"shortdesc": "Octaves",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Persistence",
#				"longdesc": "The persistence between two consecutive octaves",
#				"max": 1,
#				"min": 0,
#				"name": "persistence",
#				"shortdesc": "Persistence",
#				"step": 0.05,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_from2d.mmg
#Creates a 3D texture from a 2D texture

#		"inputs": [
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The input 2D texture",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "rgb"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The generated 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "$in($uv.xy+vec2(0.5))",
#				"type": "tex3d"
#			}
#		],

#----------------------
#tex3d_pattern.mmg
#A greyscale 3D texture that combines patterns along all 3 axes

#		"instance": "float $(name)_fct(vec3 uv) {\n\treturn mix3d_$(mix)(wave3d_$(x_wave)($(x_scale)*uv.x), wave3d_$(y_wave)($(y_scale)*uv.y), wave3d_$(z_wave)($(z_scale)*uv.z));\n}",
#		"outputs": [
#			{
#				"longdesc": "The generated 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "vec3($(name)_fct($(uv).xyz))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"default": 0,
#				"label": "Combiner",
#				"longdesc": "The operation used to combine the X, Y and Z patterns",
#				"name": "mix",
#				"shortdesc": "Combine",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Multiply",
#						"value": "mul"
#					},
#					{
#						"name": "Add",
#						"value": "add"
#					},
#					{
#						"name": "Max",
#						"value": "max"
#					},
#					{
#						"name": "Min",
#						"value": "min"
#					},
#					{
#						"name": "Xor",
#						"value": "xor"
#					},
#					{
#						"name": "Pow",
#						"value": "pow"
#					}
#				]
#			},
#			{
#				"default": 0,
#				"label": "X",
#				"longdesc": "Pattern generated along the X axis",
#				"name": "x_wave",
#				"shortdesc": "Pattern.x",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Sine",
#						"value": "sine"
#					},
#					{
#						"name": "Triangle",
#						"value": "triangle"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					},
#					{
#						"name": "Sawtooth",
#						"value": "sawtooth"
#					},
#					{
#						"name": "Constant",
#						"value": "constant"
#					},
#					{
#						"name": "Bounce",
#						"value": "bounce"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "2:",
#				"longdesc": "Repetitions of the pattern along X axis",
#				"max": 32,
#				"min": 0,
#				"name": "x_scale",
#				"shortdesc": "Repeat.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Y",
#				"longdesc": "Pattern generated along the Y axis",
#				"name": "y_wave",
#				"shortdesc": "Pattern.y",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Sine",
#						"value": "sine"
#					},
#					{
#						"name": "Triangle",
#						"value": "triangle"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					},
#					{
#						"name": "Sawtooth",
#						"value": "sawtooth"
#					},
#					{
#						"name": "Constant",
#						"value": "constant"
#					},
#					{
#						"name": "Bounce",
#						"value": "bounce"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "3:",
#				"longdesc": "Repetitions of the pattern along Y axis",
#				"max": 32,
#				"min": 0,
#				"name": "y_scale",
#				"shortdesc": "Repeat.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"default": 0,
#				"label": "Z",
#				"longdesc": "Pattern generated along the Z axis",
#				"name": "z_wave",
#				"shortdesc": "Pattern.z",
#				"type": "enum",
#				"values": [
#					{
#						"name": "Sine",
#						"value": "sine"
#					},
#					{
#						"name": "Triangle",
#						"value": "triangle"
#					},
#					{
#						"name": "Square",
#						"value": "square"
#					},
#					{
#						"name": "Sawtooth",
#						"value": "sawtooth"
#					},
#					{
#						"name": "Constant",
#						"value": "constant"
#					},
#					{
#						"name": "Bounce",
#						"value": "bounce"
#					}
#				]
#			},
#			{
#				"control": "None",
#				"default": 4,
#				"label": "4:",
#				"longdesc": "Repetitions of the pattern along Z axis",
#				"max": 32,
#				"min": 0,
#				"name": "z_scale",
#				"shortdesc": "Repeat.z",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_rotate.mmg
#Rotates a 3D texture

#		"inputs": [
#			{
#				"default": "vec3(1.0)",
#				"label": "",
#				"longdesc": "The input 3D texture",
#				"name": "in",
#				"shortdesc": "Input",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The rotated 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "$in(vec4(tex3d_rotate($uv.xyz, -vec3($ax, $ay, $az)*0.01745329251), $uv.w))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0,
#				"label": "X",
#				"longdesc": "The rotation around the X axis",
#				"max": 180,
#				"min": -180,
#				"name": "ax",
#				"shortdesc": "Rotate.x",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Y",
#				"longdesc": "The rotation around the Y axis",
#				"max": 180,
#				"min": -180,
#				"name": "ay",
#				"shortdesc": "Rotate.y",
#				"step": 1,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0,
#				"label": "Z",
#				"longdesc": "The rotation around the Z axis",
#				"max": 180,
#				"min": -180,
#				"name": "az",
#				"shortdesc": "Rotate.z",
#				"step": 1,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_select.mmg
#Selects a 3D texture for a given color index. This can be used to map several textures into a single 3D scene.

#		"code": "float $(name_uv)_d = ($uv.w-$v)/$t;",
#		"inputs": [
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture associated to the specified color index",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture(s) associated to other color indices",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "tex3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The merged 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "mix($in1($uv), $in2($uv), clamp(1.0-$(name_uv)_d*$(name_uv)_d, 0.0, 1.0))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Value",
#				"longdesc": "The value of the selected color index",
#				"max": 1,
#				"min": 0,
#				"name": "v",
#				"shortdesc": "Value",
#				"step": 0.01,
#				"type": "float"
#			},
#			{
#				"control": "None",
#				"default": 0.1,
#				"label": "Tolerance",
#				"longdesc": "The tolerance used when comparing color indices",
#				"max": 1,
#				"min": 0.01,
#				"name": "t",
#				"shortdesc": "Tolerance",
#				"step": 0.001,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_select_shape.mmg
#Selects a 3D texture inside, and another outside a shape. This can be used to map several textures into a single 3D scene.

#		"inputs": [
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture associated to the specified color index",
#				"name": "in1",
#				"shortdesc": "Input1",
#				"type": "tex3d"
#			},
#			{
#				"default": "vec3(0.5)",
#				"label": "",
#				"longdesc": "The 3D texture(s) associated to other color indices",
#				"name": "in2",
#				"shortdesc": "Input2",
#				"type": "tex3d"
#			},
#			{
#				"default": "0.0",
#				"label": "",
#				"longdesc": "The shape in which input1 is applied",
#				"name": "shape",
#				"shortdesc": "Shape",
#				"type": "sdf3d"
#			}
#		],
#		"outputs": [
#			{
#				"longdesc": "The merged 3D texture",
#				"shortdesc": "Output",
#				"tex3d": "mix($in1($uv), $in2($uv), clamp($shape($uv.xyz)/max($d, 0.0001), 0.0, 1.0))",
#				"type": "tex3d"
#			}
#		],
#		"parameters": [
#			{
#				"control": "None",
#				"default": 0.5,
#				"label": "Smoothness",
#				"longdesc": "The width of the transition area between both textures",
#				"max": 1,
#				"min": 0,
#				"name": "d",
#				"shortdesc": "Smoothness",
#				"step": 0.01,
#				"type": "float"
#			}
#		],

#----------------------
#tex3d_apply.mmg

#----------------------
#tex3d_apply.mmg

#----------------------
#tex3d_apply.mmg

#----------------------
#tex3d_apply.mmg

#vec3 blend3d_normal(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*c1 + (1.0-opacity)*c2;\n
#}

#vec3 blend3d_multiply(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*c1*c2 + (1.0-opacity)*c2;\n
#}

#vec3 blend3d_screen(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;\n
#}

#float blend3d_overlay_f(float c1, float c2) {\n\t
#	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));\n
#}

#vec3 blend3d_overlay(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_overlay_f(c1.x, c2.x), blend3d_overlay_f(c1.y, c2.y), blend3d_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}

#vec3 blend3d_hard_light(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*0.5*(c1*c2+blend3d_overlay(c1, c2, 1.0)) + (1.0-opacity)*c2;\n
#}

#float blend3d_soft_light_f(float c1, float c2) {\n\t
#	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);\n
#}
	
#vec3 blend3d_soft_light(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_soft_light_f(c1.x, c2.x), blend3d_soft_light_f(c1.y, c2.y), blend3d_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
	
#float blend3d_burn_f(float c1, float c2) {\n\t
#	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);\n
#}
	
#vec3 blend3d_burn(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_burn_f(c1.x, c2.x), blend3d_burn_f(c1.y, c2.y), blend3d_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
	
#float blend3d_dodge_f(float c1, float c2) {\n\t
#	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);\n
#}
	
#vec3 blend3d_dodge(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*vec3(blend3d_dodge_f(c1.x, c2.x), blend3d_dodge_f(c1.y, c2.y), blend3d_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;\n
#}
		
#vec3 blend3d_lighten(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*max(c1, c2) + (1.0-opacity)*c2;\n
#}
		
#vec3 blend3d_darken(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*min(c1, c2) + (1.0-opacity)*c2;
#}
		
#vec3 blend3d_difference(vec3 c1, vec3 c2, float opacity) {\n\t
#	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;\n
#}

#float rand31(vec3 p) {\n\t
#	return fract(sin(dot(p,vec3(127.1,311.7, 74.7)))*43758.5453123);\n
#}

#vec3 rand33(vec3 p) {\n\t
#	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
#		dot(p,vec3(269.5,183.3,246.1)),\n\t\t\t  
#		dot(p,vec3(113.5,271.9,124.6)));\n\n\t
#
#	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
#}
	
#float tex3d_fbm_value(vec3 coord, vec3 size, float seed) {\n\t
#	vec3 o = floor(coord)+rand3(vec2(seed, 1.0-seed))+size;\n\t
#	vec3 f = fract(coord);\n\t
#	float p000 = rand31(mod(o, size));\n\t
#	float p001 = rand31(mod(o + vec3(0.0, 0.0, 1.0), size));\n\t
#	float p010 = rand31(mod(o + vec3(0.0, 1.0, 0.0), size));\n\t
#	float p011 = rand31(mod(o + vec3(0.0, 1.0, 1.0), size));\n\t
#	float p100 = rand31(mod(o + vec3(1.0, 0.0, 0.0), size));\n\t
#	float p101 = rand31(mod(o + vec3(1.0, 0.0, 1.0), size));\n\t
#	float p110 = rand31(mod(o + vec3(1.0, 1.0, 0.0), size));\n\t
#	float p111 = rand31(mod(o + vec3(1.0, 1.0, 1.0), size));\n\t
#
#	vec3 t = f * f * (3.0 - 2.0 * f);\n\t
#
#	return mix(mix(mix(p000, p100, t.x), mix(p010, p110, t.x), t.y), mix(mix(p001, p101, t.x), mix(p011, p111, t.x), t.y), t.z);\n
#}

#float tex3d_fbm_perlin(vec3 coord, vec3 size, float seed) {\n\t
#	vec3 o = floor(coord)+rand3(vec2(seed, 1.0-seed))+size;\n\t
#	vec3 f = fract(coord);\n\t
#	vec3 v000 = normalize(rand33(mod(o, size))-vec3(0.5));\n\t
#	vec3 v001 = normalize(rand33(mod(o + vec3(0.0, 0.0, 1.0), size))-vec3(0.5));\n\t
#	vec3 v010 = normalize(rand33(mod(o + vec3(0.0, 1.0, 0.0), size))-vec3(0.5));\n\t
#	vec3 v011 = normalize(rand33(mod(o + vec3(0.0, 1.0, 1.0), size))-vec3(0.5));\n\t
#	vec3 v100 = normalize(rand33(mod(o + vec3(1.0, 0.0, 0.0), size))-vec3(0.5));\n\t
#	vec3 v101 = normalize(rand33(mod(o + vec3(1.0, 0.0, 1.0), size))-vec3(0.5));\n\t
#	vec3 v110 = normalize(rand33(mod(o + vec3(1.0, 1.0, 0.0), size))-vec3(0.5));\n\t
#	vec3 v111 = normalize(rand33(mod(o + vec3(1.0, 1.0, 1.0), size))-vec3(0.5));\n\t
#
#	float p000 = dot(v000, f);\n\tfloat p001 = dot(v001, f - vec3(0.0, 0.0, 1.0));\n\t
#	float p010 = dot(v010, f - vec3(0.0, 1.0, 0.0));\n\t
#	float p011 = dot(v011, f - vec3(0.0, 1.0, 1.0));\n\t
#	float p100 = dot(v100, f - vec3(1.0, 0.0, 0.0));\n\t
#	float p101 = dot(v101, f - vec3(1.0, 0.0, 1.0));\n\t
#	float p110 = dot(v110, f - vec3(1.0, 1.0, 0.0));\n\t
#	float p111 = dot(v111, f - vec3(1.0, 1.0, 1.0));\n\t
#
#	vec3 t = f * f * (3.0 - 2.0 * f);\n\t
#
#	return 0.5 + mix(mix(mix(p000, p100, t.x), mix(p010, p110, t.x), t.y), mix(mix(p001, p101, t.x), mix(p011, p111, t.x), t.y), t.z);
#}

#float tex3d_fbm_cellular(vec3 coord, vec3 size, float seed) {\n\t
#	vec3 o = floor(coord)+rand3(vec2(seed, 1.0-seed))+size;\n\t
#	vec3 f = fract(coord);\n\tfloat min_dist = 3.0;\n\t
#
#	for (float x = -1.0; x <= 1.0; x++) {\n\t\t
#		for (float y = -1.0; y <= 1.0; y++) {\n\t\t\t
#			for (float z = -1.0; z <= 1.0; z++) {\n\t\t\t\t
#				vec3 node = 0.4*rand33(mod(o + vec3(x, y, z), size)) + vec3(x, y, z);\n\t\t\t\t
#				float dist = sqrt((f - node).x * (f - node).x + (f - node).y * (f - node).y + (f - node).z * (f - node).z);\n\t\t\t\t
#				min_dist = min(min_dist, dist);\n\t\t\t
#			}\n\t\t
#
#		}\n\t
#
#	}\n\t
#
#	return min_dist;
#}


#float wave3d_constant(float x) {\n\t
#	return 1.0;\n
#}

#float wave3d_sine(float x) {\n\t
#	return 0.5-0.5*cos(3.14159265359*2.0*x);\n
#}

#float wave3d_triangle(float x) {\n\t
#	x = fract(x);\n\t
#	return min(2.0*x, 2.0-2.0*x);\n
#}

#float wave3d_sawtooth(float x) {\n\t
#	return fract(x);\n
#}

#float wave3d_square(float x) {\n\t
#	return (fract(x) < 0.5) ? 0.0 : 1.0;\n
#}

#float wave3d_bounce(float x) {\n\t
#	x = 2.0*(fract(x)-0.5);\n\t
#	return sqrt(1.0-x*x);\n
#}

#float mix3d_mul(float x, float y, float z) {\n\t
#	return x*y*z;\n
#}

#float mix3d_add(float x, float y, float z) {\n\t
#	return min(x+y+z, 1.0);\n
#}

#float mix3d_max(float x, float y, float z) {\n\t
#	return max(max(x, y), z);\n
#}

#float mix3d_min(float x, float y, float z) {\n\t
#	return min(min(x, y), z);\n
#}

#float mix3d_xor(float x, float y, float z) {\n\t
#	float xy = min(x+y, 2.0-x-y);\n\t
#	return min(xy+z, 2.0-xy-z);\n
#}

#float mix3d_pow(float x, float y, float z) {\n\t
#	return pow(pow(x, y), z);\n
#}

#vec3 tex3d_rotate(vec3 p, vec3 a) {\n\t
#	vec3 rv;\n\t
#	float c;\n\t
#	float s;\n\t
#	c = cos(a.x);\n\t
#	s = sin(a.x);\n\t
#	rv.x = p.x;\n\t
#	rv.y = p.y*c+p.z*s;\n\t
#	rv.z = -p.y*s+p.z*c;\n\t
#	c = cos(a.y);\n\t
#	s = sin(a.y);\n\t
#	p.x = rv.x*c+rv.z*s;\n\t
#	p.y = rv.y;\n\t
#	p.z = -rv.x*s+rv.z*c;\n\t
#	c = cos(a.z);\n\t
#	s = sin(a.z);\n\t
#	rv.x = p.x*c+p.y*s;\n\t
#	rv.y = -p.x*s+p.y*c;\n\t
#	rv.z = p.z;\n\t
#	return rv;\n
#}
