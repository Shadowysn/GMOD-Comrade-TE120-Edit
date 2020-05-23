if CLIENT then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local ball_model = Model("models/effects/combineball.mdl")
local ball_trail = "sprites/combineball_trail_black_1.vmt"

function ENT:Initialize()
	self.Entity:SetModel(ball_model)
	self.Entity:EmitSound("NPC_GravityBall.Launch")
	self.Entity:PhysicsInitSphere(self.flRadius, "default")
	local ent_phys =self.Entity:GetPhysicsObject()
	if IsValid(ent_phys) then
		ent_phys:Wake()
		ent_phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
		ent_phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		ent_phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
	end
end