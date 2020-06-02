AddCSLuaFile("entities/rocketjump_rocket/cl_init.lua")
AddCSLuaFile("entities/rocketjump_rocket/shared.lua")

include("entities/rocketjump_rocket/shared.lua")

function ENT:Initialize()

	self:SetModel("models/weapons/w_missile_closed.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetCustomCollisionCheck(true)
	
	local phys	= self:GetPhysicsObject()
	
	if(phys:IsValid()) then
	
		phys:Wake()
		phys:EnableGravity(false)
		phys:EnableDrag(false) 
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0)
	end
end

function ENT:Think()
	
	self:GetPhysicsObject():Wake()
end

function GAMEMODE:ShouldCollide(ent1, ent2)
	
	if ent1:GetClass() == "jump_cannon" and ent2:GetClass() == "jump_cannon" then
		return false
	else
		return true
	end
end

function ENT:PhysicsCollide(data, phys)
	
	local inradius = ents.FindInSphere(data.HitPos, 150)
	
	for key, ent in ipairs(inradius) do
		if ent:GetClass() != "jump_cannon" then
			if ent:IsValid() then
				local x = (ent:GetPos().x - data.HitPos.x) * (500 / data.HitPos:Distance(ent:GetPos()))
				local y = (ent:GetPos().y - data.HitPos.y) * (500 / data.HitPos:Distance(ent:GetPos()))
				local z = (ent:GetPos().z - data.HitPos.z + 3) * (500 / data.HitPos:Distance(ent:GetPos()))
			
				ent:SetVelocity(Vector(x, y, z))
				if ent:GetPhysicsObject():IsValid()  then
					ent:GetPhysicsObject():SetVelocity(Vector(x, y, z))
				end
			end
		end
	end
	
	local explode = ents.Create("env_explosion")
	if !IsValid(explode) then return end
	
	explode:SetPos(data.HitPos)
	
	explode:SetKeyValue("Radius Override", 0)
	explode:SetKeyValue("spawnflags", 1)
	
	explode:Spawn()
	explode:Activate()
	
	explode:Fire("Explode", "", 0)
	explode:Fire("Kill", "", 1)
	
	self:Remove()
	
end