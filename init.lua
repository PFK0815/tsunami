local WATER_VISC = 1
local USE_TEXTURE_ALPHA = true

if minetest.features.use_texture_alpha_string_modes then
	USE_TEXTURE_ALPHA = "blend"
end

minetest.register_node("tsunami:source", {
	description = "Tsunami Source",
	drawtype = "liquid",
	waving = 10,
	tiles = {
		{name="default_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=5.0}}
	},
	special_tiles = {
		{
			name="default_water_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=5.0},
			backface_culling = false,
		}
	},
	is_ground_content = false,
	use_texture_alpha = USE_TEXTURE_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 4,
	liquidtype = "source",
	liquid_alternative_flowing = "tsunami:source",
	liquid_alternative_source = "tsunami:source",
	liquid_viscosity = 1,
	liquid_range = 7,
	post_effect_color = {a=60, r=0x03, g=0x3C, b=0x5C},
	groups = { water=3, liquid=3, puts_out_fire=1, freezes=0, not_in_creative_inventory=0, dig_by_piston=1},
})

local function disable_tsunami_blocks(radius)
	local tsunamis_removed = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		local radius = radius
		if radius > 500 then
			radius = 500
		end

		for x = pos.x - radius, pos.x + radius do
			for y = pos.y - radius, pos.y + radius do
				for z = pos.z - radius, pos.z + radius do
					local node_pos = {x = x, y = y, z = z}
					local node = minetest.get_node(node_pos)

					if node.name == "tsunami:source" or node.name == "tsunami:flowing" then
						minetest.remove_node(node_pos)
						tsunamis_removed = tsunamis_removed + 1
					end
				end
			end
		end
	end

	return tsunamis_removed
end

minetest.register_chatcommand("anti_tsunami", {
	description = "Disable all tsunami blocks",
	privs = {interact=true}, 
	func = function(name, param)
		if not string.match(param, "^%d+$") then
			return true, "Please use valid radius for param!"
		end
		local count = disable_tsunami_blocks(tonumber(param))
		return true, count .. " tsunami blocks removed."
	end,
})
