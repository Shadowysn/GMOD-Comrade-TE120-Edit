include('shared.lua')

local Zap = Material( "sprites/physcannon_bluelight1b" )
Zap:SetInt("$spriterendermode",1)

local ZapWorld = Material( "sprites/physbeama" )
ZapWorld:SetInt("$spriterendermode",5)

local Mat = Material( "sprites/blueflare1_noz" )
Mat:SetInt("$spriterendermode",5)

local MatWorld = Material( "sprites/blueflare1" )
MatWorld:SetInt("$spriterendermode",5)

ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
Zap:SetInt("$spriterendermode",5)
ZapWorld:SetInt("$spriterendermode",5)
Mat:SetInt("$spriterendermode",5)
MatWorld:SetInt("$spriterendermode",5)
end

function ENT:Think()
end

function ENT:Draw()
	local scale = math.Rand( 3, 5)
	local scale2 = math.Rand( 5, 8 )
	local scale3 = math.Rand( 3, 5 )
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
		if ( Owner:GetActiveWeapon():GetClass() != "te120_phys" and Owner:GetActiveWeapon():GetClass() != "te120_super" ) then return end
		end
		if !IsValid(self) then return end
		
		local attachmentID=vm:LookupAttachment("muzzle")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID5=vm:LookupAttachment("fork2t")
		local attachment_LH = vm:GetAttachment( attachmentID5 )
		StartPosO = attachment_LH.Pos
		
	render.SetMaterial( Mat )
	self.Length = (StartPosO - StartPos):Length()
	render.DrawSprite( StartPosO, scale, scale, Color(255,0,0,80))
	render.SetMaterial( Zap )
	
	render.DrawBeam( StartPosO, StartPos, 3, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length / 60	, Color( 255, 150, 150, 255 ) ) 
	else
		
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if ( vm:GetClass() != "te120_phys" ) and ( vm:GetClass() != "te120_super" ) then return end
		if !IsValid(self) then return end
		
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID2=vm:LookupAttachment("fork2t")
		local attachment_LH = vm:GetAttachment( attachmentID2 )
		StartPosO = attachment_LH.Pos
		
		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPos, scale3, scale3, Color(255,0,0,100))
	--local scale = math.Rand( 3, 5)
	--local scale2 = math.Rand( 5, 8 )
	--local scale3 = math.Rand( 3, 5 )
	render.SetMaterial( MatWorld )
	self.Length = (StartPosO - StartPos):Length()
	render.DrawSprite( StartPosO, scale, scale, Color(255,0,0,80))
	render.SetMaterial( ZapWorld )
	
	render.DrawBeam( StartPosO, StartPos, 3, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length / 60	, Color( 170, 150, 170, 100 ) ) 
	end
end

function ENT:IsTranslucent()
	return true
end
