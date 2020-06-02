if SERVER then return end

include ("shared.lua")

SWEP.Category =			"Transmissions: Element 120"

SWEP.PrintName			= "ZERO-POINT ENERGY PROJECTOR\n(GRAVITY CONCUSSION GUN) "

SWEP.Slot				= 0
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair 		= true

--SWEP.Purpose			= ""
--SWEP.Instructions		= ""
SWEP.BounceWeaponIcon	= false
SWEP.DrawWeaponInfoBox	= false

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetTextColor(255, 235, 0, alpha)
	
	surface.SetFont("TE120_ConcussGun_Font")
	local w, h = surface.GetTextSize("m")
	
	surface.SetTextPos(x + (wide / 2) - (w / 2), y + (tall / 2) - (h / 2))
	surface.DrawText("m")
	
	surface.SetTextPos(x + (wide / 2) - (w / 2), y + (tall / 2) - (h / 2))
	surface.SetFont("TE120_ConcussGun_Font_Glow")
	surface.DrawText("m")
end

include("cl_glow_spr.lua")