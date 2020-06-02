
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetSolid( SOLID_NONE )
	
end

function ENT:Think()
	local Owner = self.Entity:GetOwner()
	if !IsValid(Owner) then self.Entity:Remove() return end
	
	if Owner:GetViewEntity():GetClass() == "gmod_cameraprop" then
		Owner:SetNWBool(	"Camera",			true)
	else
		Owner:SetNWBool(	"Camera",			false)
	end
	
	if !Owner:Alive() or ( Owner:GetActiveWeapon():GetClass() != "te120_phys" and Owner:GetActiveWeapon():GetClass() != "te120_super" ) then
		self.Entity:Remove()
		--[[for k,v in pairs(player.GetAll()) do
			v:ConCommand("stopsounds") -- fix for holdsound bug
		end--]]
	return end
end

