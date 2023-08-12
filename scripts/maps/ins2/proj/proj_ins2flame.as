// Insurgency's Flame Entity
// Author: Unknown person, modified by KernCore to fit the Insurgency project

#include "../base"

namespace INS2FLAMEPROJECTILE
{

const array<string> FlameSpr = {
	"sprites/ins2/flame1.spr",
	"sprites/ins2/flame2.spr",
	"sprites/ins2/flame3.spr",
	"sprites/ins2/flame4.spr",
	"sprites/ins2/flame5.spr"
};
const string SPR_STEAM = "sprites/ins2/steam1.spr";
const string SPR_FIRE1 = "sprites/ins2/fireball1.spr";
const string SPR_FIRE2 = "sprites/ins2/fireball2.spr";

class CIns2Flame : ScriptBaseEntity, INS2BASE::ExplosiveBase
{
	private float flDynLTime = 0, flSprTTime = 0; //Sprite Messages Time
	private int m_iFlameSprite1, m_iFlameSprite2;

	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, FlameSpr[Math.RandomLong( 0, FlameSpr.length() - 1 )] );

		self.pev.rendermode = kRenderTransAdd;
		self.pev.rendercolor.x = 255;
		self.pev.rendercolor.y = 255;
		self.pev.rendercolor.z = 255;
		self.pev.renderamt = 250;
		self.pev.scale = 0.2;
		self.pev.movetype = MOVETYPE_FLY;
		self.pev.solid = SOLID_BBOX;
		self.pev.frame = 0;

		SetTouch( TouchFunction( this.FlameTouch ) );
		g_EntityFuncs.SetSize( self.pev, Vector( -3, -3, -3 ), Vector( 3, 3, 3 ) );
	}

	void Precache()
	{
		for( uint i = 0; i < FlameSpr.length(); i++ )
		{
			g_Game.PrecacheModel( FlameSpr[i] );
			g_Game.PrecacheGeneric( FlameSpr[i] );
		}

		g_Game.PrecacheModel( SPR_STEAM );
		m_iFlameSprite1 = g_Game.PrecacheModel( SPR_FIRE1 );
		m_iFlameSprite2 = g_Game.PrecacheModel( SPR_FIRE2 );
		g_Game.PrecacheModel( "sprites/steam1.spr" );
		BaseClass.Precache();
	}

	void FlameTouch( CBaseEntity@ pOther )
	{
		TraceResult tr = g_Utility.GetGlobalTrace();

		// OP4's Pit worm hack so it doesn't hit itself 
		if( pOther.pev.modelindex == self.pev.modelindex && tr.pHit !is null && self.pev.modelindex != tr.pHit.vars.modelindex )
		{
			return;
		}

		// don't hit the guy that launched this flame
		if( pOther.edict() is self.pev.owner )
			return;

		entvars_t@ pevOwner;
		if( self.pev.owner !is null )
			@pevOwner = @self.pev.owner.vars;
		else
			@pevOwner = self.pev;

		if( pOther.pev.takedamage != DAMAGE_NO && pOther.IsAlive() )
		{
			g_WeaponFuncs.ClearMultiDamage();

			if( pOther.pev.classname == "monster_cleansuit_scientist" || pOther.IsMachine() )
				pOther.TraceAttack( pevOwner, self.pev.dmg * 0.30, self.pev.velocity.Normalize(), tr, DMG_SLOWBURN | DMG_NEVERGIB );
			else if( pOther.pev.classname == "monster_gargantua" || pOther.pev.classname == "monster_babygarg" )
				pOther.TraceAttack( pevOwner, self.pev.dmg * 0.50, self.pev.velocity.Normalize(), tr, DMG_BURN | DMG_SLOWBURN | DMG_NEVERGIB );
			else
				pOther.TraceAttack( pevOwner, self.pev.dmg, self.pev.velocity.Normalize(), tr, DMG_BURN | DMG_SLOWBURN | DMG_NEVERGIB | DMG_POISON );

			g_WeaponFuncs.ApplyMultiDamage( self.pev, pevOwner );
		}

		if( pOther.IsBSPModel() )
		{
			//g_WeaponFuncs.ClearMultiDamage();
			g_WeaponFuncs.RadiusDamage( self.GetOrigin() + Vector( 0, 0, 4 ), self.pev, pevOwner, self.pev.dmg * 0.5, self.pev.dmg + 32, CLASS_NONE, DMG_BURN | DMG_SLOWBURN );
			//g_WeaponFuncs.ApplyMultiDamage( self.pev, pevOwner );
		}

		if( pOther is null || pOther.IsBSPModel() )
			g_Utility.DecalTrace( tr, DECAL_SMALLSCORCH1 + Math.RandomLong( 1, 2 ) );

		SetTouch( null );

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;
	}

	void RemoveEntity()
	{
		self.pev.effects |= EF_NODRAW;
		SmokeMsg( self.GetOrigin() + Vector( 0, 0, Math.RandomLong( 8, 32 ) ), 32, 14, SPR_STEAM );
		g_EntityFuncs.Remove( self );
	}

	private void DynamicLight() 
	{
		NetworkMessage DLight( MSG_PVS, NetworkMessages::SVC_TEMPENTITY, self.GetOrigin() );
			DLight.WriteByte( TE_DLIGHT );
			DLight.WriteCoord( self.GetOrigin().x );
			DLight.WriteCoord( self.GetOrigin().y );
			DLight.WriteCoord( self.GetOrigin().z );
			DLight.WriteByte( 12 ); //Radius
			DLight.WriteByte( 253 ); //R
			DLight.WriteByte( 226 ); //G
			DLight.WriteByte( 51 ); //B
			DLight.WriteByte( 1 ); //Life
			DLight.WriteByte( 1 ); //Decay
		DLight.End();
	}

	private void SpriteTrail()
	{
		NetworkMessage SprTrail( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			SprTrail.WriteByte( TE_SPRITETRAIL );
			SprTrail.WriteCoord( self.GetOrigin().x );
			SprTrail.WriteCoord( self.GetOrigin().y );
			SprTrail.WriteCoord( self.GetOrigin().z );
			SprTrail.WriteCoord( self.GetOrigin().x );
			SprTrail.WriteCoord( self.GetOrigin().y );
			SprTrail.WriteCoord( self.GetOrigin().z );

			switch( Math.RandomLong( 1, 2 ) )
			{
				case 1:
					SprTrail.WriteShort( m_iFlameSprite1 ); //Sprite
					break;

				case 2:
					SprTrail.WriteShort( m_iFlameSprite2 ); //Sprite
					break;
			}

			SprTrail.WriteByte( 1 ); //Count
			SprTrail.WriteByte( 1 ); //Life
			SprTrail.WriteByte( 1 ); //Scale
			SprTrail.WriteByte( Math.RandomLong( 6, 10 ) ); //Noise
			SprTrail.WriteByte( 10 ); //Speed
		SprTrail.End();
	}

	void AnimateThink()
	{
		self.pev.nextthink = g_Engine.time + 0.01;
		self.pev.framerate++;

		if( self.pev.framerate > 2 )
		{
			self.pev.frame++;
			self.pev.scale += 0.1;
			self.pev.framerate = 0;
		}

		if( self.pev.frame > 19 || g_EngineFuncs.PointContents( self.pev.origin ) == CONTENTS_WATER )
		{
			RemoveEntity();
			return;
		}

		if( self.pev.frame == 13 )
		{
			//SmokeMsg( self.GetOrigin() + Vector( 0, 0, Math.RandomLong( 8, 32 ) ), 32, 14, SPR_STEAM );
			SmokeMsg( self.GetOrigin() + Vector( 0, 0, Math.RandomLong( 0, 32 ) ), 16, 50 );
		}

		// DLight every 0.1 seconds
		if( flDynLTime < g_Engine.time )
		{
			DynamicLight();

			flDynLTime = g_Engine.time + 0.1;
		}

		if( flSprTTime < g_Engine.time )
		{
			SpriteTrail();

			flSprTTime = g_Engine.time + Math.RandomFloat( 0.2f, 0.4f );
		}
	}
}

