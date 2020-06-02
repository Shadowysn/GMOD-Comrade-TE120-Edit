
SWEP.Author			= "Comrade Communist"
SWEP.Instructions	= "Left Click - Launch combine ball."
SWEP.Contact            = ""
SWEP.Spawnable			= true
SWEP.HoldType           = "physgun"
SWEP.AdminSpawnable		= true
SWEP.ViewModel			= "models/weapons/te120/c_superphyscannon1.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/te120/w_superphyscannon1.mdl"
SWEP.ViewModelFOV		= 60
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "None"
SWEP.ShowWorldModel			= true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "None"
SWEP.Weight				= 10
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.Category           = "Transmissions: Element 120"
SWEP.PrintName			= "Super Zero-Point Energy Projector"			
SWEP.Slot			= 0
SWEP.SlotPos			= 3
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
local HoldSound			= Sound("Weapon_MegaPhysCannon.HoldSound")


util.PrecacheModel("models/weapons/te120/w_megaphyscannon1.mdl")
/*---------------------------------------------------------
	Reload
---------------------------------------------------------*/
function SWEP:Reload()

end

function SWEP:Initialize()
		self:SetWeaponHoldType( self.HoldType )

	end
	
function SWEP:OwnerChanged()

		self:TPrem()
		if self.HP then
			self.HP = nil
		end
	end

/*---------------------------------------------------------
	Think
---------------------------------------------------------*/
function SWEP:Think()
if GetConVarNumber("scgg_style") == 0 then
	self.SwayScale 	= 3
	self.BobScale 	= 1
	else
	self.SwayScale 	= 1
	self.BobScale 	= 1
end
	if CLIENT then
	if GetConVarNumber("scgg_light") == 0 then return end
	if !self.Weapon:GetNWBool("Glow") then
		if !self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") then return end
		local dlighth = DynamicLight("lantern_"..self:EntIndex())
		if dlighth then
		dlighth.Pos = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		dlighth.r = 200
		dlighth.g = 255
		dlighth.b = 255
		dlighth.Brightness = 0.1
		dlighth.Size = 70
		dlighth.DieTime = CurTime() + .0001
		--dlighth.Style = 0
		end
		else
		if !self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") then return end
		local dlighth = DynamicLight("lantern_"..self:EntIndex())
		if dlighth then
		dlighth.Pos = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		dlighth.r = 255
		dlighth.g = 255
		dlighth.b = 255
		dlighth.Brightness = 0.3
		dlighth.Size = 100
		dlighth.DieTime = CurTime() + .0001
		--dlighth.Style = 0
		end
		end
		end
		local trace = self.Owner:GetEyeTrace()
		local tgt = trace.Entity
		
		if math.random(  6,  98 ) == 16 and !self.TP and !self.Owner:KeyDown(IN_ATTACK) and !self.Owner:KeyDown(IN_ATTACK2) then
			self:ZapEffect()
		end
		
		if self.Owner:KeyPressed(IN_ATTACK) then
			self:GlowEffect()
			self:RemoveCore()
		elseif self.Owner:KeyReleased(IN_ATTACK) and !self.TP then
			self:RemoveGlow()
			self:RemoveCore()
			self:CoreEffect()
		end
		
		if !self.Owner:KeyDown(IN_ATTACK) then
		if GetConVarNumber("scgg_style") == 1 then
			self.Weapon:SetNextPrimaryFire( CurTime() - 0.55 ); end
		end
		
		if self.Owner:KeyPressed(IN_ATTACK) then
			--if self.HP then return end   This fixes the secondary dryfire not playing
			
			if !tgt or !tgt:IsValid() then
				self.Weapon:EmitSound("Weapon_PhysCannon.TooHeavy")
				return
			end
			
			if (SERVER) then
				if tgt:GetMoveType() == MOVETYPE_VPHYSICS then
					local Mass = tgt:GetPhysicsObject():GetMass()

				else 
					self.Weapon:EmitSound("Weapon_PhysCannon.TooHeavy")
					return
				end
			end
		end
		
		if self.TP then
			if self.HP and self.HP != NULL then
				if (SERVER) then
				if !IsValid(self.HP) then self.HP = nil self.Drop() return end
					HPrad = self.HP:BoundingRadius()
					if !IsValid(self.Owner) then return end
					if !IsValid(self.TP) then return end
					self.TP:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*(self.Distance+HPrad))
					self.TP:PointAtEntity(self.Owner)
				--if self.HP:GetPhysicsObject() == nil then return end
				--if IsValid(phys) then
				if !IsValid(self.HP) then return end
					self.HP:GetPhysicsObject():Wake() --This needs fixing
				end --end
			else
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				
				self.Primary.Automatic = true
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 );
				self.Weapon:EmitSound("Weapon_MegaPhysCannon.Drop")
				
				timer.Simple( 0.4, 
			function()
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				end )
				
				self:CoreEffect()
				self:RemoveGlow()
				
				if self.TP then
					self.TP:Remove()
					self.TP = nil
				end
				if self.HP then
					self.HP = nil
				end
				
				self.Weapon:StopSound(HoldSound)
			end
			
			if CurTime() >= PropLockTime then
			if !IsValid(self.HP) then self.HP = nil return end
				if (self.HP:GetPos()-(self.Owner:GetShootPos()+self.Owner:GetAimVector()*(self.Distance+HPrad))):Length() >= 80 then
					self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
					self.Owner:SetAnimation( PLAYER_ATTACK1 )
					self:Drop()
				end
			end
		end
	end


