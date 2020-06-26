// Insurgency's Grenade Launcher Projectile Base
// Author: KernCore, with help from HL SDK/HL Weapon Edition

#include "../base"

namespace INS2GLPROJECTILE
{//Namespace start

class CIns2GL : ScriptBaseEntity, INS2BASE::ExplosiveBase
{
	private Vector vecSize( 0.2, 0.2, 0.2 );
	bool bRcktExplsions;

	void Spawn()
	{
		Precache();
		self.pev.movetype = MOVETYPE_BOUNCE;
		self.pev.solid = SOLID_BBOX;
		self.pev.gravity = 0.475;
		self.pev.sequence = 1;
		g_EntityFuncs.SetSize( self.pev, -vecSize, vecSize );
		SetTouch( TouchFunction( this.ExplodeTouch ) );
		SetThink( ThinkFunction( this.Fly ) );
		self.pev.nextthink = g_Engine.time + 0.1;
	}

	void Precache()
	{
		g_Game.PrecacheModel( "sprites/smoke.spr" );
		g_Game.PrecacheModel( "sprites/zerogxplode.spr" );
		g_Game.PrecacheModel( SPR_EXPLOSION );
		g_Game.PrecacheModel( "sprites/WXplo1.spr" );
		g_Game.PrecacheModel( "sprites/steam1.spr" );
		BaseClass.Precache();
	}

	void Think()
	{
		self.pev.angles = Math.VecToAngles( self.pev.velocity );
		self.pev.nextthink = g_Engine.time + 0.1;
	}

	void Fly()
	{
		NetworkMessage trail_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			trail_msg.WriteByte( TE_BEAMFOLLOW );
			trail_msg.WriteShort( self.entindex() ); //entity
			trail_msg.WriteShort( g_Game.PrecacheModel( "sprites/smoke.spr" ) ); //model
			trail_msg.WriteByte( 15 ); //life
			trail_msg.WriteByte( 3 ); //width
			trail_msg.WriteByte( 255 ); //r
			trail_msg.WriteByte( 255 ); //g
			trail_msg.WriteByte( 255 ); //b
			trail_msg.WriteByte( 100 ); //brightness
		trail_msg.End();

		SetThink( ThinkFunction( this.Think ) );
		self.pev.nextthink = g_Engine.time + 0.1;
	}

	void ExplodeTouch( CBaseEntity@ pOther )
	{
		self.pev.model = string_t();
		self.pev.solid = SOLID_NOT;
		self.pev.takedamage = DAMAGE_NO;
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );

		g_PlayerFuncs.ScreenShake( self.pev.origin, 15.0, 50.0, 1.0, self.pev.dmg * 3.0 );

		TraceResult tr;
		
		Vector vecSpot = self.pev.origin - self.pev.velocity.Normalize() * 32;
		Vector vecEnd = self.pev.origin + self.pev.velocity.Normalize() * 64;

		entvars_t@ pevOwner;
		if( self.pev.owner !is null )
			@pevOwner = @self.pev.owner.vars;
		else
			@pevOwner = self.pev;

		g_Utility.TraceLine( vecSpot, vecEnd, ignore_monsters, self.edict(), tr );

		//Move it out of the wall a bit
		if( tr.flFraction != 1.0 )
		{
			self.pev.origin = tr.vecEndPos + (tr.vecPlaneNormal * (self.pev.dmg - 24) * 0.55);
		}

		g_WeaponFuncs.RadiusDamage( self.GetOrigin(), self.pev, pevOwner, self.pev.dmg, self.pev.dmg * 2, CLASS_NONE, DMG_BLAST );

		ExplodeMsg01( self.GetOrigin(), (!bRcktExplsions) ? (self.pev.dmg - 30) * 0.32 : (self.pev.dmg - 50) * 0.315, 15 );
		ExplodeMsg02( self.GetOrigin(), (!bRcktExplsions) ? (self.pev.dmg - 30) * 0.30 : (self.pev.dmg - 50) * 0.30, 30 );

		//Kill the beam following the grenade
		NetworkMessage killbeam_msg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			killbeam_msg.WriteByte( TE_KILLBEAM );
			killbeam_msg.WriteShort( self.entindex() );
		killbeam_msg.End();

		GetSoundEntInstance().InsertSound( bits_SOUND_COMBAT, self.pev.origin, NORMAL_EXPLOSION_VOLUME, 1.5, self );

