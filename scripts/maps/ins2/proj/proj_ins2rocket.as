// Insurgency's Rocket Projectile Base
// Author: KernCore, with help from HL SDK/HL Enhanced/HL Weapon Edition

#include "../base"

namespace INS2ROCKETPROJECTILE
{

const string ROCKET_LOOP = "ins2/wpn/rckt/loop.ogg";

class CIns2Rocket : ScriptBaseEntity, INS2BASE::ExplosiveBase
{
	private Vector vecSize( 0.2, 0.2, 0.2 );

	void Spawn()
	{
		Precache();
		self.pev.movetype = MOVETYPE_FLY;
		self.pev.solid = SOLID_BBOX;
		g_EntityFuncs.SetSize( self.pev, -vecSize, vecSize );
		self.pev.body = 1;
		self.pev.framerate = 30;
		self.pev.gravity = 0.05;
	}

	void Precache()
	{
		g_Game.PrecacheModel( "sprites/smoke.spr" );
		g_Game.PrecacheModel( "sprites/zerogxplode.spr" );
		g_Game.PrecacheModel( SPR_EXPLOSION );
		g_Game.PrecacheModel( "sprites/WXplo1.spr" );
		g_Game.PrecacheModel( "sprites/steam1.spr" );
		g_Game.PrecacheModel( "sprites/laserbeam.spr" );
		g_Game.PrecacheModel( "sprites/black_smoke3.spr" );

		g_SoundSystem.PrecacheSound( ROCKET_LOOP );
		g_Game.PrecacheGeneric( "sound/" + ROCKET_LOOP );

		INS2BASE::PrecacheSound( RocketExplode );
		INS2BASE::PrecacheSound( RocketWaterExplode );
		INS2BASE::PrecacheSound( ChargeExplode );
		INS2BASE::PrecacheSound( ChargeWaterExplode );

		BaseClass.Precache();
	}

	void EntThink()
	{
		self.pev.nextthink = g_Engine.time + 0.1;

		self.pev.angles = Math.VecToAngles( self.pev.velocity );
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		{
			g_Utility.Bubbles( self.GetOrigin() - Vector( 24, 24, 24 ), self.GetOrigin() + Vector( 24, 24, 24 ), 100 );
		}
		else
		{
			NetworkMessage smk_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
				smk_msg.WriteByte( TE_SMOKE ); //MSG type enum
				smk_msg.WriteCoord( self.pev.origin.x ); //pos
				smk_msg.WriteCoord( self.pev.origin.y ); //pos
				smk_msg.WriteCoord( self.pev.origin.z - 24 ); //pos
				smk_msg.WriteShort( g_Game.PrecacheModel( "sprites/black_smoke3.spr" ) );
				smk_msg.WriteByte( Math.RandomLong( 23, 29 ) ); //scale
				smk_msg.WriteByte( Math.RandomLong( 19, 21 ) ); //framerate
			smk_msg.End();
		}
	}

	/*NetworkMessage bc_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
		bc_msg.WriteByte( TE_BEAMCYLINDER );
		bc_msg.WriteCoord( self.GetOrigin().x );
		bc_msg.WriteCoord( self.GetOrigin().y );
		bc_msg.WriteCoord( self.GetOrigin().z );
		bc_msg.WriteCoord( self.GetOrigin().x );
		bc_msg.WriteCoord( self.GetOrigin().y );
		bc_msg.WriteCoord( self.GetOrigin().z + 448 );
		bc_msg.WriteShort( g_EngineFuncs.ModelIndex( "sprites/laserbeam.spr" ) );
		bc_msg.WriteByte( 0 ); //startframe
		bc_msg.WriteByte( 0 ); //framerate
		bc_msg.WriteByte( 4 ); //life
		bc_msg.WriteByte( 24 ); //width
		bc_msg.WriteByte( 0 ); //noise
		bc_msg.WriteByte( 255 ); //r
		bc_msg.WriteByte( 255 ); //g
		bc_msg.WriteByte( 192 ); //b
		bc_msg.WriteByte( 128 ); //brightness
		bc_msg.WriteByte( 0 ); //speed
	bc_msg.End();*/

