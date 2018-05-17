unitDef = {
  unitname            = [[siegeship]],
  name                = [[Siegecraft]],
  description         = [[Heavy Alien Drone]],
  acceleration        = 0.048,
  activateWhenBuilt   = true,
  brakeRate           = 0.043,
  buildCostMetal      = 240,
  builder             = false,
  buildPic            = [[hoverassault.png]],
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  category            = [[GUNSHIP]],
  collisionVolumeOffsets = [[0 -8 0]],
  collisionVolumeScales  = [[30 34 36]],
  collisionVolumeType    = [[box]],  
  corpse              = [[DEAD]],
  cruiseAlt              = 250,

  customParams        = {
	modelradius    = [[10]],
	helptext       = [[An alien parasite found its way to highjack Halberd's corpse and use its hidden potential! Apparently it spits rockets.]],
  },

  damageModifier      = 0.25,
  explodeAs           = [[ATOMIC_BLAST]],
  footprintX          = 3,
  footprintZ          = 3,
  iconType            = [[hoverassault]],
  idleAutoHeal        = 5,
  idleTime            = 1800,
  maxDamage           = 1250,
  maxSlope            = 36,
  maxVelocity         = 5.2,
  minCloakDistance    = 19975,
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName          = [[hoverassault.s3o]],
  script              = [[hoverassault.lua]],
  selfDestructAs      = [[ATOMIC_BLAST]],

  sfxtypes            = {

    explosiongenerators = {
      [[custom:HEAVYHOVERS_ON_GROUND]],
      [[custom:beamerray]],
    },

  },

  sightDistance       = 385,
  sonarDistance       = 385,
  turninplace         = 0,
  turnRate            = 716,
  workerTime          = 0,

  weapons                = {

	{
      def                = [[ROCKET]], 
	  badTargetCategory	 = [[FIXEDWING GUNSHIP]],
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    },
	
  },


  weaponDefs             = {

     ROCKET = {
      name                    = [[ALIEN Rocket Launcher]],
      areaOfEffect            = 75,
	  burst                   = 25,
	  burstRate               = 0.01,
      cegTag                  = [[missiletrailred]],
      craterBoost             = 1,
      craterMult              = 2,

      customParams        = {
		light_camera_height = 1800,
      },
	  
      damage                  = {
        default = 100,
        planes  = 100,
        subs    = 100,
      },

      fireStarter             = 70,
      flightTime              = 3.5,
      impulseBoost            = 200,
      impulseFactor           = 1.4,
      interceptedByShieldType = 2,
      model                   = [[wep_m_hailstorm.s3o]],
      noSelfDamage            = true,
      predictBoost            = 1,
      range                   = 850,
      reloadtime              = 7,
      smokeTrail              = true,
      soundHit                = [[explosion/ex_med4]],
      soundHitVolume          = 8,
      soundStart              = [[weapon/missile/missile2_fire_bass]],
      soundStartVolume        = 7,
      startVelocity           = 230,
      texture2                = [[darksmoketrail]],
      tracks                  = false,
      trajectoryHeight        = 0.6,
      turnrate                = 1000,
      turret                  = true,
      weaponType              = [[MissileLauncher]],
      weaponVelocity          = 230,
	  wobble                  = 9000,
    },

  },



  featureDefs         = {

    DEAD  = {
      blocking         = false,
      featureDead      = [[HEAP]],
      footprintX       = 3,
      footprintZ       = 3,
      object           = [[hoverassault_dead.s3o]],
    },


    HEAP  = {
      blocking         = false,
      footprintX       = 3,
      footprintZ       = 3,
      object           = [[debris3x3c.s3o]],
    },

  },

}

return lowerkeys({ siegeship = unitDef })