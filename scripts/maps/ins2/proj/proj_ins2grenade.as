// Insurgency's Grenade Projectile Base
// Author: KernCore, thanks to Geckon and the SC Team that helped me out with the grenade, and with help from HL SDK/HL Enhanced

#include "../base"

namespace INS2GRENADEPROJECTILE
{

class CIns2Grenade : ScriptBaseMonsterEntity, INS2BASE::ExplosiveBase
{
	private float bouncetime = 0;
	private float m_flNextSlideUpdate, m_flNextAttack;
	private Vector m_vecPrev;
	private bool m_bRegisteredSound;
	bool m_bImpactGrenade;

	void Spawn()
	{
		Precache();
		self.pev.movetype = MOVETYPE_BOUNCE;
		self.pev.solid = SOLID_BBOX;
		self.pev.body = 1;
		//self.pev.sequence = 4;
		m_flNextSlideUpdate = 0;
		m_flNextAttack = 0;
		m_vecPrev = g_vecZero;
		m_bRegisteredSound = false;

		SetThink( ThinkFunction( this.TumbleThink ) );
		self.pev.nextthink = g_Engine.time + 0.1;

		g_EntityFuncs.SetSize( self.pev, Vector( -0.2, -0.2, -0.2 ), Vector( 0.2, 0.2, 0.2 ) );
	}

	void Precache()
	{
		g_Game.PrecacheModel( "sprites/smoke.spr" );
		g_Game.PrecacheModel( "sprites/zerogxplode.spr" );
		g_Game.PrecacheModel( SPR_EXPLOSION );
		g_Game.PrecacheModel( "sprites/WXplo1.spr" );
		g_Game.PrecacheModel( "sprites/steam1.spr" );
		//g_Game.PrecacheModel( "models/concrete_gibs.mdl" );
		INS2BASE::PrecacheSound( GrenadeExplode );
		INS2BASE::PrecacheSound( GrenadeWaterExplode );
		INS2BASE::PrecacheSound( GrenadeBounce );
		BaseClass.Precache();
	}

	void ImpactTouch( CBaseEntity@ pOther )
	{
		// don't hit the guy that launched this grenade
		if( @pOther.edict() == @self.pev.owner )
			return;

		// Only do damage if we're moving fairly fast
		if( m_flNextAttack < g_Engine.time && self.pev.velocity.Length() > 100 )
		{
			entvars_t@ pevOwner = @self.pev.owner.vars;
			if( pevOwner !is null )
			{
				TraceResult tr = g_Utility.GetGlobalTrace();
				g_WeaponFuncs.ClearMultiDamage();
				pOther.TraceAttack( pevOwner, 1, g_Engine.v_forward, tr, DMG_CLUB );
				g_WeaponFuncs.ApplyMultiDamage( self.pev, pevOwner );
			}
			m_flNextAttack = g_Engine.time + 1.0; // debounce
		}

		SetThink( ThinkFunction( this.Detonate ) );
		self.pev.nextthink = g_Engine.time + 0.0;
	}

	void BounceTouch( CBaseEntity@ pOther )
	{
		// don't hit the guy that launched this grenade
		if( @pOther.edict() == @self.pev.owner )
			return;

		// Only do damage if we're moving fairly fast
		if( m_flNextAttack < g_Engine.time && self.pev.velocity.Length() > 100 )
		{
			entvars_t@ pevOwner = @self.pev.owner.vars;
			if( pevOwner !is null )
			{
				TraceResult tr = g_Utility.GetGlobalTrace();
				g_WeaponFuncs.ClearMultiDamage();
				pOther.TraceAttack( pevOwner, 1, g_Engine.v_forward, tr, DMG_CLUB );
				g_WeaponFuncs.ApplyMultiDamage( self.pev, pevOwner );
			}
			m_flNextAttack = g_Engine.time + 1.0; // debounce
		}

		Vector vecTestVelocity;
		// this is my heuristic for modulating the grenade velocity because grenades dropped purely vertical
		// or thrown very far tend to slow down too quickly for me to always catch just by testing velocity.
		// trimming the Z velocity a bit seems to help quite a bit.
		vecTestVelocity = self.pev.velocity;
		vecTestVelocity.z *= 0.45;

		if( m_bRegisteredSound == false && vecTestVelocity.Length() <= 33 )
		{
			// grenade is moving really slow. It's probably very close to where it will ultimately stop moving.
			// go ahead and emit the danger sound.

			// register a radius louder than the explosion, so we make sure everyone gets out of the way
			GetSoundEntInstance().InsertSound( bits_SOUND_DANGER, self.pev.origin, int(self.pev.dmg / 0.5), 0.3, self );
			//CSoundEnt::InsertSound ( bits_SOUND_DANGER, pev->origin, pev->dmg / 0.5, 0.3, this );
			m_bRegisteredSound = true;
		}

		if( pOther.IsBSPModel() )
			self.pev.flags |= FL_ONGROUND;

		if( self.pev.flags & FL_ONGROUND != 0 && m_flNextSlideUpdate <= g_Engine.time )
		{
			// add a bit of static friction
			self.pev.velocity = self.pev.velocity * 0.9;
			self.pev.sequence = 1;
			m_flNextSlideUpdate = g_Engine.time + 0.1;
		}

		BounceSounds();

		self.pev.flags |= EF_NOINTERP;
		float flVelocity = (self.pev.origin - m_vecPrev).Length();
		self.pev.framerate = Math.min( 16.0, Math.max( 0.0, flVelocity * 8 ) );
		m_vecPrev = self.pev.origin;
	}

