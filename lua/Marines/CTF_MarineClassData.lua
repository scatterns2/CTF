kClassTypes = enum {
	"Medic",
	"Recon",
	"Engineer",
	"Assault",
}

kClassTypesData = {
	--medic 
	[kClassTypes.Medic] = {
		speedBase 		 = 6.5,
		healthBase 		 = 125,	
		weaponPrimary	 = Flamethrower.kMapName,
		weaponSecondary  = Pistol.kMapName,
		weaponTertiary   = Axe.kMapName,
		classItem		 = GasGrenadeThrower.kMapName,
		classSpecial     = LayMines.kMapName,
		avatarModel 	 = PrecacheAsset("models/marine/male/male.model"),
		avatarGraph		 = PrecacheAsset("models/marine/male/male.animation_graph"),
	},
	--recon
	[kClassTypes.Recon]    = {
		speedBase  		 = 8,
		healthBase 		 = 100,
		weaponPrimary	 = Rifle.kMapName,
		weaponSecondary  = Pistol.kMapName,
		weaponTertiary   = Katana.kMapName,
		classItem		 = PulseGrenadeThrower.kMapName,
		classSpecial     = LayMines.kMapName,
		avatarModel 	 = PrecacheAsset("models/marine/male/male.model"),
		avatarGraph		 = PrecacheAsset("models/marine/male/male.animation_graph"),
	},
	--engineer
	[kClassTypes.Engineer] = {
		speedBase  		 = 6,
		healthBase 		 = 150,
		weaponPrimary 	 = Shotgun.kMapName,
		weaponSecondary  = Pistol.kMapName,
		weaponTertiary   = Welder.kMapName,
		classItem		 = LayMines.kMapName,
		classSpecial     = MarineStructureAbility.kMapName,
		avatarModel 	 = PrecacheAsset("models/marine/female/female.model"),
		avatarGraph		 = PrecacheAsset("models/marine/male/male.animation_graph"),

	},
	--assault
	[kClassTypes.Assault] = {
		speedBase 		 = 5,
		healthBase 		 = 175,
		weaponPrimary 	 = HeavyMachineGun.kMapName,
		weaponSecondary  = Pistol.kMapName,
		weaponTertiary   = Axe.kMapName,
		classItem		 = ClusterGrenadeThrower.kMapName,
		//classSpecial     = AmmoPack.kMapName ,
		avatarModel 	 = PrecacheAsset("models/marine/female/female.model"),
		avatarGraph		 = PrecacheAsset("models/marine/male/male.animation_graph"),
	},
}	
			
	


	