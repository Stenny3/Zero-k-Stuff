unitDef = {
  unitname            = [[genocidedrone]],
  name                = [[Genocide Drone]],
  description         = [[You're dead mate]],
  acceleration        = 0.3,
  airHoverFactor      = 4,
  brakeRate           = 0.24,
  buildCostMetal      = 1200,
  builder             = false,
  buildPic            = [[dronecarry.png]],
  canBeAssisted       = false,
  canFly              = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canSubmerge         = false,
  category            = [[GUNSHIP]],
  collisionVolumeOffsets   = [[0 0 0]],
  collisionVolumeScales    = [[26 26 26]],
  collisionVolumeType      = [[ellipsoid]],
  collide             = false,
  cruiseAlt           = 820,
  explodeAs           = [[ATOMIC_BLAST]],
  floater             = true,
  footprintX          = 2,
  footprintZ          = 2,
  hoverAttack         = true,
  iconType            = [[smallgunship]],
  maxDamage           = 4000,
  maxVelocity         = 12.56,
  minCloakDistance    = 75,
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName          = [[carrydrone.s3o]],
  reclaimable         = false,
  script              = [[dronecarry.lua]],
  selfDestructAs      = [[ATOMIC_BLAST]],
  
  customParams        = {
	modelradius    = [[13]],
  },
  
  
  sfxtypes            = {

    explosiongenerators = {
      [[custom:brawlermuzzle]],
      [[custom:emg_shells_m]],
    },

  },
  sightDistance       = 500,
  turnRate            = 792,
  upright             = true,

  weapons             = {

    {
      def                = [[ARM_DRONE_WEAPON]],
      badTargetCategory  = [[FIXEDWING]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 90,
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    },

  },


  weaponDefs          = {

    ARM_DRONE_WEAPON = {
      name                    = [[ALIEN Shotgun]],
      areaOfEffect            = 8,
      burst                   = 42,
      burstrate               = 0.01,
      craterBoost             = 0,
      craterMult              = 0,
  
      customParams			= {
		light_camera_height = 2000,
		light_color = [[0.95 0.91 0.48]],
		light_radius = 150,
		timeslow_overslow_frames = 10*30,
		timeslow_damagefactor = 10,
      },

      damage                  = {
        default = 35,
        subs    = 35,
      },
	  groundBounce			  = true,
	  bouncerebound = 0.15,
	  numbounce = 40,
      explosionGenerator      = [[custom:EMG_HIT]],
      fireStarter             = 30,
      impactOnly              = true,
      impulseBoost            = 200,
      impulseFactor           = 1.4,
      intensity               = 0.7,
      interceptedByShieldType = 1,
      range                   = 450,
      reloadtime              = 2.6,
      rgbColor 				  = [[0.7 0 0.4]],
      size                    = 1.75,
      soundStart              = [[weapon/shotgun_firev4]],
      soundStartVolume        = 2,
      sprayAngle              = 6512,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 1000,
    },

  },

}

return lowerkeys({ genocidedrone = unitDef })