function SWEP:ZapEffect()
		if SERVER then
			if GetConVarNumber("scgg_no_effects") == 1 then return end
			--if GetConVarNumber("scgg_style") == 1 then return end
			local zap = math.random(1,3)
			if zap == 1 then
				self.Zap =  ents.Create("PhyscannonZa1")
				else
			if zap == 2 then
				self.Zap =  ents.Create("PhyscannonZa2")
				else
			if zap == 3 then
				self.Zap =  ents.Create("PhyscannonZa3")
				else
			end
			end
			end
			self.Zap:SetPos( self.Owner:GetShootPos() )
			self.Zap:Spawn()
			self.Zap:SetParent(self.Owner)
			self.Zap:SetOwner(self.Owner)
		end
	end

function SWEP:ShootProjectile2()
if CLIENT then return end


local DEBall2 = ents.Create( "sent_combine_ball_medium2" )
DEBall2:SetPos( self.Owner:GetShootPos() )
DEBall2:Spawn()
DEBall2:SetKeyValue("ballcount", "10")  
DEBall2:SetKeyValue("ballrespawntime", "-1")  
DEBall2:SetKeyValue("maxballbounces","99999")
DEBall2:SetKeyValue("maxspeed", "1000")
DEBall2:SetKeyValue("minspeed", "1000")
DEBall2:SetKeyValue("launchconenoise", "5")
DEBall2:SetKeyValue("spawnflags", "2")
DEBall2:Fire( "launchBall", "", 0 )
DEBall2:Activate()
DEBall2:SetOwner( self.Owner )
DEBall2:SetPhysicsAttacker( self.Owner )
local phys = DEBall2:GetPhysicsObject()
if IsValid(phys) then
        phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
        phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
DEBall2.IsCBBall = true
phys:SetVelocity( self.Owner:GetAimVector()*1300 )
end
DEBall2:SetVelocity( self.Owner:GetAimVector()*1300 )
DEBall2.GetShootVector = self.Owner:GetAimVector()

end


function SWEP:GetCapabilities()

	return bit.bor( CAP_NO_HIT_PLAYER )

end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
    self:EmitSound("te_fire")
		if GetConVarNumber("scgg_style") == 0 then
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 ) end
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		if GetConVarNumber("scgg_style") == 1 then
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.55 ); end
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 );
		
		local vm = self.Owner:GetViewModel()
		timer.Create( "attack_idle" .. self:EntIndex(), 0.4, 1, function()
		if !IsValid( self.Weapon ) then return end
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end)
					



    self:SetNextPrimaryFire( CurTime() + 1 )


	local vm = self.Owner:GetViewModel()
	vm:SetSequence(1)
	vm:SetPlaybackRate( 3 )

        
        timer.Create("ball_chargeend" .. self.Owner:EntIndex(),0.0,1,function()
	if !IsValid(self) then return end
	if self.Owner:GetActiveWeapon():GetClass()=="te120_super" then
	self.Owner:ViewPunch(Angle( 0,0,math.Rand( 5, 10 )))
        self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
		timer.Simple( 0.1, function()
	self.Owner:SetVelocity( self.Owner:GetForward() * 200 + Vector( 0, 0, 240 ) )
end)

        self:ShootProjectile2()

					self:Visual()
	else
	end
	end)
	timer.Create("ball_chargeendanim" .. self.Owner:EntIndex(),0.05,1,function()
	if !IsValid(self) then return end
	if self.Owner:GetActiveWeapon():GetClass()=="te120_super" then
        self:SendWeaponAnim( ACT_VM_IDLE )
	end
	end)
end