CIns2Flame@ CreateFlames( entvars_t@ pevOwner, Vector vecStart, Vector vecVelocity, float dmg, const string& in szName = "proj_ins2flame" )
{
	CBaseEntity@ cbeIns2Flame = g_EntityFuncs.CreateEntity( szName, null, false );
	CIns2Flame@ ins2Flame = cast<CIns2Flame@>( CastToScriptClass( cbeIns2Flame ) );

	g_EntityFuncs.SetOrigin( ins2Flame.self, vecStart );
	g_EntityFuncs.DispatchSpawn( ins2Flame.self.edict() );

	ins2Flame.SetThink( ThinkFunction( ins2Flame.AnimateThink ) );
	ins2Flame.pev.nextthink = g_Engine.time + 0.1;

	ins2Flame.pev.origin.x += Math.RandomLong( -2, 2 );
	ins2Flame.pev.origin.z += Math.RandomLong( -2, 2 );

	ins2Flame.pev.velocity = vecVelocity;
	ins2Flame.pev.angles = Math.VecToAngles( ins2Flame.pev.velocity );
	ins2Flame.pev.dmg = dmg;
	@ins2Flame.pev.owner = pevOwner.pContainingEntity;

	return ins2Flame;
}

void Register( const string& in szName = "proj_ins2flame" )
{
	if( g_CustomEntityFuncs.IsCustomEntity( szName ) )
		return;

	g_CustomEntityFuncs.RegisterCustomEntity( "INS2FLAMEPROJECTILE::CIns2Flame", szName );
	g_Game.PrecacheOther( szName );
}

}