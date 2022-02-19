if SERVER then return end

include ("shared.lua")

SWEP.Category =			"Transmissions: Element 120"

SWEP.PrintName			= "ZERO-POINT ENERGY PROJECTOR\n(GRAVITY CONCUSSION GUN)"

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

/*local function PoseArithmetic(ent, pose_str, number)
	local pose = ent:GetPoseParameter(pose_str)
	local num_min, num_max = ent:GetPoseParameterRange(pose)
	--print(num_max)
	return number
	--return math.Remap(number, 0, 1, num_min, num_max)
end

local function GetVMPoses(wep)
	local active_string = "active"
	local ViewModel = wep.Owner:GetViewModel()
	local WorldModel = wep
	
	return ViewModel, WorldModel, --[[vm_active_pose, wm_active_pose,--]] active_string
end

function SWEP:AdjustClaws()
	local function CalculateFrameAffectedNum(in_num)
		local frametime = CurTime()
		
		local result = in_num + frametime
		
		return result
	end
	
	if self.PoseParam < 0 then
		self.PoseParam = 0
	elseif self.PoseParam > 1 then
		self.PoseParam = 1
	end
	if self.PoseParamDesired < self.PoseParam then
		local result = CalculateFrameAffectedNum(0.0025)
		self.PoseParam = self.PoseParam-result
	elseif self.PoseParamDesired > self.PoseParam then
		local result = CalculateFrameAffectedNum(0.05)
		self.PoseParam = self.PoseParam+result
	end
	
	local ViewModel, WorldModel, --[[vm_active_pose, wm_active_pose,--]] active_string = GetVMPoses(self)
	
	if (ViewModel and IsValid(ViewModel)) or (WorldModel and IsValid(WorldModel)) then 
		if !IsValid(self) or !IsValid(self.Owner) or !self.Owner:Alive() then return end
		if IsValid(ViewModel) then -- Viewmodel claws are moved here.
			ViewModel:SetPoseParameter(active_string, self.PoseParam)
			ViewModel:InvalidateBoneCache()
		end
		if IsValid(WorldModel) then -- Worldmodel claws are moved here.
			WorldModel:SetPoseParameter(active_string, self.PoseParam)
			WorldModel:InvalidateBoneCache()
		end
	end
end

function SWEP:OpenClaws( boolean ) -- Open claws function.
	if !IsValid(self.Owner) or !self.Owner:Alive() then return end
	
	timer.Remove("scgg_claw_close_delay"..self:EntIndex()) -- Remove the delayed claw close timer often created by 'scgg_claw_mode 2'.
	
	if self.PoseParamDesired >= 1 then return end
	
	self.PoseParamDesired = 1
end
function SWEP:CloseClaws( boolean ) -- Close claws function.
	if !IsValid(self.Owner) or !self.Owner:Alive() or self.PoseParamDesired <= 0 then return end
	
	self.PoseParamDesired = 0
end

function SWEP:Think()
	if self.PoseParam == nil then
		self.PoseParam = 0
	end
	if self.PoseParamDesired == nil then
		self.PoseParamDesired = 0
	end
	self:AdjustClaws()
	
	
	
	self:SetNextClientThink(CurTime()+0.5)
end*/

--[[function SWEP:Deploy()
	print("clientdeploy")
	local claw_mode_cvar = GetConVar("scgg_claw_mode"):GetInt()
	if claw_mode_cvar <= 0 then
		self:CloseClaws( false )
	elseif (claw_mode_cvar > 0 and claw_mode_cvar < 2) then
		self:OpenClaws( false )
	end
end--]]

--[[function SWEP:Holster()
	self:SetHP(nil)
	return true
end--]]

-- Easier to not use this, as if you holster your weapon as it got it's viewmodel set, when you deploy it it'll glitch back to the old model
--[[function SWEP:Think()
	local VModel = self.Owner:GetViewModel()
	local cvar = GetConVar("cl_scgg_viewmodel"):GetString()
	if VModel:GetModel() != cvar then
		self.ViewModel = cvar
		VModel:SetModel(cvar)
	end
end--]]