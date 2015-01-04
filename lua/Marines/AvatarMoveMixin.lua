//
//	Avatar Move Mixin by Andy 'Soul Rider' Wilson
//      incorporating Quick-Dodge Mixin by Brock 'McGlaspie' Gillespie - mcglaspie@gmail.com
//
//	Controls the Avatar Players advanced moves.
//
//=============================================================================


AvatarMoveMixin = CreateMixin( AvatarMoveMixin )
AvatarMoveMixin.type = "Dodge"

AvatarMoveMixin.expectedCallbacks = {
    GetVelocity = "Required for movement posotion and speed modifiers",
    GetViewCoords = "Require for camera animation and view modifiers",
    GetIsOnGround = "Required for movement calculation",
    GetIsFlying = "Required for cases when player has a Jetpack or similar ability",
    GetCrouching = "Require to correctly handle crouch moves"
}

AvatarMoveMixin.networkVars = {
	dodging = "private boolean",
	timeLastQuickDodge = "private time",
	timeLastQuickDodgeEnded = "private time",
}


//-----------------------------------------------------------------------------


function AvatarMoveMixin:__initmixin()

	self.dodging = false
	
	self.timeLastQuickDodge = 0
	self.timeLastQuickDodgeEnded = 0
	
end


function AvatarMoveMixin:GetIsDodging()
    return self.dodging
end


function AvatarMoveMixin:GetCanJump()
    return self:GetIsOnGround() and not self:GetIsDodging()
end


function AvatarMoveMixin:GetCanStep()
	return not self.dodging
end


function AvatarMoveMixin:GetMaxSpeed( possible )
	
    if possible and not self:GetIsDodging() then
        return kMaxSpeed
    end
    
    if self:GetIsDodging() then
        return AvatarMoveMixin.kQuickDodgeMaxSpeed
    end

    return kMaxSpeed
    
end


function AvatarMoveMixin:GetCanDodge()
	
	return (
		not self.dodging and not self:GetCrouching() 
		and not self:GetIsJumping() and not self:GetIsFlying() and
		self.timeLastQuickDodge == 0
	)
	
end


local kQuickDodgeTime = 0.175
local kQuickDodgeAllowedInterval = 0.55

function AvatarMoveMixin:OnUpdate( deltaTime )
	
	local now = Shared.GetTime()
	
	if self.dodging then
		
		if now > kQuickDodgeTime + self.timeLastQuickDodge then
			self.timeLastQuickDodgeEnded = now
			self.onGround = true
			self.dodging = false
		end
		
	end
	
	if now > kQuickDodgeAllowedInterval + self.timeLastQuickDodgeEnded then
		self.timeLastQuickDodge = 0
	end

end


local kQuickDodgeJumpForce = 2.15
local kQuickDodgeMaxSpeed = 4.55

function AvatarMoveMixin:PerformDodge( input, velocity )
	
	local direction = self:GetViewCoords():TransformVector( input.move )
	direction:Normalize()
	
	local dodgeVelocity = Vector( direction * kQuickDodgeMaxSpeed * self:GetSlowSpeedModifier() )
	dodgeVelocity.y = kQuickDodgeJumpForce
	
	velocity:Add( dodgeVelocity )
	
	//maxspeed check
	
	self.timeLastQuickDodge = Shared.GetTime()      
	self.dodging = true
	self.onGround = false
	
end


function AvatarMoveMixin:ModifyVelocity( input, velocity, deltaTime )

	local moveModifierButton = bit.band( input.commands, Move.MovementModifier ) ~= 0
    local validDodgeInput = (
		moveModifierButton and input.move.x ~= 0 and input.move.y == 0
    )
    
    self:OnUpdate( deltaTime )	//HACKS biatch!
    
    if validDodgeInput and self:GetCanDodge() then
		
		self:PerformDodge( input, velocity )
    
    end

end


function AvatarMoveMixin:OnUpdateAnimationInput( modelMixin )

    PROFILE("AvatarMoveMixin:OnUpdateAnimationInput")
	
    if self:GetIsDodging() and ( not HasMixin(self, "LadderMove") or not self:GetIsOnLadder() ) then
		//TODO Change to use XYZ_jetpacktakeoff, XYZ_jetpackland, XYZ_jetpack?
		// - above will likely result in really jerky animations
        
        if self.dodging and not self.onGround then
			modelMixin:SetAnimationInput("move", "jump")
        end
        
    end
    
end