	void ExplodeTouch( CBaseEntity@ pOther )
	{
		SetThink( null );
		self.pev.model = string_t();
		self.pev.solid = SOLID_NOT;
		self.pev.takedamage = DAMAGE_NO;
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		self.pev.effects &= ~EF_DIMLIGHT | EF_LIGHT;

		g_PlayerFuncs.ScreenShake( self.pev.origin, 15.0, 50.0, 1.0, self.pev.dmg * 2.5 );

		TraceResult tr;
		
		Vector vecSpot = self.pev.origin - self.pev.velocity.Normalize() * 32;
		Vector vecEnd = self.pev.origin + self.pev.velocity.Normalize() * 64;

		entvars_t@ pevOwner;
		if( self.pev.owner !is null )
			@pevOwner = @self.pev.owner.vars;
		else
			@pevOwner = self.pev;

		g_Utility.TraceLine( vecSpot, vecEnd, ignore_monsters, self.edict(), tr );

		//Direct hit does additional damage
		if( pOther.pev.takedamage != DAMAGE_NO )
		{
			g_WeaponFuncs.ClearMultiDamage();
			pOther.TraceAttack( pevOwner, self.pev.dmg / 3, g_Engine.v_forward, tr, DMG_CLUB );
			g_WeaponFuncs.ApplyMultiDamage( self.pev, pevOwner );
		}

		//Move it out of the wall a bit
		if( tr.flFraction != 1.0 )
		{
			self.pev.origin = tr.vecEndPos + (tr.vecPlaneNormal * (self.pev.dmg - 64) * 0.6);
		}

		g_WeaponFuncs.RadiusDamage( self.GetOrigin(), self.pev, pevOwner, self.pev.dmg, self.pev.dmg * 1.75, CLASS_NONE, DMG_BLAST );

		ExplodeMsg01( self.GetOrigin(), (self.pev.dmg - 50) * 0.35, 15 );
		ExplodeMsg02( self.GetOrigin(), (self.pev.dmg - 50) * 0.30, 30 );

		//Kill the beam following the rocket
		NetworkMessage killbeam_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			killbeam_msg.WriteByte( TE_KILLBEAM );
			killbeam_msg.WriteShort( self.entindex() );
		killbeam_msg.End();

		g_Utility.DecalTrace( tr, (Math.RandomLong( 0, 1 ) < 0.5) ? DECAL_SCORCH1 : DECAL_SCORCH2 );

		if( self.pev.dmg >= 275 )
		{
			g_SoundSystem.PlaySound( self.edict(), CHAN_AUTO, (iContents == CONTENTS_WATER) ? ChargeWaterExplode[ Math.RandomLong( 0, ChargeWaterExplode.length() - 1 )] : 
			ChargeExplode[ Math.RandomLong( 0, ChargeExplode.length() - 1 )], 1.0f, 0.3, 0, PITCH_NORM, 0, false, self.pev.origin );
		}
		else
		{
			g_SoundSystem.PlaySound( self.edict(), CHAN_AUTO, (iContents == CONTENTS_WATER) ? RocketWaterExplode[ Math.RandomLong( 0, RocketWaterExplode.length() - 1 )] : 
			RocketExplode[ Math.RandomLong( 0, RocketExplode.length() - 1 )], 1.0f, 0.3, 0, PITCH_NORM, 0, false, self.pev.origin );
		}

		GetSoundEntInstance().InsertSound( bits_SOUND_COMBAT, self.pev.origin, NORMAL_EXPLOSION_VOLUME, 1.5, self );

		g_Utility.Sparks( self.GetOrigin() );
		g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, ROCKET_LOOP );

		if( iContents != CONTENTS_WATER )
		{
			int sparkCount = Math.RandomLong( 1, 3 );
			for( int i = 0; i < sparkCount; i++ )
			{
				g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, ROCKET_LOOP );
				g_EntityFuncs.Create( "spark_shower", self.pev.origin, tr.vecPlaneNormal, false );
			}
		}