		g_Utility.DecalTrace( tr, (Math.RandomLong( 0, 1 ) < 0.5) ? DECAL_SCORCH1 : DECAL_SCORCH2 );

		if( !bRcktExplsions )
			g_SoundSystem.PlaySound( self.edict(), CHAN_AUTO, (iContents == CONTENTS_WATER) ? GrenadeWaterExplode[ Math.RandomLong( 0, GrenadeWaterExplode.length() - 1 )] : 
			GrenadeExplode[ Math.RandomLong( 0, GrenadeExplode.length() - 1 )], 1.0f, 0.3, 0, PITCH_NORM, 0, false, self.pev.origin );
		else
			g_SoundSystem.PlaySound( self.edict(), CHAN_AUTO, (iContents == CONTENTS_WATER) ? RocketWaterExplode[ Math.RandomLong( 0, RocketWaterExplode.length() - 1 )] : 
			RocketExplode[ Math.RandomLong( 0, RocketExplode.length() - 1 )], 1.0f, 0.3, 0, PITCH_NORM, 0, false, self.pev.origin );

		//Direct hit does additional damage
		if( pOther.pev.takedamage != DAMAGE_NO )
		{
			g_WeaponFuncs.ClearMultiDamage();
			pOther.TraceAttack( pevOwner, self.pev.dmg / 1.5, g_Engine.v_forward, tr, DMG_CLUB );
			g_WeaponFuncs.ApplyMultiDamage( self.pev, pevOwner );
		}

		g_Utility.Sparks( self.GetOrigin() );

		if( iContents != CONTENTS_WATER )
		{
			int sparkCount = Math.RandomLong( 1, 3 );
			for( int i = 0; i < sparkCount; i++ )
				g_EntityFuncs.Create( "spark_shower", self.pev.origin, tr.vecPlaneNormal, false );
		}

		self.pev.effects |= EF_NODRAW;
		SetThink( ThinkFunction( this.Smoke ) );
		self.pev.velocity = g_vecZero;
		self.pev.nextthink = g_Engine.time + 0.3;
	}

	void Smoke()
	{
		int iContents = g_EngineFuncs.PointContents( self.GetOrigin() );
		if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		{
			g_Utility.Bubbles( self.GetOrigin() - Vector( 70, 70, 70 ), self.GetOrigin() + Vector( 70, 70, 70 ), 150 );
		}
		else
		{
			SmokeMsg( self.GetOrigin(), (bRcktExplsions == false) ? (self.pev.dmg - 30) * 0.80 : (self.pev.dmg - 50) * 0.50, 15 );
		}

		g_EntityFuncs.Remove( self );
	}
}

CIns2GL@ ShootGrenade( entvars_t@ pevOwner, Vector vecStart, Vector vecVelocity, float dmg, string model, bool bRocketExplosions = false, const string& in szName = "proj_ins2gl" )
{
	CBaseEntity@ cbeIns2GL = g_EntityFuncs.CreateEntity( szName );
	CIns2GL@ ins2GL = cast<CIns2GL@>( CastToScriptClass( cbeIns2GL ) );

	g_Game.AlertMessage( at_console, "Projectile Name: " + ins2GL.pev.classname + "\n" );

	ins2GL.bRcktExplsions = bRocketExplosions;

	g_EntityFuncs.SetOrigin( ins2GL.self, vecStart );
	g_EntityFuncs.SetModel( ins2GL.self, model );
	g_EntityFuncs.DispatchSpawn( ins2GL.self.edict() );

	int iContents = g_EngineFuncs.PointContents( ins2GL.self.GetOrigin() );
	if( iContents == CONTENTS_WATER || iContents == CONTENTS_SLIME || iContents == CONTENTS_LAVA )
		ins2GL.pev.velocity = vecVelocity / 2;
	else
		ins2GL.pev.velocity = vecVelocity;

	@ins2GL.pev.owner = pevOwner.pContainingEntity;
	//ins2GL.pev.avelocity = Vector( Math.RandomFloat( -100, -500 ), 0, 0 );
	ins2GL.pev.angles = Math.VecToAngles( ins2GL.pev.velocity );
	ins2GL.pev.dmg = dmg;

	return ins2GL;
}

void Register( const string& in szName = "proj_ins2gl" )
{
	if( g_CustomEntityFuncs.IsCustomEntity( szName ) )
		return;

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2GLPROJECTILE::CIns2GL", szName );
	g_Game.PrecacheOther( szName );
}

}//Namespace end