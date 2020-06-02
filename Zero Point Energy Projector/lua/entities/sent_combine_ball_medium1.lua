AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Energy ball"
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

end

function ENT:Initialize()
	if ( SERVER ) then
		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/props_junk/garbage_takeoutcarton001a.mdl" )
		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( 30, "metal_bouncy" )
		
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
        self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
        self.Entity:SetSolid( SOLID_VPHYSICS )
		--self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
	    phys:Wake()
        phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
        phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -30, -30, -30 ), Vector( 30, 30, 30 ) )
		
		self.Entity:DrawShadow(false)
		
		timer.Simple(2, function() 
			if IsValid(self) and !self.Collided then
				local fakedata = {
					HitPos = self:GetPos()
				}
				self:Explosion(fakedata)
			end
		end)
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
	if self.Collided == true then return end
	if data.HitEntity then
		self:Explosion(data)
		--if data.HitEntity:IsWorld() or data.HitEntity then
		--[[self.Collided = true
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
		self:EmitSound("NPC_CombineBall.Impact")
		self:GetPhysicsObject():EnableMotion( false )
		timer.Simple(0.40, function()
			if !IsValid(self.Entity) then return end
			self.Entity:Remove()
		end )
		util.BlastDamage(self.Entity, self:OwnerCheck(), self.Entity:GetPos(), 80, 0) -- 485
		for _,ent in pairs( ents.FindInSphere(self.Entity:GetPos(), 150) ) do -- this is better gameplay-wise as it doesn't hurt the wielder, but won't affect clientside ragdolls
			if IsValid(ent) and ent != self.Owner and ent:Health() > 0 then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(500-( (ent:GetPos()-self:GetPos()):Length()*4.8 ) )
				dmginfo:SetDamageType( DMG_PHYSGUN )
				--dmginfo:SetDamageForce(data.HitPos)
				dmginfo:SetDamageForce(data.HitPos)
				dmginfo:SetDamagePosition(data.HitPos)
				dmginfo:SetReportedPosition(data.HitPos)
				dmginfo:SetAttacker(self:OwnerCheck())
				--if self:OwnerCheck()!=self.Entity then
				--dmginfo:SetInflictor(self.Owner:GetWeapon("te120_phys"))
				--else
				dmginfo:SetInflictor(self:OwnerCheck())
				--end
				ent:TakeDamageInfo(dmginfo)
			end
		end
		--self:Remove()
		--local effectdata = EffectData()
		--effectdata:SetOrigin(self.Entity:GetPos())	
		--util.Effect("cball_explode", effectdata, false)
	end
	
	local inradius = ents.FindInSphere(data.HitPos, 150)
	
	for key, ent in ipairs(inradius) do
		if IsValid(ent) and ent:GetClass() != "sent_combine_ball_medium1" then
			local x = (ent:GetPos().x - data.HitPos.x) * (650 / data.HitPos:Distance(ent:GetPos()))
			local y = (ent:GetPos().y - data.HitPos.y) * (650 / data.HitPos:Distance(ent:GetPos()))
			local z = (ent:GetPos().z - data.HitPos.z + 0) * (650 / data.HitPos:Distance(ent:GetPos()))
			
			if ent:GetPhysicsObject():IsValid() then
				ent:GetPhysicsObject():SetVelocity(Vector(x, y, z))
			elseif !ent:GetPhysicsObject():IsValid() then
				ent:SetVelocity(Vector(x, y, z))
			end
			if (!ent:IsPlayer() and !ent:IsNPC() and type( ent ) != "NextBot" and ent:GetOwner()!=(self:GetOwner() or self:GetNWEntity("BallOwner2")) ) and ent:GetMoveType()==MOVETYPE_VPHYSICS and self.Owner:IsValid() then
				self.Owner:SimulateGravGunPickup(ent)
				--timer.Simple(0.02, function()
				self.Owner:SimulateGravGunDrop(ent)
				--end )
			end
		end--]]
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
	local size = math.Rand(20, 28)

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
	if self.Collided then return end
	
	for k,v in pairs(ents.FindInSphere(self:GetPos(),10)) do
		if IsValid(v:GetPhysicsObject()) and (v != self.Entity and v != self.Entity:GetOwner() ) then
			if v:IsPlayer() then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(v:Health() or 100)
				dmginfo:SetDamageType( DMG_PHYSGUN )
				if IsValid(self.Entity:GetOwner()) then
				dmginfo:SetAttacker(self.Entity:GetNWEntity("BallOwner2"))
				elseif IsValid(self.Entity:GetNWEntity("BallOwner2")) then
				dmginfo:SetAttacker(self.Entity:GetNWEntity("BallOwner2"))
				end
				dmginfo:SetDamageForce((self.Entity:GetPos() - v:GetPos())*-2) 
				if IsValid(self.Entity) then
				dmginfo:SetInflictor( self.Entity )
				else
				dmginfo:SetInflictor( game.GetWorld() )
				end
				v:TakeDamageInfo( dmginfo )
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

		--[[for k,v in pairs(ents.FindInSphere(self:GetPos(),5)) do
	if SERVER and IsValid(self) and 
	(v:IsNPC() or type( v ) == "NextBot" ) and--or v:IsSolid() ) and 
	v != self and v != self:OwnerCheck() then

	self:Explosion()

	break

	end
	end--]]
	if self.Entity.GetShootVector != nil then
		ent = self.Entity
		if !IsValid(self.DangerAISound) then
			--[[local trace = util.TraceLine({
				start = self.Entity:GetPos(),
				endpos = self.Entity:GetPos() + self.Entity:GetAngles():Forward() * 10000,
				filter = { self.Entity, player },
				collisiongroup = COLLISION_GROUP_WEAPON
			})
			print(trace.HitPos)
			if trace.HitWorld or IsValid(trace.HitEntity) then
				self.DangerAISound = ents.Create("ai_sound")
				self.DangerAISound:SetPos(trace.HitPos)
				self.DangerAISound:SetKeyValue("volume", 100)
				self.DangerAISound:SetKeyValue("duration", 100)
				self.DangerAISound:SetKeyValue("soundtype", 8)
				--self.DangerAISound:SetKeyValue("soundcontext", 134217728)
				self.DangerAISound:Spawn()
				self.Entity:DeleteOnRemove(self.DangerAISound)
				self.DangerAISound:Fire("EmitAISound", "", 0)
				print(trace.HitWorld)
				print(trace.HitEntity)
			end--]]
			self.DangerAISound = ents.Create("ai_sound")
			self.DangerAISound:SetPos(self.Entity:GetPos())
			self.DangerAISound:SetParent(self.Entity)
			self.DangerAISound:SetKeyValue("volume", 250)
			self.DangerAISound:SetKeyValue("duration", 1)
			self.DangerAISound:SetKeyValue("soundtype", 8)
			self.DangerAISound:SetKeyValue("soundcontext", 134217728)
			self.DangerAISound:Spawn()
			self.Entity:DeleteOnRemove(self.DangerAISound)
			--self.DangerAISound:Fire("EmitAISound", "", 0)
		else
			for _,ent in pairs( ents.FindInSphere(self.Entity:GetPos(), 350) ) do 
				if IsValid(ent) and ent:IsNPC() then
					self.DangerAISound:Fire("EmitAISound", "", 0)
				end
			end
		end
		
		local PhysObj = ent:GetPhysicsObject()
		if PhysObj:IsValid()then
			PhysObj:EnableGravity(false)
			--PhysObj:SetVelocity(self.Entity.GetShootVector*1000)
			--[[if IsValid(self.Owner) and self.Owner:Alive() then
			local getvel = self.Owner:GetVelocity()
			PhysObj:SetVelocity(self.Entity.GetShootVector*1000)
			else--]]
			PhysObj:SetVelocity(self.Entity.GetShootVector*1000 + self.Entity.GetOwnerVelocity)
			--end
		end
	end
	self.Entity:NextThink( CurTime() + 0.01 )
	return true