		SetThink( ThinkFunction( this.Smoke ) );
		self.pev.velocity = g_vecZero;
		self.pev.nextthink = g_Engine.time + 0.3;
	}

	void Remove()
	{
		SetThink( null );
		g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, ROCKET_LOOP );
		self.pev.effects |= EF_NODRAW;
		g_EntityFuncs.Remove( self );
	}

	void Smoke()
	{
		SetThink( null );
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		{
			g_Utility.Bubbles( self.GetOrigin() - Vector( 72, 72, 72 ), self.GetOrigin() + Vector( 72, 72, 72 ), 200 );
		}
		else
		{
			SmokeMsg( self.GetOrigin(), (self.pev.dmg - 50) * 0.50, 15 );
		}

		SetThink( ThinkFunction( this.Remove ) );
		self.pev.nextthink = g_Engine.time + 0.01f;
	}

	void Ignite()
	{
		self.pev.effects |= EF_DIMLIGHT | EF_LIGHT;
		self.pev.movetype = MOVETYPE_TOSS;
		self.pev.sequence = 2;
		//g_Game.AlertMessage( at_console, "Entity Ignited\n" );

		NetworkMessage trail_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			trail_msg.WriteByte( TE_BEAMFOLLOW );
			trail_msg.WriteShort( self.entindex() ); //entity
			trail_msg.WriteShort( g_Game.PrecacheModel( "sprites/smoke.spr" ) ); //model
			trail_msg.WriteByte( 5 ); //life
			trail_msg.WriteByte( 4 ); //width
			trail_msg.WriteByte( 224 ); //r
			trail_msg.WriteByte( 224 ); //g
			trail_msg.WriteByte( 255 ); //b
			trail_msg.WriteByte( 255 ); //brightness
		trail_msg.End();

		if( self.edict() !is null )
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, ROCKET_LOOP, 1.0, 0.4, SND_FORCE_LOOP, PITCH_NORM );

		SetThink( ThinkFunction( this.EntThink ) );
		self.pev.nextthink = g_Engine.time + 0.1;
	}

	//Trying to kill the loopsound in case it keeps repeating
	void Killed( entvars_t@ pevAttacker, int iGib )
	{
		//g_Game.AlertMessage( at_console, "Entity was killed\n" );
		g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, ROCKET_LOOP );
	}

	void UpdateOnRemove()
	{
		//g_Game.AlertMessage( at_console, "Entity was removed\n" );
		g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, ROCKET_LOOP );
		BaseClass.UpdateOnRemove();
	}
}

CIns2Rocket@ ShootRocket( entvars_t@ pevOwner, Vector vecStart, Vector vecVelocity, string sModel, float dmg, const string& in szName = "proj_ins2rocket" )
{
	CBaseEntity@ cbeIns2Rocket = g_EntityFuncs.CreateEntity( szName );
	CIns2Rocket@ ins2Rocket = cast<CIns2Rocket@>( CastToScriptClass( cbeIns2Rocket ) );

	//g_Game.AlertMessage( at_console, "Projectile Name: " + ins2Rocket.pev.classname + "\n" );

	g_EntityFuncs.SetOrigin( ins2Rocket.self, vecStart );
	g_EntityFuncs.SetModel( ins2Rocket.self, sModel );
	g_EntityFuncs.DispatchSpawn( ins2Rocket.self.edict() );

	int iContents = g_EngineFuncs.PointContents( ins2Rocket.self.GetOrigin() );
	if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		ins2Rocket.pev.velocity = vecVelocity / 2;
	else
		ins2Rocket.pev.velocity = vecVelocity;

	ins2Rocket.pev.angles = Math.VecToAngles( ins2Rocket.pev.velocity );
	@ins2Rocket.pev.owner = @pevOwner.pContainingEntity;

	ins2Rocket.SetThink( ThinkFunction( ins2Rocket.Ignite ) );
	ins2Rocket.pev.nextthink = g_Engine.time + 0.1;
	ins2Rocket.SetTouch( TouchFunction( ins2Rocket.ExplodeTouch ) );
	ins2Rocket.pev.dmg = dmg;
	ins2Rocket.pev.sequence = 1;

	return ins2Rocket;
}

void Register( const string& in szName = "proj_ins2rocket" )
{
	if( g_CustomEntityFuncs.IsCustomEntity( szName ) )
		return;

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2ROCKETPROJECTILE::CIns2Rocket", szName );
	g_Game.PrecacheOther( szName );
}

}