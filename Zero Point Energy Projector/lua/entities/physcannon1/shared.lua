ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Energy Projector"
ENT.Category		= "Half-Life 2"

ENT.Spawnable		= true
ENT.AdminOnly = false
ENT.DoNotDuplicate = true

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create("Physcannon1")
	
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent.Planted = false
	
	return ent
end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	local model = ("models/weapons/te120/w_superphyscannon1.mdl")
	
	self.Entity:SetModel(model)
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(true)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.Entity:SetUseType(SIMPLE_USE)
end


/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, physobj)
	
	// Play sound on bounce
	if (data.Speed > 80 and data.DeltaTime > 0.2) then
		self.Entity:EmitSound("Default.ImpactSoft")
	end
end

/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use(activator, caller)

	
	if (activator:IsPlayer()) and not self.Planted then
		activator:Give("te120_phys")
		self.Entity:Remove()
	end
end

end

if CLIENT then

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
local Mat = Material( "sprites/blueflare1" )
Mat:SetInt("$spriterendermode",5)
local Zap = Material( "sprites/purplelaser1" )
Zap:SetInt("$spriterendermode",5)
	self.Entity:DrawModel()
	
	local ledcolor = Color(230, 45, 45, 255)

  	local TargetPos = self.Entity:GetPos() + (self.Entity:GetUp() * 11.6) + (self.Entity:GetRight() * 2) + (self.Entity:GetForward() * 1.5)

	local FixAngles = self.Entity:GetAngles()
	local FixRotation = Vector(90, 90, 90)
	
	FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
	FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
	FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

	local scale = math.Rand( 8, 10 )
	local scale2 = math.Rand( 25, 27 )
	local scale3 = math.Rand( 3, 4 )
	local scale7 = math.Rand( 12, 14 )
	
	local StartPos 		= self.Entity:GetPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	render.SetMaterial( Mat )
		
		local vm = self.Entity
		if (!vm || vm == NULL) then return end
		
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID2=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID2 )
		StartPosO = attachment_O.Pos
		
		local attachmentID3=vm:LookupAttachment("fork2t")
		local attachment_L = vm:GetAttachment( attachmentID3 )
		StartPosL = attachment_L.Pos
		
		local attachmentID4=vm:LookupAttachment("fork3t")
		local attachment_R = vm:GetAttachment( attachmentID4 )
		StartPosR = attachment_R.Pos
		
		local attachmentID5=vm:LookupAttachment("fork1m")
		local attachment_OH = vm:GetAttachment( attachmentID5 )
		StartPosOH = attachment_OH.Pos
		
		local attachmentID6=vm:LookupAttachment("fork2m")
		local attachment_LH = vm:GetAttachment( attachmentID6 )
		StartPosLH = attachment_LH.Pos
		
		local attachmentID7=vm:LookupAttachment("fork3m")
		local attachment_RH = vm:GetAttachment( attachmentID7 )
		StartPosRH = attachment_RH.Pos
		
		render.DrawSprite( StartPos, scale7, scale7, Color(255,150,150,240))
		render.DrawSprite( StartPosO, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosL, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosR, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosOH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosLH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosRH, scale3, scale3, Color(255,150,150,80))
end

end