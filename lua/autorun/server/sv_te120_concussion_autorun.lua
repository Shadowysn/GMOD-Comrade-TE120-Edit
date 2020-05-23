hook.Add("GetFallDamage", "Shadowysn_TE120_FallDamage", function(ply, speed)
	if IsValid(ply) and ply:HasWeapon("weapon_physconcussion") then
		local new_fallunit = 726.5
		if speed < new_fallunit then
			return 0
		elseif GetConVar("mp_falldamage"):GetInt() > 0 then
			return ( speed - new_fallunit ) * ( 100 / 396 )
		end
	end
end)

--[[hook.Add("EntityTakeDamage", "Shadowysn_TE120_FallDamage", function(ply, dmg)
	if IsValid(ply) and ply:IsPlayer() and dmg:IsFallDamage() and ply:HasWeapon("weapon_physconcussion") then
		dmg:SetDamage(0)
		--return true
	end
end)--]]