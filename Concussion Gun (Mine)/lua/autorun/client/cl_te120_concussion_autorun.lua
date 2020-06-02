hook.Add("Think", "Grav_Disable_Claw_Bug", function() 
	local grav = LocalPlayer():GetWeapon("weapon_physcannon")
	if IsValid(grav) then
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physcannon" then
		grav:SetNextClientThink(CurTime())
		else
		grav:SetNextClientThink(CurTime() + 0.2)
		end
	end
end)

--[[local function AUXExists(owner)
	local suit_aux = owner:GetSuitPower()
	if owner:IsSuitEquipped() and suit_aux != nil and suit_aux > 0 then
		return true
	end
	return false
end--]]

local function ScreenScaleH(n)
	return n * (ScrH() / 480)
end

surface.CreateFont("TE120_ConcussGun_Font", {
	font = "HalfLife2",
	size = ScreenScaleH(64),
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	additive = true,
})

surface.CreateFont("TE120_ConcussGun_Font_Glow", {
	font = "HalfLife2",
	size = ScreenScaleH(64),
	weight = 0,
	blursize = ScreenScaleH(4),
	scanlines = 3,
	antialias = true,
	additive = true,
})

killicon.AddFont( "weapon_physconcussion", "HL2MPTypeDeath", ",", Color( 255, 80, 0, 255 ) )