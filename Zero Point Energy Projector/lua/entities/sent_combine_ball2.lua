
AddCSLuaFile()



DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= "Combine Energy ball"
ENT.Author			= "Comrade Communist"
ENT.Information		= "None"
ENT.Category        = "Combine Balls"

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
DEBall2:SetModel( "models/weapons/te120/combineball_b.mdl" )
DEBall2.IsCBBall = true
return DEBall2
end

function ENT:Initialize()
        timer.Create("tesladisp" .. self.Entity:EntIndex(),0.2,0,function()
		if IsValid(self.Entity) then
		local effectdata = EffectData()
	    effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,0) )
	    effectdata:SetStart( self.Entity:GetPos() )
	    effectdata:SetMagnitude(50)
	    effectdata:SetEntity( self.Entity )

		end
		end)

	if ( SERVER ) then
              


	
		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/props_junk/garbage_takeoutcarton001a.mdl" )

		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( 5, "metal_bouncy" )
		
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
        self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
        self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
		
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
proj = ents.Create("light_dynamic")
proj:SetPos( self:GetPos() )
proj:SetOwner( self:GetOwner() or self:GetNWEntity("BallOwner2") )
proj:Spawn()
proj:SetKeyValue( "_light", "255 200 200 255" )  
proj:SetKeyValue("distance", "300" )
proj:Fire( "Kill", 0.2, 0.2 )


proj = ents.Create("prop_combine_ball")
proj:SetPos( self:GetPos() )
proj:SetOwner( self:GetOwner()  or self:GetNWEntity("BallOwner2") )
proj:Spawn()
proj:Fire( "explode", 0, 0 )
local physexplode = ents.Create("env_physexplosion")
physexplode:SetPos(self:GetPos())
physexplode:SetKeyValue("magnitude", 500)
physexplode:SetKeyValue("radius", 350)
physexplode:SetKeyValue("spawnflags", "1")
physexplode:Spawn()
physexplode:Fire("Explode", "", 0)
physexplode:Fire("kill", "", 0.02)
self:EmitSound("te_ball")
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
local ballsprite1 = Material("models/effects/ar2_altfire2b")
local ballsprite2 = Material("models/effects/ar2_altfire2")
local coremat = Material("models/effects/combinemuzzle1b_nocull")

function ENT:Draw()
	--if self:IsPlayerHolding() then --Server side :\
		--self:DrawModel()
	--end
	
	local MyPos = self:GetPos()
	local size = 24

	render.SetMaterial(ballsprite1)
	render.DrawSprite(MyPos, size, size, Color(255,255,255,255))
	render.SetMaterial(ballsprite2)
	render.DrawSprite(MyPos, size, size, Color(255,255,255,255))
	render.SetMaterial(coremat)
	render.DrawSprite(MyPos, size/2, size/2, Color(255,255,255,255))

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
v:TakeDamageInfo( dmginfo )
else
if IsValid(v:GetPhysicsObject()) then
if self.Entity.GetShootVector != nil then
v:GetPhysicsObject():SetVelocity(self.Entity.GetShootVector*1000 + VectorRand()*200)
else
v:GetPhysicsObject():SetVelocity(VectorRand()*10000)
end
end
self:DissolveEntity(v,self.Entity)
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
					PhysObj:SetVelocity(self.Entity.GetShootVector*100000)
				end
                                end
self.Entity:NextThink( CurTime() + 0.01 )
return true
end

function ENT:Explosion()

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())

		util.Effect("fear_exp", effectdata)

		

	util.BlastDamage(self.Entity, self:OwnerCheck(), self.Entity:GetPos(), 10, 485)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "1000")	// Power of the shake
		shake:SetKeyValue("radius", "750")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
		
	local	proj = ents.Create("light_dynamic")
proj:SetPos( self:GetPos() )
proj:SetOwner( self:GetOwner() or self:GetNWEntity("BallOwner2") )
proj:Spawn()
proj:SetKeyValue( "_light", "255 200 200 255" )  
proj:SetKeyValue("distance", "300" )
proj:Fire( "Kill", 0.2, 0.2 )


proj = ents.Create("prop_combine_ball")
proj:SetPos( self:GetPos() )
proj:SetOwner( self:GetOwner()  or self:GetNWEntity("BallOwner2") )
proj:Spawn()
proj:Fire( "explode", 0, 0 )
proj:Remove()
	local explosion = ents.Create("env_physexplosion")
	explosion:SetPos(self:GetPos())
explosion:SetKeyValue("magnitude", 500)
explosion:SetKeyValue("radius", 350)
explosion:SetKeyValue("spawnflags", "1")
explosion:Spawn()
explosion:Fire("Explode", "", 10)
explosion:Fire("kill", "", 0.02)
		self:Remove()



end

function ENT:OwnerCheck()
	if IsValid(self.Owner) then
		return (self.Owner)
	else
		return (self.Entity)
	end
end