	void BounceSounds()
	{
		if( g_Engine.time < bouncetime )
			return;

		bouncetime = g_Engine.time + Math.RandomFloat( 0.4, 0.6 );

		if( g_Utility.GetGlobalTrace().flFraction < 1.0 )
		{
			if( g_Utility.GetGlobalTrace().pHit !is null )
			{
				CBaseEntity@ pHit = g_EntityFuncs.Instance( g_Utility.GetGlobalTrace().pHit );
				if( pHit.IsBSPModel() )
				{
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, GrenadeBounce[ Math.RandomLong( 0, GrenadeBounce.length() - 1 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
				}
			}
		}
	}

	void Detonate()
	{
		TraceResult tr;
		Vector vecSpot;
		vecSpot = self.GetOrigin() + Vector( 0, 0, 8 );
		g_Utility.TraceLine( vecSpot, vecSpot + Vector( 0, 0, -40 ), ignore_monsters, self.pev.pContainingEntity, tr );
		self.pev.flags &= ~EF_NOINTERP;
		Explode( tr );
	}

	void TumbleThink()
	{
		if( !self.IsInWorld() )
		{
			g_EntityFuncs.Remove( self );
			return;
		}

		self.StudioFrameAdvance();

		self.pev.nextthink = g_Engine.time + 0.1;

		/*if( self.pev.dmgtime - 1 < g_Engine.time )
		{
			CSoundEnt::InsertSound ( bits_SOUND_DANGER, pev->origin + pev->velocity * (pev->dmgtime - gpGlobals->time), 400, 0.1, this );
		}*/

		if( self.pev.flags & FL_ONGROUND != 0 || self.pev.groundentity !is null )
		{
			if( self.pev.velocity == g_vecZero )
				self.pev.framerate = 0;
			else
			{
				if( self.pev.sequence != 1 )
				{
					self.pev.sequence = 1;
					self.ResetSequenceInfo();
				}
				//self.pev.framerate = 1;
				self.pev.angles = Math.VecToAngles( self.pev.velocity );
			}
		}
		else
		{
			if( self.pev.sequence != 4 )
			{
				self.pev.sequence = 4;
				self.ResetSequenceInfo();
			}
			self.pev.angles = Math.VecToAngles( self.pev.velocity );
			self.pev.framerate = 1;
		}

		if( m_bImpactGrenade != true )
		{
			if( self.pev.dmgtime <= g_Engine.time )
			{
				SetThink( ThinkFunction( this.Detonate ) );
			}

			if( self.pev.waterlevel != WATERLEVEL_DRY )
			{
				self.pev.velocity = self.pev.velocity * 0.5;
				self.pev.framerate = 0.2;
			}
		}
	}

	void Explode( TraceResult pTrace )
	{
		//float flRndSound;
		self.pev.model = string_t();
		self.pev.solid = SOLID_NOT;
		self.pev.takedamage = DAMAGE_NO;

		entvars_t@ pevOwner;
		if( self.pev.owner !is null )
			@pevOwner = @self.pev.owner.vars;
		else
			@pevOwner = self.pev;

		g_PlayerFuncs.ScreenShake( self.pev.origin, 15.0, 50.0, 1.0, self.pev.dmg * 2.5 );

		//MsgTraceTexResult( self.GetOrigin() );

		// Pull out of the wall a bit
		if( pTrace.flFraction != 1.0 )
		{
			self.pev.origin = pTrace.vecEndPos + (pTrace.vecPlaneNormal * (self.pev.dmg - 24) * 0.6);
		}

		ExplodeMsg01( self.GetOrigin(), (self.pev.dmg - 50) * 0.60, 15 );
		ExplodeMsg02( self.GetOrigin(), (self.pev.dmg - 50) * 0.40, 30 );

		g_Utility.Sparks( self.GetOrigin() );
		GetSoundEntInstance().InsertSound( bits_SOUND_COMBAT, self.pev.origin, NORMAL_EXPLOSION_VOLUME, 1.5, self );

		g_WeaponFuncs.RadiusDamage( self.GetOrigin(), self.pev, pevOwner, self.pev.dmg, self.pev.dmg * 2.5, CLASS_NONE, DMG_BLAST );
		g_Utility.DecalTrace( pTrace, (Math.RandomLong( 0, 1 ) < 0.5) ? DECAL_SCORCH1 : DECAL_SCORCH2 );

		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );

		g_SoundSystem.PlaySound( self.edict(), CHAN_AUTO, (iContents == CONTENTS_WATER) ? GrenadeWaterExplode[ Math.RandomLong( 0, GrenadeWaterExplode.length() - 1 )] : 
			GrenadeExplode[ Math.RandomLong( 0, GrenadeExplode.length() - 1 )], 1.0f, 0.4, 0, PITCH_NORM, 0, false, self.pev.origin );

		self.pev.effects |= EF_NODRAW;
		SetThink( ThinkFunction( this.Smoke ) );
		self.pev.velocity = g_vecZero;
		self.pev.nextthink = g_Engine.time + 0.3;

		if( iContents != CONTENTS_WATER )
		{
			int sparkCount = Math.RandomLong( 1, 3 );
			for( int i = 0; i < sparkCount; i++ )
				g_EntityFuncs.Create( "spark_shower", self.pev.origin, pTrace.vecPlaneNormal, false );
		}
	}

	void Smoke()
	{
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		{
			g_Utility.Bubbles( self.GetOrigin() - Vector( 71, 71, 71 ), self.GetOrigin() + Vector( 71, 71, 71 ), 175 );
		}
		else
		{
			SmokeMsg( self.GetOrigin(), (self.pev.dmg - 50) * 0.35, 15 );
		}

		g_EntityFuncs.Remove( self );
	}
}

CIns2Grenade@ TossGrenade( entvars_t@ pevOwner, Vector vecStart, Vector vecVelocity, float flTime, float flDmg, string sModel, const string& in szName = "proj_ins2grenade", bool bIsImpactGrenade = false )
{
	CBaseEntity@ cbeIns2Grenade = g_EntityFuncs.CreateEntity( szName );
	CIns2Grenade@ ins2Grenade = cast<CIns2Grenade@>( CastToScriptClass( cbeIns2Grenade ) );

	//g_Game.AlertMessage( at_console, "Projectile Name: " + ins2Grenade.pev.classname + "\n" );

	g_EntityFuncs.SetOrigin( ins2Grenade.self, vecStart );
	g_EntityFuncs.SetModel( ins2Grenade.self, sModel );
	g_EntityFuncs.DispatchSpawn( ins2Grenade.self.edict() );

	ins2Grenade.pev.velocity = vecVelocity;
	ins2Grenade.pev.angles = Math.VecToAngles( ins2Grenade.pev.velocity );
	@ins2Grenade.pev.owner = INS2BASE::ENT( pevOwner );
	ins2Grenade.pev.gravity = 0.7;
	ins2Grenade.pev.friction = 0.65;
	ins2Grenade.pev.dmg = flDmg;
	ins2Grenade.m_bImpactGrenade = bIsImpactGrenade;

	if( ins2Grenade.m_bImpactGrenade != true )
	{
		ins2Grenade.SetTouch( TouchFunction( ins2Grenade.BounceTouch ) );

		if( flTime < 0.1 )
		{
			ins2Grenade.pev.nextthink = g_Engine.time;
			ins2Grenade.pev.velocity = g_vecZero;
		}
		ins2Grenade.pev.dmgtime = g_Engine.time + flTime;
	}
	else
	{
		ins2Grenade.SetTouch( TouchFunction( ins2Grenade.ImpactTouch ) );
	}

	return ins2Grenade;
}

void Register( const string& in szName = "proj_ins2grenade" )
{
	if( g_CustomEntityFuncs.IsCustomEntity( szName ) )
		return;

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2GRENADEPROJECTILE::CIns2Grenade", szName );
	g_Game.PrecacheOther( szName );
}

}