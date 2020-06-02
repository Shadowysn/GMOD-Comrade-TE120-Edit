
AddCSLuaFile()



DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= "Energy ball"
ENT.Author			= "Comrade Communist"
ENT.Information		= "None"
ENT.Category        = "Combine Ballsu"

ENT.Editable			= false
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.RenderGroup 		= RENDERGROUP_BOTH



-- This is the spawn function. It's called when a client calls the entity to be spawned.
-- If you want to make your SENT spawnable you need one of these functions to properly create the entity
--
-- ply is the name of the player that is spawning it
-- tr is the trace from the player's eyes 
--

function ENT:SpawnFunction( ply, tr )
local DEBall2 = ents.Create( "prop_combine_ball" )
DEBall2:SetPos( tr.HitPos + Vector(0,0,50) )

DEBall2:Spawn()

DEBall2:SetNWEntity("BallOwner2",ply)
DEBall2:SetSaveValue('m_nMaxBounces',7)
DEBall2:SetSaveValue('m_flRadius',12)
DEBall2:SetSaveValue('m_nBounceCount',7)
DEBall2:Activate()
DEBall2:SetPhysicsAttacker( ply )
local phys = DEBall2:GetPhysicsObject()
if IsValid(phys) then
        phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
        phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
end
DEBall2:SetModel( "" )
DEBall2.IsCBBall = true
return DEBall2
end

function ENT:Initialize()
  

	if ( SERVER ) then
              


	
		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/props_junk/garbage_takeoutcarton001a.mdl" )

		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( 5, "metal_bouncy" )

		self.Entity:PhysicsInit( SOLID_VPHYSICS )
        self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
        self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
	    phys:Wake()
        phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
        phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )

		end
		

		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -10, -10, -10 ), Vector( 10, 10, 10 ) )

	else 
	
		self.LightColor = Vector( 0, 0, 0 )
	
	end
end

function ENT:OnBallSizeChanged( varname, oldvalue, newvalue )

end


function ENT:DissolveEntity(ent,ball)
local entnametodissolve = "entname" .. ent:EntIndex()
ent:SetKeyValue("targetname",entnametodissolve)
local dissolver = ents.Create("env_entity_dissolver")
dissolver:SetPos(ent:GetPos())
dissolver:SetKeyValue("target", entnametodissolve)
dissolver:Spawn()
dissolver:SetOwner(ball:GetOwner() or ball:GetNWEntity("BallOwner2"))
dissolver:SetKeyValue("dissolvetype",1)
dissolver:Fire("Dissolve", entnametodissolve, 0)
dissolver:Fire("kill", "", 0.1)
end


--[[---------------------------------------------------------
   Name: PhysicsCollide
-----------------------------------------------------------]]
function ENT:PhysicsCollide( data, physobj )
if CLIENT then return end
if data.HitEntity:IsWorld() then


local physexplode = ents.Create("env_physexplosion")
physexplode:SetPos(self:GetPos())
physexplode:SetKeyValue("magnitude", 500)
physexplode:SetKeyValue("radius", 350)
physexplode:SetKeyValue("spawnflags", "1")

physexplode:Spawn()
physexplode:Fire("Explode", "", 0)
physexplode:Fire("kill", "", 0.02)

self:Remove()
end
end

--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )


	self:TakePhysicsDamage( dmginfo )
	
end

if CLIENT then
local ballsprite1 = Material("effects/ar2_altfire1b")
local ballsprite2 = Material("effects/ar2_altfire1")
local coremat = Material("effects/combinemuzzle1")

function ENT:Draw()
	--if self:IsPlayerHolding() then --Server side :\
		--self:DrawModel()
	--end
	
	local MyPos = self:GetPos()
	local size = 24

	render.SetMaterial(ballsprite1)
	render.DrawSprite(MyPos, size/200, size/200, Color(255,155,255,255))
	render.SetMaterial(ballsprite2)
	render.DrawSprite(MyPos, size/200, size/200, Color(255,255,255,255))
	render.SetMaterial(coremat)
	render.DrawSprite(MyPos, size/200, size/200, Color(250,110,250,255))
end

end

--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )

end

function ENT:OnRemove()
timer.Remove("tesladisp" .. self.Entity:EntIndex())
end

function ENT:Think()
if CLIENT then return end
for k,v in pairs(ents.FindInSphere(self:GetPos(),10)) do
if IsValid(v:GetPhysicsObject()) and (v != self.Entity and v != self.Entity:GetOwner() ) then
if v:IsPlayer() then
local dmginfo = DamageInfo()
dmginfo:SetDamage(v:Health() or 100)
dmginfo:SetDamageType( DMG_DISSOLVE )
if IsValid(self.Entity:GetOwner()) then
dmginfo:SetAttacker(self.Entity:GetNWEntity("BallOwner2"))
elseif IsValid(self.Entity:GetNWEntity("BallOwner2")) then
dmginfo:SetAttacker(self.Entity:GetNWEntity("BallOwner2"))
else
game.GetWorld()
end
dmginfo:SetDamageForce((self.Entity:GetPos() - v:GetPos())*-200) 
if IsValid(self.Entity) then
dmginfo:SetInflictor( self.Entity )
else
dmginfo:SetInflictor( game.GetWorld() )
end

else
if IsValid(v:GetPhysicsObject()) then
if self.Entity.GetShootVector != nil then
v:GetPhysicsObject():SetVelocity(self.Entity.GetShootVector*1 + VectorRand()*2)
else
v:GetPhysicsObject():SetVelocity(VectorRand()*1)
end
end

end
end
end

		for k,v in pairs(ents.FindInSphere(self:GetPos(),10)) do
	if SERVER and IsValid(self) and (v:IsNPC() or type( v ) == "NextBot" ) and v != self and v != self.nowner then

	self:Explosion()

	break

	end
	end
                if self.Entity.GetShootVector != nil then
                ent = self.Entity
				local PhysObj = ent:GetPhysicsObject()
				if PhysObj:IsValid()then
					PhysObj:EnableGravity(false)
					PhysObj:SetVelocity(self.Entity.GetShootVector*10)
				end
                                end
self.Entity:NextThink( CurTime() + 0.01 )
return true
end

function ENT:Explosion()

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())


		

	util.BlastDamage(self.Entity, self:OwnerCheck(), self.Entity:GetPos(), 100, 185)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "80")	// Power of the shake
		shake:SetKeyValue("radius", "15")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)




	self.Entity:Remove()
end

function ENT:OwnerCheck()
	if IsValid(self.Owner) then
		return (self.Owner)
	else
		return (self.Entity)
	end
end