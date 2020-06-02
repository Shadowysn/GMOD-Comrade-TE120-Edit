
SWEP.Author			= "Comrade Communist"
SWEP.Instructions	= "Left Click - Launch combine ball."
SWEP.Contact            = ""
SWEP.Spawnable			= true
SWEP.HoldType           = "physgun"
SWEP.AdminSpawnable		= false
SWEP.AdminOnly                  = false
SWEP.ViewModel			= "models/weapons/te120/c_superphyscannon1.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/te120/w_superphyscannon1.mdl"
SWEP.ViewModelFOV		= 53
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "None"
SWEP.ShowWorldModel			= true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= ""

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.Category           = "Transmissions: Element 120"
SWEP.PrintName			= "Zero-Point Energy Projector"			
SWEP.Slot			= 0
SWEP.SlotPos			= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
util.PrecacheModel("models/weapons/te120/w_megaphyscannon1.mdl")
/*---------------------------------------------------------
	Reload
---------------------------------------------------------*/
function SWEP:Reload()
 			return false
end

/*---------------------------------------------------------
	Think
---------------------------------------------------------*/

function SWEP:Initialize()
		self:SetWeaponHoldType( self.HoldType )
		self.CoreAllowRemove = true
		self.GlowAllowRemove = true
		self.MuzzleAllowRemove = true
	end
	
function SWEP:OwnerChanged()
	
end

/*---------------------------------------------------------
	Think
---------------------------------------------------------*/
function SWEP:Think()
	self.SwayScale 	= 3
	self.BobScale 	= 1
	if CLIENT then
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
		
		if (SERVER) then
			if !IsValid(self.Muzzle) and self.MuzzleAllowRemove == false then
				self.Muzzle = ents.Create("PhyscannonMuzzle1")
				self.Muzzle:SetPos( self.Owner:GetShootPos() )
				self.Muzzle:Spawn()
				self.Muzzle:SetParent(self.Owner)
				self.Muzzle:SetOwner(self.Owner)
			end
			if IsValid(self.Muzzle) and self.MuzzleAllowRemove == true then
				self.Muzzle:Remove()
				self.Muzzle = nil
			end
		end
		if IsValid(self.Core) then
			self.Core:SetPos( self.Owner:GetShootPos() )
		end
		if !IsValid(self.Core) and self.CoreAllowRemove == false then
			-- Required to directly include the code, not as a function or else it becomes a lua-error minigun.
			self.Core = ents.Create("PhyscannonCore1")
			self.Core:SetPos( self.Owner:GetShootPos() )
			self.Core:Spawn()
			self.Core:SetParent(self.Owner)
			self.Core:SetOwner(self.Owner)
		end
		if IsValid(self.Glow) then
			self.Glow:SetPos( self.Owner:GetShootPos() )
		end
		if !IsValid(self.Glow) and self.GlowAllowRemove == false then
			-- Required to directly include the code, not as a function or else it becomes a lua-error minigun.
			self.Glow = ents.Create("PhyscannonGlow1")
			self.Weapon:SetNetworkedBool("Glow", true)
			self.Glow:SetPos( self.Owner:GetShootPos() )
			self.Glow:Spawn()
			self.Glow:SetParent(self.Owner)
			self.Glow:SetOwner(self.Owner)
		end
		
		local trace = self.Owner:GetEyeTrace()
		local tgt = trace.Entity
		
		if math.random(  6,  98 ) == 16 and !self.Owner:KeyDown(IN_ATTACK) and !self.Owner:KeyDown(IN_ATTACK2) then
			self:ZapEffect()
		end
		
		if self.Owner:KeyPressed(IN_ATTACK) then
			self:GlowEffect()
			self:RemoveCore()
		elseif self.Owner:KeyReleased(IN_ATTACK) then
			self:RemoveGlow()
			self:RemoveCore()
			self:CoreEffect()
		end
		
		if !self.Owner:KeyDown(IN_ATTACK) then
			self.Weapon:SetNextPrimaryFire( CurTime() - 0.55 ); end
		
		if self.Owner:KeyPressed(IN_ATTACK) then
			
			if !IsValid(tgt) or self.HasFired then
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
		
	end



function SWEP:ZapEffect()
		if SERVER then
			if IsValid(self.Zap1) and IsValid(self.Zap2) and IsValid(self.Zap3) then return end
			local zap_math = table.Random( { 1, 2, 3 } )
			if zap_math == 1 and !IsValid(self.Zap1) then
				self.Zap =  ents.Create("PhyscannonZa1")
				self.Zap1 = self.Zap
			elseif zap_math == 2 and !IsValid(self.Zap2) then
				self.Zap =  ents.Create("PhyscannonZa2")
				self.Zap2 = self.Zap
			elseif zap_math == 3 and !IsValid(self.Zap3) then
				self.Zap =  ents.Create("PhyscannonZa3")
				self.Zap3 = self.Zap
			end
			if IsValid(self.Zap) then
			self.Zap:SetPos( self.Owner:GetShootPos() )
			self.Zap:Spawn()
			self.Zap:SetParent(self.Owner)
			self.Zap:SetOwner(self.Owner)
			end
		end
	end

function SWEP:ShootProjectile2()
if CLIENT then return end


local DEBall2 = ents.Create( "sent_combine_ball_medium1" )
DEBall2:SetPos( self.Owner:GetShootPos() )
DEBall2:Spawn()
DEBall2:SetKeyValue("ballcount", "10")  
DEBall2:SetKeyValue("ballrespawntime", "-1")  
DEBall2:SetKeyValue("maxballbounces","99")
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

