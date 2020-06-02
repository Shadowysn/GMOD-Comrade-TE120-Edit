SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/c_physconcussion.mdl"
SWEP.WorldModel			= "models/weapons/w_physicsb.mdl"

SWEP.UseHands = true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.Weight 			= 30
SWEP.AutoSwitchTo 		= true
SWEP.AutoSwitchFrom 	= true
SWEP.HoldType			= "physgun"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Delay		= 1
SWEP.Primary.Ammo		= ""
	
SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
--SWEP.Secondary.Automatic	= true
SWEP.Secondary.Delay		= 1
SWEP.Secondary.Ammo		= ""

util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)

function SWEP:OpenElements( boolean )
--print("Open Elements!")
if !IsValid(self.Owner) or !self.Owner:Alive() then return end
	local active_string = "active"
	local ViewModel = self.Owner:GetViewModel()
	local WorldModel = self
		
		timer.Remove("scgg_claw_close_delay"..self:EntIndex())
		
		--[[local prong_1 = WorldModel:LookupBone("ValveBiped.Prong1")-- -- This has been creating lua errors whenever the function is run, with me unable to locate the cause, it JUST ISN'T FUNNY ANYMORE.
		local prong_2 = WorldModel:LookupBone("ValveBiped.Prong2")
		local prong_3 = WorldModel:LookupBone("ValveBiped.Prong3")
		
		local prong_a = ViewModel:LookupBone("Prong_A")
		local prong_b = ViewModel:LookupBone("Prong_B")
		
		local pro_a1_ang_r = -40
		local pro_b_ang_pr = 20
		local pro_23_ang_r = 60--
		--]]
	if (ViewModel and ViewModel:GetPoseParameter(active_string) < 1) or (WorldModel and WorldModel:GetPoseParameter(active_string) < 1) then 
	-- ^ We replace the 'active' parameter with 'super_active' in the model's qc file or else it will not work if the normal gravity gun is in player's inventory. 
	
		local frame = ViewModel:GetPoseParameter(active_string)
		local worldframe = WorldModel:GetPoseParameter(active_string)
		timer.Remove("scgg_claw_close_delay"..self:EntIndex())
		if !timer.Exists("scgg_move_claws_open"..self:EntIndex()) then
		timer.Remove("scgg_move_claws_close"..self:EntIndex())

		timer.Create( "scgg_move_claws_open"..self:EntIndex(), 0, 20, function()
		if !IsValid(self) or !IsValid(self.Owner) or !self.Owner:Alive() then timer.Remove("scgg_move_claws_open"..self:EntIndex()) return end
		if IsValid(ViewModel) then
			if frame > 1 then ViewModel:SetPoseParameter(active_string, 1) end
			--if frame >= 1 then timer.Remove("scgg_move_claws_open"..self:EntIndex()) return end
			frame = frame+0.15
			ViewModel:SetPoseParameter(active_string, frame)
			
			--[[if frame_a.roll < pro_a1_ang_r then ViewModel:ManipulateBoneAngles(prong_a, Angle(frame_a.pitch, frame_a.yaw, pro_a1_ang_r)) end--
			if frame_b.pitch > pro_b_ang_pr then ViewModel:ManipulateBoneAngles(prong_b, Angle(frame_b.pitch, frame_b.yaw, pro_b_ang_pr)) end
			if frame_b.roll > pro_b_ang_pr then ViewModel:ManipulateBoneAngles(prong_b, Angle(pro_b_ang_pr, frame_b.yaw, frame_b.roll)) end
			if frame_a.roll <= pro_a1_ang_r and 
			frame_b.pitch >= pro_b_ang_pr and frame_b.roll >= pro_b_ang_pr
			then 
			timer.Remove("scgg_move_claws_open"..self:EntIndex()) return end
			frame_a.roll = frame_a.roll+0.1
			frame_b.pitch = frame_b.pitch+0.1
			frame_b.roll = frame_b.roll+0.1
			ViewModel:ManipulateBoneAngles(prong_a, frame_a)
			ViewModel:ManipulateBoneAngles(prong_b, frame_b)--]]
			end
			--net.Start("SCGG_OpenClaws_Client")
			--net.Send(self.Owner)
		if IsValid(WorldModel) then
			if worldframe > 1 then WorldModel:SetPoseParameter(active_string, 1) end
			--if worldframe >= 1 then timer.Remove("scgg_move_claws_open"..self:EntIndex()) return end
			worldframe = worldframe+0.15
			WorldModel:SetPoseParameter(active_string, worldframe)
			if WorldModel:GetPoseParameter(active_string) >= 0.5 then
				self.ClawOpenState = true
			end
			--[[if frame_1.roll < pro_a1_ang_r then WorldModel:ManipulateBoneAngles(prong_1, Angle(frame_1.pitch, frame_1.yaw, pro_a1_ang_r)) end--
			if frame_2.roll > pro_23_ang_r then WorldModel:ManipulateBoneAngles(prong_2, Angle(frame_2.pitch, frame_2.yaw, pro_23_ang_r)) end
			if frame_3.roll > pro_23_ang_r then WorldModel:ManipulateBoneAngles(prong_3, Angle(frame_3.pitch, frame_3.yaw, pro_23_ang_r)) end
			frame_1.roll = frame_1.roll+0.1
			frame_2.roll = frame_2.roll+0.1
			frame_3.roll = frame_3.roll+0.1
			WorldModel:ManipulateBoneAngles(prong_1, frame_1)
			WorldModel:ManipulateBoneAngles(prong_2, frame_2)
			WorldModel:ManipulateBoneAngles(prong_3, frame_3)--
			--]]
			end
		end )
		if (!IsValid(self.Owner) or !self.Owner:Alive()) or (!IsValid(ViewModel) and !IsValid(WorldModel)) then 
		timer.Remove("scgg_move_claws_open"..self:EntIndex()) return end
		if (frame <= 0 or worldframe <= 0) and !IsValid(self.HP) and boolean == true then
			self.Weapon:StopSound("Weapon_PhysCannon.CloseClaws")
			self.Weapon:EmitSound("Weapon_PhysCannon.OpenClaws")
		end--+
	end--