function SWEP:DropAndShoot()
		if !IsValid(self.HP) then self.HP = nil return end
		self.HP:Fire("EnablePhyscannonPickup","",1)
		self.HP:SetCollisionGroup(COLLISION_GROUP_NONE)
		self.HP:SetPhysicsAttacker(self.Owner)
		
		self.Secondary.Automatic = true
		if GetConVarNumber("scgg_style") == 1 then
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 );
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.55 ); end
		
		self:CoreEffect()
		self:RemoveGlow()
		self:Visual()
		self:TPrem()
		
		self.Weapon:StopSound(HoldSound)
		
		if self.HP:GetClass() == "prop_ragdoll" then
		
		--timer.Create( "zap2", 0.1, 5, function()
		--local e = EffectData()
		--local trace = self.Owner:GetEyeTrace()
		--e:SetEntity(trace.Entity)
		--e:SetMagnitude(30)
		--e:SetScale(30)
		--e:SetRadius(30)
		--util.Effect("TeslaHitBoxes", e)
		--trace.Entity:EmitSound("Weapon_StunStick.Activate") end)
			local tr = self.Owner:GetEyeTrace()
	
	local dmginfo = DamageInfo();
	dmginfo:SetDamage( 500 );
	dmginfo:SetAttacker( self:GetOwner() );
	dmginfo:SetInflictor( self );
		
		
			--local dissolver = ents.Create("env_entity_dissolver")
	--dissolver:SetKeyValue("magnitude",0)
	--local trace = self.Owner:GetEyeTrace()
	--local tgt = trace.Entity
	--dissolver:SetPos(tgt)
	--dissolver:SetKeyValue("target",targname)
	--dissolver:Spawn()
			--dmginfo:SetDamageType( DMG_SHOCK )
		--dmginfo:SetDamagePosition( tr.HitPos )

			if GetConVarNumber("scgg_zap") == 1 then
			self.HP:Fire("StartRagdollBoogie","",0) end
			RagdollVisual(self.HP, 1)
			
			for i = 1, self.HP:GetPhysicsObjectCount() do
				local bone = self.HP:GetPhysicsObjectNum(i)
				
				if bone and bone.IsValid and bone:IsValid() then
			if GetConVarNumber("scgg_zap") == 1 then
			local effect  	= EffectData()
			if !IsValid(self.HP) then return end
			effect:SetOrigin(self.HP:GetPos())
			effect:SetStart(self.HP:GetPos())
			effect:SetMagnitude(5)
			effect:SetEntity(self.HP)
			util.Effect("teslaHitBoxes",effect)
			--self.HP:EmitSound("Weapon_StunStick.Activate")
			timer.Create( "zapper", 0.3, 16, function()
			util.Effect("teslaHitBoxes",effect)
			if !IsValid(self.HP) then self.HP = nil return end
			self.HP:EmitSound("Weapon_StunStick.Activate")
			end) end
					timer.Simple( 0.02, 
				function()
						if GetConVarNumber("scgg_style") == 0 then
						bone:AddVelocity(self.Owner:GetAimVector()*20000/8) else
						bone:AddVelocity(self.Owner:GetAimVector()*self.PuntForce/8) 
						end
					end )
				end
			end
		else
			local trace = self.Owner:GetEyeTrace()
			local position = trace.HitPos
			
			timer.Simple( 0.02,
		function()
				if GetConVarNumber("scgg_style") == 0 then --Prop Throwing
				self.HP:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector()*3500000)
				self.HP:GetPhysicsObject():ApplyForceOffset(self.Owner:GetAimVector()*3500000,position ) else
				self.HP:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector()*self.PuntForce)
				self.HP:GetPhysicsObject():ApplyForceOffset(self.Owner:GetAimVector()*self.PuntForce,position ) end
			end )
			
			self.HP:Fire("physdamagescale","9999",0)
		end
		
		timer.Simple( 0.04, 
	function()
			--self.HP = nil
		end )
		
	end
	
	

function SWEP:Visual()
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:EmitSound("te_fire")
		if SERVER then
		if GetConVarNumber("scgg_muzzle_flash") == 1 then
		local Light = ents.Create("light_dynamic")
		Light:SetKeyValue("brightness", "5")
		Light:SetKeyValue("distance", "200")
		Light:SetLocalPos(self.Owner:GetShootPos())
		Light:SetLocalAngles(self:GetAngles())
		Light:Fire("Color", "255 255 255")
		Light:SetParent(self)
		Light:Spawn()
		Light:Activate()
		Light:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(Light)
		timer.Simple(0.1,function() if self:IsValid() then Light:Remove() end end)
		end
		end
		if GetConVarNumber("scgg_style") == 0 then
		self.Owner:ViewPunch( Angle( -5, 2, 0 ) ) end
		
		local trace = self.Owner:GetEyeTrace()
		
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
		util.Effect( "PhyscannonTracer", effectdata )
		--local e = EffectData()
		--e:SetEntity(trace.Entity)
		--e:SetMagnitude(30)
		--e:SetScale(30)
		--e:SetRadius(30)
		--util.Effect("TeslaHitBoxes", e)------------------------------------------------------------------------------------------------------------
		--trace.Entity:EmitSound("Weapon_StunStick.Activate")
		
		if (SERVER) then
			if GetConVarNumber("scgg_no_effects") == 1 then return end
			if !self.Muzzle then
				self.Muzzle = ents.Create("PhyscannonMuzzle1")
				self.Muzzle:SetPos( self.Owner:GetShootPos() )
				self.Muzzle:Spawn()
			end
			
			self.Muzzle:SetParent(self.Owner)
			self.Muzzle:SetOwner(self.Owner)
			
			timer.Simple( 0.12,
		function() 
				self:RemoveMuzzle()
			end )
		end
		
		local e = EffectData()
		e:SetMagnitude(30)
		e:SetScale(30)
		e:SetRadius(30)
		e:SetOrigin(trace.HitPos)
		e:SetNormal(trace.HitNormal)
		--util.Effect("PhyscannonImpact", e)
		util.Effect("ManhackSparks", e)
	end
	
		
