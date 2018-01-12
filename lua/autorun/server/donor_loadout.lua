local pistols = false
local primaries = false
local grenades = false

local function loadWeapons()
	pistols = {}
	primaries = {}
	grenades = {}

	local sweps = ents.TTT.GetSpawnableSWEPs()

	for _, swep in ipairs(sweps) do
		if swep.Kind == WEAPON_PISTOL then
			table.insert(pistols, swep.ClassName)
		elseif swep.Kind == WEAPON_HEAVY then
			table.insert(primaries, swep.ClassName)
		elseif swep.Kind == WEAPON_NADE then
			table.insert(grenades, swep.ClassName)
		end
	end
end

local function getAmmoType(class)
	local swep = weapons.Get(class)
	local ammoType = swep.Primary.Ammo
	local ammoMax = 0
	if scripted_ents.Get(swep.AmmoEnt) then
		ammoMax = scripted_ents.Get(swep.AmmoEnt).AmmoMax
	end

	return ammoType, ammoMax
end

local function playerLoadout(ply)
	-- Load the weapons if we haven't
	if not pistols then
		loadWeapons()
	end

	if (ply.isVIP and ply:isVIP()) or ply:query("donorloadout") then
		local ammo = {}

		-- Spawn a pistol
		local class = "weapon_zm_revolver"
		local ammoType, ammoMax = getAmmoType(class)
		ammo[ammoType] = ammoMax
		ply:Give(class)

		-- Spawn a primary
		class = table.Random(primaries)
		ammoType, ammoMax = getAmmoType(class)
		ammo[ammoType] = ammoMax
		ply:Give(class)

		-- Spawn a grenade
		ply:Give(table.Random(grenades))

		-- Spawn in ammo
		for ammoType, ammoMax in pairs(ammo) do
			ply:GiveAmmo(ammoMax, ammoType, true)
		end

        -- Set lightsaber
        ply:StripWeapon("weapon_zm_improvised")
        ply:Give("weapon_ttt_lightsaber_green")
	else
		-- Spawn a pistol
		local class = table.Random(pistols)
		ply:Give(class)
	end
end
hook.Add("PlayerLoadout", "DonorLoadout", playerLoadout)
