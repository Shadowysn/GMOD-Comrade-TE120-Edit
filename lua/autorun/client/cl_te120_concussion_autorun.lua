hook.Add("Think", "Grav_Disable_Claw_Bug", function() 
	local grav = LocalPlayer():GetWeapon("weapon_physcannon")
	if IsValid(grav) then
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physcannon" then
		grav:SetNextClientThink(CurTime())
		else
		grav:SetNextClientThink(CurTime() + 0.2)
		end
	end
end)

--[[local function AUXExists(owner)
	local suit_aux = owner:GetSuitPower()
	if owner:IsSuitEquipped() and suit_aux != nil and suit_aux > 0 then
		return true
	end
	return false
end--]]