function RagdollVisual(ent, val)
if !IsValid(ent) then return end
			if ent:IsValid() then
			
			val = val+1
			
			--local effect = EffectData()
			--effect:SetEntity(ent)
			--effect:SetMagnitude(30)
			--effect:SetScale(30)
			--effect:SetRadius(30)
			--util.Effect("TeslaHitBoxes", effect)
			ent:EmitSound("Weapon_StunStick.Activate")
			
			if val <= 26 then
				timer.Simple((math.random(8,20)/100), RagdollVisual, ent, val)
			end
		end
	end

	function SWEP:OnDrop()
	if GetConVarNumber("scgg_no_effects") == 1 then return end
		self:RemoveFX()
		self:TPrem()
		if self.HP then
			self.HP = nil
		end
	end
	
function SWEP:TPrem()
		if self.TP then
			if !IsValid(self.TP) then return end
			self.TP:Remove()
			self.TP = nil
		end
		
		if self.Const then
		if !IsValid(self.Const) then return end
			self.Const:Remove()
			self.Const = nil
		end
	end
	
function SWEP:RemoveMuzzle()
		if self.Muzzle then
			self.Muzzle:Remove()
			self.Muzzle = nil
		end
	end
	
function SWEP:RemoveFX()
		if self.Core then
			self.Core:Remove()
			self.Core = nil
		end
		if self.Glow then
			self.Glow:Remove()
			self.Glow = nil
		end
	end
	
	function SWEP:CoreEffect()
		if SERVER then
		if GetConVarNumber("scgg_no_effects") == 1 then return end
			if !self.Core then
				self.Core = ents.Create("PhyscannonCore1")
				self.Weapon:SetNetworkedBool("Glow", true)				
				self.Core:SetPos( self.Owner:GetShootPos() )
				self.Core:Spawn()
			end
			self.Core:SetParent(self.Owner)
			self.Core:SetOwner(self.Owner)
		end
	end
	
function SWEP:GlowEffect()
		if SERVER then
		if GetConVarNumber("scgg_no_effects") == 1 then return end
			if !self.Glow then
				self.Glow = ents.Create("PhyscannonGlow1")
				self.Weapon:SetNetworkedBool("Glow", true)
				self.Glow:SetPos( self.Owner:GetShootPos() )
				self.Glow:Spawn()
			end
			self.Glow:SetParent(self.Owner)
			self.Glow:SetOwner(self.Owner)
		end
	end
	
function SWEP:RemoveCore()
		if CLIENT then return end
		if !self.Core then return end
		if !IsValid(self.Core) then return end
		self.Weapon:SetNetworkedBool("Glow", false)		
		self.Core:Remove()
		self.Core = nil
	end
	
function SWEP:RemoveGlow()
		if CLIENT then return end
		if !self.Glow then return end
		if !IsValid(self.Glow) then return end
		self.Weapon:SetNetworkedBool("Glow", false)
		self.Glow:Remove()
		self.Glow = nil
	end
	
	function SWEP:Deploy()
		--self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
		self:CoreEffect()
		if GetConVarNumber("scgg_style") == 0 then
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
 end
		local vm = self.Owner:GetViewModel()
		timer.Create( "deploy_idle" .. self:EntIndex(), vm:SequenceDuration(), 1, function()
		if !IsValid( self.Weapon ) then return end
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		--self.Weapon:SetNextPrimaryFire( CurTime() + 0.01 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.01 )
		end)
	end

function SWEP:Holster()
timer.Destroy("deploy_idle")
timer.Destroy("attack_idle")
self.Weapon:StopSound(HoldSound)

self.HP = nil
		if self.TP then
			return false
		else
			self:RemoveFX()
			self:TPrem()
			if self.HP then
				self.HP = nil
			end
			return true
		end
	end



/*---------------------------------------------------------
	IdleAnimation
---------------------------------------------------------*/
function SWEP:IdleAnimation()
end