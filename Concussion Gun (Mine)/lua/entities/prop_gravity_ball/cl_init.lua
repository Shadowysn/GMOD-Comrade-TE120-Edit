if SERVER then return end
include("shared.lua")

local main_mat = Material( "effects/ar2_altfire2" )
local blur_mat = Material( "effects/ar2_altfire2b" )
local flicker_mat = Material( "effects/combinemuzzle2c" )
local halo_mat1 = Material( "effects/combinemuzzle1b_nocull" )
local halo_mat2 = Material( "effects/combinemuzzle2b_nocull" )
local halo_mat2alt = Material( "effects/combinemuzzle2c" )

local function InitSprites()
	main_mat:SetInt("$spriterendermode",5)
	blur_mat:SetInt("$spriterendermode",5)
	flicker_mat:SetInt("$spriterendermode",5)
	--local ZapWorld = Material( "sprites/bluelight1" )
	halo_mat1:SetInt("$spriterendermode",5)
	halo_mat2:SetInt("$spriterendermode",5)
	halo_mat2alt:SetInt("$spriterendermode",5)
end

local function MIN(a, b)
	if a < b then
		return a
	else
		return b
	end
end

function ENT:DrawMotionBlur()
	local color = Vector(0,0,0)

	local vecDir = self:GetPos() - self.vecLastOrigin
	--local speed = vecDir:GetNormalized()
	local speed = vecDir:Length()

	--[[local speed_clmp_x = math.Clamp( speed.x, 0, 32 )
	local speed_clmp_y = math.Clamp( speed.y, 0, 32 )
	local speed_clmp_z = math.Clamp( speed.z, 0, 32 )
	speed = Vector(speed_clmp_x, speed_clmp_y, speed_clmp_z)--]]
	--speed = 10

	local stepSize = MIN( ( speed * 0.5 ), 4.0 )

	local spawnPos = self:GetPos()
	local spawnStep = -vecDir * stepSize

	--local base = RemapValClamped( speed, 4, 32, 0.0f, 1.0f )
	local base = math.Remap( speed, 4, 32, 0.0, 1.0 )

	for index = 0, 8 do
		spawnPos = spawnPos+spawnStep
		
		local col_calc = base * ( 1.0 - ( index / 12.0 ) )
		color.x = col_calc
		color.y = col_calc
		color.z = col_calc

		--DrawHalo( blur_mat, spawnPos, self.flRadius, color )
		render.SetMaterial(blur_mat)
		render.DrawSprite(spawnPos, self.flRadius, self.flRadius, color)
	end
end

function ENT:DrawFlicker()
	local rand1 = math.Rand( 0.2, 0.3 )
	local rand2 = math.Rand( 1.5, 2.5 )

	if FrameTime() == 0.0 then
		rand1 = 0.2
		rand2 = 1.5
	end

	local color = Vector(rand1,rand1,rand1)
	
	--DrawHalo( m_pFlickerMaterial, GetAbsOrigin(), m_flRadius * rand2, color );
	render.SetMaterial(flicker_mat)
	render.DrawSprite(self:GetPos(), self.flRadius * rand2, self.flRadius * rand2, color)
end

function ENT:DrawSprites()
	--if !self:GetNWBool("bEmit") then return end
	
	self:DrawFlicker()
	
	local EntVel = self.Entity:GetVelocity()
	if EntVel.x > 10 or EntVel.y > 10 or EntVel.z > 10 then
		self:DrawMotionBlur()
	end
	
	--[[if m_bHeld then
		QAngle	angles;
		VectorAngles( -CurrentViewForward(), angles )

		// Always orient towards the camera!
		SetAbsAngles( angles );

		BaseClass::DrawModel( flags );
	else--]]
		local color = Vector(1.0,1.0,1.0)

		local sinOffs = 1.0 * math.sin( CurTime() * 25 )

		--local roll = self.Entity:GetInternalVariable("m_flSpawnTime")
		
		--DrawHaloOrientedG(self.Entity:GetPos(), self.flRadius + sinOffs, color, roll)
		render.SetMaterial(main_mat)
		render.DrawSprite(self:GetPos(), self.flRadius + sinOffs, self.flRadius + sinOffs, color)
	--end

	self.vecLastOrigin = self:GetPos()
end

function ENT:Draw()
	if !self.sprInitialized then
		InitSprites()
		self.sprInitialized = true
	end
	self:DrawSprites()
end