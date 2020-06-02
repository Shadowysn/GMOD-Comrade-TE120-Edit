include('shared.lua')

local Mat = Material( "sprites/blueflare1_noz" )
Mat:SetInt("$spriterendermode",5)
local MatWorld = Material( "sprites/blueflare1" )
MatWorld:SetInt("$spriterendermode",5)
--local Zap = Material( "sprites/purplelaser1" )
local Zap = Material( "sprites/physcannon_bluelight1b" )
Zap:SetInt("$spriterendermode",5)
local ZapWorld = Material( "sprites/physbeama" )
ZapWorld:SetInt("$spriterendermode",5)
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
Mat:SetInt("$spriterendermode",5)
Zap:SetInt("$spriterendermode",5)
ZapWorld:SetInt("$spriterendermode",5)
MatWorld:SetInt("$spriterendermode",5)
end

function ENT:Think()
end

function ENT:Draw()
	local scale = math.Rand( 8, 10 )
	local scale3 = math.Rand( 3, 5 )
	local scale6 = math.Rand( 35, 37 )
	local scale7 = math.Rand( 12, 14 )
	if !IsValid(self) then return end
	local Owner = self.Entity:GetOwner()
	if (!Owner || Owner == NULL) then return end
	
	local StartPos 		= self.Entity:GetPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	if ( ViewModel ) and Owner:GetNWBool("Camera") == false and Owner:Alive() then
		
		local vm = Owner:GetViewModel()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if IsValid(Owner:GetActiveWeapon()) then
		if ( Owner:GetActiveWeapon():GetClass() != "te120_phys" ) and ( Owner:GetActiveWeapon():GetClass() != "te120_super" ) then return end
		end
		
		local attachmentID=vm:LookupAttachment("muzzle")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID0=vm:LookupAttachment("muzzle")
		local attachment_R = vm:GetAttachment( attachmentID0 )
		StartPosR = attachment_R.Pos
		
		local attachmentID2=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID2 )
		StartPosO = attachment_O.Pos
		
		local attachmentID3=vm:LookupAttachment("fork2t")
		local attachment_L = vm:GetAttachment( attachmentID3 )
		StartPosL = attachment_L.Pos
		
		local attachmentID4=vm:LookupAttachment("fork1b")
		local attachment_OH = vm:GetAttachment( attachmentID4)
		StartPosOH = attachment_OH.Pos
		
		local attachmentID5=vm:LookupAttachment("fork2b")
		local attachment_LH = vm:GetAttachment( attachmentID5 )
		StartPosLH = attachment_LH.Pos
		
		render.SetMaterial( Mat )
		render.DrawSprite( StartPos, scale6, scale6, Color(255,150,150,240))
		render.DrawSprite( StartPosO, scale, scale, Color(255,150,150,80))
		render.DrawSprite( StartPosL, scale, scale, Color(255,150,150,80))
		render.DrawSprite( StartPosOH, scale, scale, Color(255,150,150,80))
		render.DrawSprite( StartPosLH, scale, scale, Color(255,150,150,80))
		--render.DrawSprite( StartPos, 35, 35, Color(255,255,255,240))
		render.DrawSprite( StartPosO, scale, scale, Color(255,150,150,80))
		render.DrawSprite( StartPosL, scale, scale, Color(255,150,150,80))
		render.DrawSprite( StartPosOH, scale, scale, Color(255,150,150,80))
		render.DrawSprite( StartPosLH, scale, scale, Color(255,150,150,80))
	elseif ( (!ViewModel) or Owner:GetNWBool("Camera") == true ) and Owner:Alive() then
		
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if ( vm:GetClass() != "te120_phys" ) and ( vm:GetClass() != "te120_super" ) then return end
		
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
		
		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPos, scale7, scale7, Color(255,150,150,240))
		render.DrawSprite( StartPosO, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosL, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosR, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosOH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosLH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosRH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPos, scale7, scale7, Color(255,150,150,100))
		render.DrawSprite( StartPos, scale7, scale7, Color(255,150,150,240))
		render.DrawSprite( StartPosO, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosL, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosR, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosOH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosLH, scale3, scale3, Color(255,150,150,80))
		render.DrawSprite( StartPosRH, scale3, scale3, Color(255,150,150,80))
	end
	
	self.Length = (StartPosO - StartPos):Length()
	self.Length2 = (StartPosL - StartPos):Length()
	self.Length3 = (StartPosR - StartPos):Length()
	
	if ( ViewModel ) and Owner:GetNWBool("Camera") == false then
	render.SetMaterial( Zap )
	render.DrawBeam( StartPosO, StartPos, 5, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length / 128, Color( 255, 150, 150, 255 ) ) 
	render.DrawBeam( StartPosL, StartPos, 5, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length2 / 128, Color( 255, 150, 150, 255 ) ) 
	render.DrawBeam( StartPosR, StartPos, 5, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length2 / 128, Color( 255, 150, 150, 255 ) ) 
	else
	render.SetMaterial( ZapWorld )
	render.DrawBeam( StartPosO, StartPos, 2, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length / 128, Color( 255, 150, 150, 255 ) ) 
	render.DrawBeam( StartPosL, StartPos, 2, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length2 / 128, Color( 255, 150, 150, 255 ) ) 
	render.DrawBeam( StartPosR, StartPos, 2, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length2 / 128, Color( 255, 150, 150, 255 ) ) 
	end
end

function ENT:IsTranslucent()
	return true
end