phys:SetVelocity( self.Owner:GetAimVector()*1 )

end

DEBall2:SetVelocity( self.Owner:GetAimVector()*1 )
DEBall2.GetShootVector = self.Owner:GetAimVector()
DEBall2.GetOwnerVelocity = self.Owner:GetVelocity()

end




/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if self.HasFired then return end
    --self.Weapon:EmitSound("te_fire")
	--self.Weapon:EmitSound("Weapon_MegaPhysCannon.Launch")

    self:SetNextPrimaryFire( CurTime() + 1 )
	self.HasFired = true
	timer.Simple(1, function() 
		if !IsValid(self) or !self.HasFired then return end
		self.HasFired = nil
	end)
    self:SetNextSecondaryFire( CurTime() + 3 )

	local vm = self.Owner:GetViewModel()
	vm:SetSequence(1)
	vm:SetPlaybackRate( 3 )

        
        timer.Create("ball_chargeend" .. self.Owner:EntIndex(),0.0,1,function()
	if !IsValid(self) then return end
	if self.Owner:GetActiveWeapon():GetClass()=="te120_phys" then
	self.Owner:ViewPunch(Angle( 0,0,math.Rand( 5, 10 )))
        self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
		timer.Simple( 0.1, function()
	self.Owner:SetVelocity( self.Owner:GetForward() * 200 + Vector( 0, 0, 147 ) )
	
end)
	--self.Weapon:EmitSound("te_fire")
	self.Weapon:EmitSound("Weapon_MegaPhysCannon.Launch")
        self:ShootProjectile2()

					self:Visual()
	else
	end
	end)
	timer.Create("ball_chargeendanim" .. self.Owner:EntIndex(),0.05,1,function()
	if !IsValid(self) then return end
	if self.Owner:GetActiveWeapon():GetClass()=="te120_phys" then
        self:SendWeaponAnim( ACT_VM_IDLE )
		
	end
	end)
end

function SWEP:SecondaryAttack()
 			return false
end

function SWEP:Visual()
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	--self.Weapon:EmitSound("te_fire")
	self.Weapon:EmitSound("Weapon_MegaPhysCannon.Launch")
	if SERVER then
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
		timer.Simple(0.1,function() if self:IsValid() and IsValid(Light) then Light:Remove() end end)
	end
	self.Owner:ViewPunch( Angle( -5, 2, 0 ) )
	
	local trace = self.Owner:GetEyeTrace()
	
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetStart( self.Owner:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self.Weapon )
	util.Effect( "PhyscannonTracer1", effectdata )
	--local e = EffectData()
	--e:SetEntity(trace.Entity)
	--e:SetMagnitude(30)
	--e:SetScale(30)
	--e:SetRadius(30)
	--util.Effect("TeslaHitBoxes", e)------------------------------------------------------------------------------------------------------------
	--trace.Entity:EmitSound("Weapon_StunStick.Activate")
	
	if (SERVER) then
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

function SWEP:OnDrop()
	self:RemoveFX()
end
	
function SWEP:RemoveMuzzle()
		if self.Muzzle then
			if !IsValid(self.Muzzle) then return end
			self.MuzzleAllowRemove = true
			self.Muzzle:Remove()
			self.Muzzle = nil
		end
	end
	
function SWEP:RemoveFX()
		if self.Core then
			if !IsValid(self.Core) then return end
			self.CoreAllowRemove = true
			self.Core:Remove()
			self.Core = nil
		end
		if self.Glow then
			self.GlowAllowRemove = true
			self.Glow:Remove()
			self.Glow = nil
		end
	end
	
	function SWEP:CoreEffect()
		if SERVER then
			if !IsValid(self.Core) then
				self.Core = ents.Create("PhyscannonCore1")
				self.Core:SetPos( self.Owner:GetShootPos() )
				self.Core:Spawn()
			end
			self.CoreAllowRemove = false
			if !IsValid(self.Core) then return end
			self.Core:SetParent(self.Owner)
			self.Core:SetOwner(self.Owner)
		end
	end
	
function SWEP:GlowEffect()
		if SERVER then
			if !IsValid(self.Glow) then
				self.Glow = ents.Create("PhyscannonGlow1")
				self.Weapon:SetNetworkedBool("Glow", true)
				self.Glow:SetPos( self.Owner:GetShootPos() )
				self.Glow:Spawn()
			end
			self.GlowAllowRemove = false
			self.Glow:SetParent(self.Owner)
			self.Glow:SetOwner(self.Owner)
		end
	end
	
function SWEP:RemoveCore()
		if CLIENT then return end
		if !self.Core then return end
		if !IsValid(self.Core) then return end
		self.CoreAllowRemove = true
		self.Core:Remove()
		self.Core = nil
	end
	
function SWEP:RemoveGlow()
		if CLIENT then return end
		if !self.Glow then return end
		if !IsValid(self.Glow) then return end
		self.GlowAllowRemove = true
		self.Weapon:SetNetworkedBool("Glow", false)
		self.Glow:Remove()
		self.Glow = nil
	end
	
function SWEP:Deploy()
	--self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
	self:CoreEffect()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	local vm = self.Owner:GetViewModel()
	timer.Create( "deploy_idle" .. self:EntIndex(), vm:SequenceDuration(), 1, function()
	if !IsValid( self.Weapon ) then return end
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	--self.Weapon:SetNextPrimaryFire( CurTime() + 0.01 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.01 )
	end)
	return true
end

function SWEP:Holster()
timer.Destroy("deploy_idle")
timer.Destroy("attack_idle")
return true
end