end

end

function SWEP:CloseElements( boolean )
--print("Close Elements!")
if !IsValid(self.Owner) or !self.Owner:Alive() then return end
	local active_string = "active"
	local ViewModel = self.Owner:GetViewModel()
	local WorldModel = self
	--if ViewModel and self.ClawOpenState == true then
	if (ViewModel and ViewModel:GetPoseParameter(active_string) > 0) or (WorldModel and WorldModel:GetPoseParameter(active_string) > 0) then
		local frame = ViewModel:GetPoseParameter(active_string)
		local worldframe = WorldModel:GetPoseParameter(active_string)
		if !timer.Exists("scgg_move_claws_close"..self:EntIndex()) then
		timer.Remove("scgg_move_claws_open"..self:EntIndex())
		
		timer.Create( "scgg_move_claws_close"..self:EntIndex(), 0.02, 20, function()
		if !IsValid(self.Owner) or !self.Owner:Alive() then timer.Remove("scgg_move_claws_close"..self:EntIndex()) return end
		if IsValid(ViewModel) then
			if frame < 0 then ViewModel:SetPoseParameter(active_string, 0) end
			--if frame <= 0 then print("doh2") timer.Remove("scgg_move_claws_close"..self:EntIndex()) return end
			frame = frame-0.15
			ViewModel:SetPoseParameter(active_string, frame)
			end
		if IsValid(WorldModel) then
			if worldframe < 0 then WorldModel:SetPoseParameter(active_string, 0) end
			--if worldframe <= 0 then print("doh3") timer.Remove("scgg_move_claws_close"..self:EntIndex()) return end
			worldframe = worldframe-0.15
			WorldModel:SetPoseParameter(active_string, worldframe)
			end
				if WorldModel:GetPoseParameter(active_string) < 0.5 then
				self.ClawOpenState = false
				end
		end )
		if (!IsValid(self.Owner) or !self.Owner:Alive()) or (!IsValid(ViewModel) and !IsValid(WorldModel)) then 
		timer.Remove("scgg_move_claws_close"..self:EntIndex()) return end
			if (frame >= 1 or worldframe >= 1) and !IsValid(self.HP) and boolean == true then
				self.Weapon:StopSound("Weapon_PhysCannon.OpenClaws")
				self.Weapon:EmitSound("Weapon_PhysCannon.CloseClaws")
			end
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Recharged = true
	self.CanFire = true
end

function SWEP:Think()
	if SERVER and IsValid(self.Owner) then
		if !self.Recharged then
			local function AUXExists()
				local suit_aux = self.Owner:GetSuitPower()
				--if file.Exists("lua/autorun/auxpower.lua","GAME") and AUXPOW:IsEnabled() and AUXPOW:IsSuitEquipped(self.Owner) then
				if self.Owner:IsSuitEquipped() and suit_aux != nil and suit_aux >= 0 then
					return true
				end
				return false
			end
			--local AUXDrain = 0.25
			local AUXDrain = 25
			if self.RechargeDelay == nil then
				self.RechargeDelay = 0
			end
			if self.RechargeDelay <= CurTime() then
				--local suit_aux = AUXPOW:GetPower(self.Owner)
				local suit_aux = self.Owner:GetSuitPower()
				if !self.IsRecharging and (!AUXExists() or suit_aux >= AUXDrain) then
					self.RechargeDelay = CurTime()+0.35
					self.IsRecharging = true
				elseif self.IsRecharging then
					timer.Simple(0.15, function() 
						self.CanFire = true
					end)
					self.Recharged = true
					self.IsRecharging = nil
					if AUXExists() then
						--AUXPOW:AddPower(self.Owner, -AUXDrain)
						self.Owner:SetSuitPower(suit_aux - AUXDrain)
					end
				end
			end
		end
	end
	if self.Recharged and !self.ClawOpenState then
		self:OpenElements(false)
	elseif !self.Recharged and self.ClawOpenState then
		self:CloseElements(false)
	end
end

function SWEP:Deploy()
	if self.Recharged then
		self:OpenElements(false)
	elseif !self.Recharged then
		self:CloseElements(false)
	end
	return true
end

function SWEP:PrimaryAttack()
	if !self.Recharged or !self.CanFire then return end
	--self:OpenElements(false)
	self.Recharged = nil
	self.CanFire = nil
	self.Owner:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 40 ), 0.1, 0 )
	self:CloseElements(false)
	self.Weapon:EmitSound("Weapon_MegaPhysCannon.Launch")
	self.Owner:ViewPunch( Angle( -5, 2, 0 ) )
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
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

function SWEP:SecondaryAttack()
	--self:CloseElements(false)
end