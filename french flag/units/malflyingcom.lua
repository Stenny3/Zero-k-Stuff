unitDef = {
  unitname            = [[malflyingcom]],
  name                = [[Alien Infused Support Commander]],
  description         = [[Floating Support Bot]],
  acceleration        = 0.25,
  activateWhenBuilt   = true,
  brakeRate           = 0.45,
  buildCostMetal      = 1800,
  buildDistance       = 232,
  builder             = true,
  buildPic            = [[commsupport.png]],
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  collisionVolumeOffsets = [[0 0 0]],
  collisionVolumeScales  = [[45 50 45]],
  collisionVolumeType    = [[CylY]],  
  corpse              = [[DEAD]],
  category            = [[LAND]],
  
  customParams        = {
	helptext       = [[Aliens aliens aliens.Aliens aliens aliens.Aliens aliens aliens.Aliens aliens aliens.Aliens aliens aliens.Aliens aliens aliens.Aliens aliens aliens.Aliens aliens aliens. ALIENS!]],
    soundok = [[heavy_bot_move]],
    soundselect = [[bot_select]],
    soundbuild = [[builder_start]],
	modelradius    = [[25]],
    aimposoffset   = [[0 15 0]],
  },

  energyStorage       = 500,
  energyUse           = 0,
  explodeAs           = [[ESTOR_BUILDINGEX]],
  footprintX          = 2,
  footprintZ          = 2,
  iconType            = [[commander1]],
  idleAutoHeal        = 30,
  idleTime            = 0,
  leaveTracks         = false,
  losEmitHeight       = 40,
  cruiseAlt           = 10,
  maxDamage           = 3500,
  maxVelocity         = 3.8,
  maxWaterDepth       = 5000,
  metalStorage        = 500,
  minCloakDistance    = 300,
  movementClass       = [[AKBOT2]],
  noChaseCategory     = [[TERRAFORM FIXEDWING GUNSHIP HOVER SHIP SWIM SUB LAND FLOAT SINK TURRET]],
  objectName          = [[commsupport.s3o]],
  script              = [[dynsupport.lua]],
  selfDestructAs      = [[ESTOR_BUILDINGEX]],

  sfxtypes            = {

    explosiongenerators = {
      [[custom:flashmuzzle1]],
	  [[custom:NONE]],
	  [[custom:NONE]],
	  [[custom:NONE]],
	  [[custom:NONE]],
	  [[custom:NONE]],
    },

  },

  showNanoSpray       = false,
  sightDistance       = 500,
  sonarDistance       = 500,
  trackWidth          = 22,
  turnRate            = 1350,
  upright             = true,
  workerTime          = 30,

   weapons                = {

	{
      def                = [[LASER]],
      onlyTargetCategory = [[LAND SHIP SWIM FLOAT HOVER]],
      mainDir            = [[-1 -1 1]],
    },
  },
  
  weaponDefs             = {

    LASER = {
      name                    = [[ALIEN Repeater Rifle]],
      alphaDecay              = 0.12,
      areaOfEffect            = 16,
      bouncerebound           = 0.15,
      bounceslip              = 1,
      cegTag                  = [[gauss_tag_l]],
      craterBoost             = 0,
      craterMult              = 0,
	  burst                   = 3,
      burstrate               = 0.5,

      damage                  = {
        default = 500,
        planes  = 500,
        subs    = 500,
      },

      explosionGenerator      = [[custom:gauss_hit_m]],
      groundbounce            = 1,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 0,
      noExplode               = true,
      numbounce               = 40,
      range                   = 650,
      reloadtime              = 7,
      rgbColor                = [[1 0.2 0.2]],
      separation              = 0.5,
      size                    = 3.0,
      sizeDecay               = -0.1,
      soundHit                = [[weapon/gauss_hit]],
      soundStart              = [[weapon/gauss_fire]],
      sprayangle              = 1500,
      stages                  = 32,
      turret                  = true,
      waterbounce             = 1,
      weaponType              = [[Cannon]],
      weaponVelocity          = 2400,
    },
	},
  
  featureDefs         = {

    DEAD      = {
      blocking         = true,
      featureDead      = [[HEAP]],
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[commsupport_dead.s3o]],
    },

    HEAP      = {
      blocking         = false,
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[debris2x2c.s3o]],
    },

  },

}

return lowerkeys({ malflyingcom = unitDef })