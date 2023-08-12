// Ins2 Generic Prop Entity
// Author: KernCore

#include "../base"

namespace INS2PROP
{

class CIns2Prop : ScriptBaseAnimating
{
	private float m_flNextSlideUpdate, m_flBounceTime;
	float m_flVelFriction, m_flAVelFriction;
	array<string> m_szBounceSounds = {};

	void Spawn()
	{
		BaseClass.Spawn();
		Precache();

		self.pev.movetype = MOVETYPE_BOUNCE;
		self.pev.solid = SOLID_TRIGGER;
		self.pev.gravity = 1;

		m_flNextSlideUpdate = 0;
		m_flBounceTime = 0;

		SetTouch( TouchFunction( this.Slide ) );
		SetThink( ThinkFunction( this.PropThink ) );
		self.pev.nextthink = g_Engine.time + 0.1;

		g_EntityFuncs.SetSize( self.pev, Vector( -3, -2, -1 ), Vector( 3, 2, 1 ) );
	}

	void Precache()
	{
		if( m_szBounceSounds.length() > 0 )
		{
			for( uint i = 0; i < m_szBounceSounds.length(); i++ )
			{
				g_SoundSystem.PrecacheSound( m_szBounceSounds[i] );
				g_Game.PrecacheGeneric( "sound/" + m_szBounceSounds[i] );
				//g_Game.AlertMessage( at_console, "Precached: sound/" + m_szBounceSounds[i] + "\n" );
			}
		}
		BaseClass.Precache();
	}

	void BounceSound()
	{
		if( g_Engine.time < m_flBounceTime )
			return;

		m_flBounceTime = g_Engine.time + Math.RandomFloat( 0.1f, 0.3f );

		if( g_Utility.GetGlobalTrace().flFraction < 1.0 )
		{
			if( g_Utility.GetGlobalTrace().pHit !is null )
			{
				CBaseEntity@ pHit = g_EntityFuncs.Instance( g_Utility.GetGlobalTrace().pHit );
				if( pHit.IsBSPModel() )
				{
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_AUTO, m_szBounceSounds[ Math.RandomLong( 0, m_szBounceSounds.length() - 1 ) ], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
				}
			}
		}
	}

	void Slide( CBaseEntity@ pOther )
	{
		// don't hit the owner
		if( @pOther.edict() == @self.pev.owner )
			return;

		BounceSound();

		// add a bit of static friction
		self.pev.velocity = self.pev.velocity * m_flVelFriction;
		self.pev.avelocity = self.pev.avelocity * m_flAVelFriction;

		if( pOther.IsBSPModel() )
			self.pev.flags |= FL_ONGROUND;

		if( self.pev.flags & FL_ONGROUND != 0 )
		{
			AlignToGroundStatic( self, 190.0f );
		}
	}

	void PropThink()
	{
		if( !self.IsInWorld() )
		{
			g_EntityFuncs.Remove( self );
			return;
		}

		self.pev.nextthink = g_Engine.time + 0.1;

		if( self.pev.flags & FL_ONGROUND == 0 )
		{
			AlignToGroundStatic( self, 110.0f );
		}

		if( self.pev.waterlevel != WATERLEVEL_DRY )
		{
			self.pev.velocity = self.pev.velocity * 0.5;
			self.pev.avelocity = self.pev.avelocity * 0.9;
		}

		if( self.pev.dmgtime <= g_Engine.time )
		{
			SetThink( null );
			self.SUB_StartFadeOut();
			self.pev.nextthink = g_Engine.time + 0.1;
		}
	}

