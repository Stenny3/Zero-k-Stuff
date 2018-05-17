unitDef = {
  unitname            = [[aliengunship]],
  name                = [[A L I E N gunship]],
  description         = [[I WANT TO BELIEVE]],
  acceleration        = 0.135,
  brakeRate           = 0.108,
  buildCostMetal      = 2000,
  builder             = false,
  buildPic            = [[vehriot.png]],
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,	
  category            = [[GUNSHIP]],
  selectionVolumeOffsets = [[0 0 0]],
  selectionVolumeScales  = [[42 42 42]],
  selectionVolumeType    = [[ellipsoid]], 
  corpse              = [[DEAD]],

  customParams        = {
  },

  explodeAs           = [[BIG_UNITEX]],
  footprintX          = 3,
  footprintZ          = 3,
  iconType            = [[vehicleriot]],
  idleAutoHeal        = 15,
  idleTime            = 1800,
  leaveTracks         = true,
  maxDamage           = 2250,
  cruiseAlt           = 75,
  maxVelocity         = 3.35,
  maxWaterDepth       = 22,
  minCloakDistance    = 175,
  movementClass       = [[TANK3]],
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName          = [[corleveler_512.s3o]],
  selfDestructAs      = [[BIG_UNITEX]],

  sfxtypes            = {

    explosiongenerators = {
      [[custom:RAIDMUZZLE]],
      [[custom:LEVLRMUZZLE]],
      [[custom:RIOT_SHELL_L]],
    },

  },
  sightDistance       = 500,
  turninplace         = 0,
  turnRate            = 442,
  workerTime          = 0,

  weapons             = {

    {
      def                = [[vehriot_WEAPON]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    },

  },


  weaponDefs          = {

    vehriot_WEAPON = {
      name                    = [[Impulse Cannon Salvo]],
      areaOfEffect            = 144,
      avoidFeature            = true,
      avoidFriendly           = true,
      burnblow                = true,
      craterBoost             = 1,
      craterMult              = 0.5,
	  burst                   = 16,
	  burstrate = 0.08,

      customParams            = {
        reaim_time = 8, -- COB
        gatherradius = [[90]],
        smoothradius = [[60]],
        smoothmult   = [[0.08]],

		light_camera_height = 1500,
      },
	  
      damage                  = {
        default = 110.1,
        planes  = 110.1,
        subs    = 5.5,
      },

      edgeEffectiveness       = 0.5,
      explosionGenerator      = [[custom:FLASH64]],
      impulseBoost            = 120,
      impulseFactor           = 1.2,
      interceptedByShieldType = 1,
      noSelfDamage            = true,
      range                   = 320,
      reloadtime              = 9,
      soundHit                = [[weapon/cannon/generic_cannon]],
      soundStart              = [[weapon/cannon/outlaw_gun]],
      soundStartVolume        = 1,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 350,
    },

  },


  featureDefs         = {

    DEAD  = {
      blocking         = false,
      featureDead      = [[HEAP]],
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[leveler_d.dae]],
    },

    HEAP  = {
      blocking         = false,
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[debris2x2a.s3o]],
    },

  },

}

return lowerkeys({ aliengunship = unitDef })