end

function ENT:Explosion(data)
	--PrintTable(data)
	self.Collided = true
	--[[local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "800")	// Power of the shake
		shake:SetKeyValue("radius", "550")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)--]]
	
	local proj = ents.Create("light_dynamic")
	proj:SetPos( self:GetPos() )
	proj:SetOwner( self:GetOwner() or self:GetNWEntity("BallOwner2") )
	proj:Spawn()
	proj:SetKeyValue( "_light", "255 200 200 255" )  
	proj:SetKeyValue("distance", "300" )
	proj:Fire( "Kill", 0.2, 0.2 )
	
	local effect = ents.Create("prop_combine_ball")
	effect:SetPos( self:GetPos() )
	--effect:SetOwner( self:GetOwner()  or self:GetNWEntity("BallOwner2") )
	effect:SetNWBool("te120_ball_effect",true)
	effect:Spawn()
	effect:Fire( "explode", 0, 0 )
	--effect:Remove()
	
	local phys_exp = ents.Create("env_physexplosion")
	phys_exp:SetPos(self:GetPos())
	phys_exp:SetKeyValue("magnitude", 500)
	--phys_exp:SetKeyValue("radius", 350)
	phys_exp:SetKeyValue("radius", 350)
	phys_exp:SetKeyValue("spawnflags", bit.bor(1))
	phys_exp:Spawn()
	phys_exp:Fire("Explode", "", 0)
	phys_exp:Fire("kill", "", 1)
	
	--util.BlastDamage(self.Entity, self:OwnerCheck(), self.Entity:GetPos(), 80, 0) -- 485
	for _,ent in pairs( ents.FindInSphere(self.Entity:GetPos(), 150) ) do -- this is better gameplay-wise as it doesn't hurt the wielder, but won't affect clientside ragdolls
		if IsValid(ent) and ent != self.Owner and ent:Health() > 0 then
			local x = (ent:GetPos().x - data.HitPos.x) * (650 / data.HitPos:Distance(ent:GetPos()))
			local y = (ent:GetPos().y - data.HitPos.y) * (650 / data.HitPos:Distance(ent:GetPos()))
			local z = (ent:GetPos().z - data.HitPos.z + 0) * (650 / data.HitPos:Distance(ent:GetPos()))
			
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(500-( (ent:GetPos()-self:GetPos()):Length()*4.8 ) )
			dmginfo:SetDamageType( DMG_PHYSGUN )
			dmginfo:SetDamageForce(data.HitPos)
			dmginfo:SetDamagePosition(data.HitPos)
			dmginfo:SetReportedPosition(data.HitPos)
			dmginfo:SetAttacker(self:OwnerCheck())
			--if self:OwnerCheck()!=self.Entity then
			--dmginfo:SetInflictor(self.Owner:GetWeapon("te120_phys"))
			--else
			dmginfo:SetInflictor(self:OwnerCheck())
			--end
			ent:TakeDamageInfo(dmginfo)
		end
	end
	local explosion = ents.Create("env_explosion") -- This creates a no-particle explosion that affects clientside props, ragdolls .etc
	explosion:SetPos(self:GetPos())
	explosion:SetKeyValue("imagnitude", 500)
	explosion:SetKeyValue("spawnflags", bit.bor(1,2,4,16,64,512))
	--explosion:SetKeyValue("radius", 350)
	explosion:SetKeyValue("radius", 350)
	explosion:Spawn()
	explosion:Fire("Explode", "", 0.02)
	explosion:Fire("Explode", "", 0.03)
	explosion:Fire("Explode", "", 0.04)
	explosion:Fire("kill", "", 1)
	
	local inradius = ents.FindInSphere(data.HitPos, 150) --250
	
	for key, ent in ipairs(inradius) do
		if IsValid(ent) and ent:GetClass() != "sent_combine_ball_medium1" then
			local x = (ent:GetPos().x - data.HitPos.x) * (650 / data.HitPos:Distance(ent:GetPos()))
			local y = (ent:GetPos().y - data.HitPos.y) * (650 / data.HitPos:Distance(ent:GetPos()))
			local z = (ent:GetPos().z - data.HitPos.z + 0) * (650 / data.HitPos:Distance(ent:GetPos()))
			
			local prev_vel = ent:GetVelocity()
			if ent != self and ent == (self:OwnerCheck()) and prev_vel.z < -100 then
				ent:SetVelocity(Vector(0, 0, -prev_vel.z+100))
			elseif ent != self and ent == (self:OwnerCheck()) and prev_vel.z >= -100 then
				ent:SetVelocity(Vector(0, 0, prev_vel.z+600))
			--elseif ent:IsRagdoll() and IsValid(ent:GetPhysicsObject()) then
			--	ent:GetPhysicsObject():SetVelocity(Vector(x*4, y*4, z*4))
			--elseif IsValid(ent:GetPhysicsObject()) then
			--	ent:GetPhysicsObject():SetVelocity(Vector(x, y, z))
			--else
				--ent:SetVelocity(Vector(x, y, z))
			end
			if (!ent:IsPlayer() and !ent:IsNPC() and type( ent ) != "NextBot" and ent:GetOwner()!=(self:GetOwner() or self:GetNWEntity("BallOwner2")) ) 
			and ent:GetMoveType()==MOVETYPE_VPHYSICS and IsValid(self.Owner) and 
			(!ent:IsRagdoll() or (ent:GetModel() != "models/combine_soldier.mdl" and ent:GetModel() != "models/combine_super_soldier.mdl")) then
				self.Owner:SimulateGravGunPickup(ent)
				--timer.Simple(0.02, function()
				self.Owner:SimulateGravGunDrop(ent)
				--end )
			end
		end
	end
	
	self:EmitSound("te_ball", 75, 100, 0.5)
	self:EmitSound("NPC_CombineBall.Impact")
	self:GetPhysicsObject():EnableMotion(false)
	
	timer.Simple(0.40, function()
		if !IsValid(self.Entity) then return end
		self.Entity:Remove()
	end)
end

function ENT:OwnerCheck()
	if IsValid(self.Owner) then
		return (self.Owner)
	else
		return (self.Entity)
	end
end