	void AlignToGroundStatic( CBaseEntity@ pObject, float flSpeed )
	{
		//If we're set to float in the air, don't bother aligning
		if( pObject is null || pObject.pev.movetype == MOVETYPE_FLY )
			return;

		//"Unstick" code (for slopes)
		if( pObject.m_vecLastOrigin == pObject.pev.origin && pObject.pev.velocity.z < 0 )
		{
			if( pObject.pev.groundentity is null )
			{
				pObject.pev.velocity.z++;
				pObject.pev.origin.z++;
			}
		}

		pObject.m_vecLastOrigin = pObject.pev.origin;

		bool fLarge = false;

		//Geckon: Get the size from the model
		CBaseAnimating@ pAnimating = cast<CBaseAnimating@>( pObject );
		if( pAnimating !is null )
		{
			Vector vecMin, vecMax, vecSize;
			pAnimating.ExtractBbox( 0, vecMin, vecMax );
			vecSize = vecMax - vecMin;
			fLarge = (vecSize.x + vecSize.y + vecSize.z) >= 60;
		}

		Vector m_vecAngles = pObject.pev.angles;

		//We want the direction we are facing, only, if we're a small object
		if( !(pObject.pev.groundentity !is null || pObject.pev.flags & FL_ONGROUND != 0) && !fLarge )
		{
			m_vecAngles.z = 0;
			m_vecAngles.x = 0;
		}

		Math.MakeVectors( m_vecAngles );

		//Origin trace
		TraceResult trOrigin;
		g_Utility.TraceLine( pObject.pev.origin + Vector( 0, 0, 8 ), pObject.pev.origin - Vector( 0, 0, 32 ), ignore_monsters, pObject.edict(), trOrigin );

		//Don't bother if we're already on flat ground
		if( trOrigin.vecPlaneNormal == Vector( 0, 0, 1 ) )
		{
			pObject.pev.angles.x = Math.ApproachAngle( 0, pObject.pev.angles.x, 50);
			pObject.pev.angles.z = Math.ApproachAngle( 0, pObject.pev.angles.z, 50);
			return;
		}

		//This is here so that we don't go up too high, in case we're under a shelf or such
		TraceResult trCheck;
		g_Utility.TraceLine( pObject.pev.origin + Vector( 0, 0, 1 ), pObject.pev.origin - Vector( 0, 0, 24 ), ignore_monsters, pObject.edict(), trCheck );
		float checkdis = trCheck.vecEndPos.z - pObject.pev.origin.z;

		//Z
		TraceResult trZ;
		Vector m_vecTracePosZ = pObject.pev.origin + g_Engine.v_forward * 8 + Vector( 0, 0, checkdis ); //g_Engine.v_up * 16;
		g_Utility.TraceLine( m_vecTracePosZ, (m_vecTracePosZ - Vector( 0, 0, 48 )), ignore_monsters, dont_ignore_glass, pObject.edict(), trZ );

		//X
		TraceResult trX;
		Vector m_vecTracePosX = pObject.pev.origin + g_Engine.v_right * 8 + Vector( 0, 0, checkdis );
		g_Utility.TraceLine( m_vecTracePosX, (m_vecTracePosX - Vector( 0, 0, 48 )), ignore_monsters, dont_ignore_glass, pObject.edict(), trX );

		CBaseEntity@ pHitZ = g_EntityFuncs.Instance( trZ.pHit );
		CBaseEntity@ pHitX = g_EntityFuncs.Instance( trX.pHit );

		if( !(pObject.pev.groundentity !is null || pObject.pev.flags & FL_ONGROUND == 0) || trZ.flFraction != 1.0 && trX.flFraction != 1.0 )
		{
			Vector appVec = Vector( Math.VecToAngles( trZ.vecEndPos - trOrigin.vecEndPos ).x, 0, -Math.VecToAngles( trX.vecEndPos - trOrigin.vecEndPos ).x );

			if( pHitX !is null && pHitX.IsBSPModel() )
				pObject.pev.angles.x = Math.ApproachAngle( appVec.x, pObject.pev.angles.x, flSpeed );

			if( pHitZ !is null && pHitZ.IsBSPModel() )
				pObject.pev.angles.z = Math.ApproachAngle( appVec.z, pObject.pev.angles.z, flSpeed );
		}
	}
}

CIns2Prop@ ShootProp( entvars_t@ pevOwner, Vector& in vecOrigin, Vector& in vecVelocity, Vector& in vecDropAngle, Vector& in vecAngVelocity, string szModel, 
	array<string> BounceSounds, float flVelFriction = 0.4f, float flAVelFriction = 0.7f, int iBodygroup = 0, int iSkingroup = 0, float flStartFadeOutTime = 5.0f )
{
	CBaseEntity@ cbeIns2Prop = g_EntityFuncs.CreateEntity( "proj_ins2prop" );
	CIns2Prop@ ins2Prop = cast<CIns2Prop@>( CastToScriptClass( cbeIns2Prop ) );

	g_EntityFuncs.SetOrigin( ins2Prop.self, vecOrigin );
	g_EntityFuncs.SetModel( ins2Prop.self, szModel );
	g_EntityFuncs.DispatchSpawn( ins2Prop.self.edict() );

	@ins2Prop.pev.owner 		= INS2BASE::ENT( pevOwner );
	ins2Prop.pev.velocity 		= vecVelocity;
	ins2Prop.pev.avelocity 		= vecAngVelocity;

	ins2Prop.m_flVelFriction 	= flVelFriction;
	ins2Prop.m_flAVelFriction 	= flAVelFriction;

	ins2Prop.pev.angles 		= vecDropAngle;
	ins2Prop.pev.body 			= iBodygroup;
	ins2Prop.pev.skin 			= iSkingroup;
	ins2Prop.m_szBounceSounds 	= BounceSounds;

	if( flStartFadeOutTime < 0.1 )
	{
		ins2Prop.pev.nextthink 	= g_Engine.time;
		ins2Prop.pev.velocity 	= g_vecZero;
	}
	ins2Prop.pev.dmgtime 		= g_Engine.time + flStartFadeOutTime;

	return ins2Prop;
}

void Register()
{
	if( g_CustomEntityFuncs.IsCustomEntity( "proj_ins2prop" ) )
		return;

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2PROP::CIns2Prop", "proj_ins2prop" );
	g_Game.PrecacheOther( "proj_ins2prop" );
}

}