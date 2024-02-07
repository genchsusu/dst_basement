return
{
	ACTIONS =
	{
		JUMPIN =
		{
			USE = "Use",
		},
	},
	
	NAMES =
	{
		BASEMENT_ENTRANCE_BUILDER = "Basement",
		BASEMENT_ENTRANCE = "Hatch",
		BASEMENT_EXIT = "Stairs",
		BASEMENT_UPGRADE_WALL = "Stone Wall Block",
		BASEMENT_UPGRADE_FLOOR_1 = "Rocky Flooring",
		BASEMENT_UPGRADE_FLOOR_2 = "Wooden Flooring",
		BASEMENT_UPGRADE_FLOOR_3 = "Checkered Flooring",
		BASEMENT_UPGRADE_STAIRS_1 = "Stone Stairs",
		BASEMENT_UPGRADE_STAIRS_2 = "Wide Stone Stairs",
		BASEMENT_UPGRADE_STAIRS_3 = "Full Stone Stairs",
		BASEMENT_UPGRADE_STAIRS_4 = "Wide Full Stone Stairs",
		BASEMENT_UPGRADE_GUNPOWDER = "Catalyzed Gunpowder",
	},
	
	RECIPE_DESC =
	{
		BASEMENT_ENTRANCE_BUILDER = "A misty vault to hide in.",
		BASEMENT_UPGRADE_WALL = "Use a pickaxe to revert the changes.",
		BASEMENT_UPGRADE_FLOOR_1 = "Default flooring.",
		BASEMENT_UPGRADE_STAIRS_1 = "Default stairs.",
		BASEMENT_UPGRADE_STAIRS_2 = "Wider version.",
		BASEMENT_UPGRADE_STAIRS_3 = "Without an arch.",
		BASEMENT_UPGRADE_STAIRS_4 = "Wide and no arch.",
		BASEMENT_UPGRADE_GUNPOWDER = "A kind of farewell firework.",
	},
	
	HUD =
	{
		BASEMENT =
		{
			ANNOUNCE_INVALID_POSITION = "ERROR! No space left to generate new basement.",
			ANNOUNCE_LOST_ENTITIES = "These entities have been lost under basement rubble:\n%s",
            BASEMENT_LIMIT_ANNOUNCEMENT = "The basement limit has been reached.",
		},
	},
	
    UI = 
    {
        CRAFTING_STATION_FILTERS = 
        {
            BASEMENT_EXIT = "Stairs",
        },
        CRAFTING_FILTERS = 
        {
            BASEMENT = "Basement",
        },
    },
	
	CHARACTERS =
	{
		GENERIC =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It won't fit in here.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "The chemicals are bubbling below.",
					OPEN = "To the Secret Lab!",
				},
				
				BASEMENT_EXIT = "It's impolite to stairs.",
			},
		},
		
		WILLOW =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It won't fit. Then I will burn it!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Can the fire get enough air down there?",
					OPEN = "I could trap the smoke in here.",
				},
				
				BASEMENT_EXIT = "The firewood is up there.",
			},
		},
		
		WOLFGANG =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It not fit!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Scary hole is closed.",
					OPEN = "Wolfgang dislike scary basement.",
				},
				
				BASEMENT_EXIT = "Escape scary room!",
			},
		},
		
		WENDY =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It won't fit here, like my soul...",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "All bottled up like my grief.",
					OPEN = "One could grow as hungry for light as for food.",
				},
				
				BASEMENT_EXIT = "Inaction leads nowhere.",
			},
		},
		
		WX78 =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "WE MUST RAISE THE ROOF.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "OPEN THE CELLAR'S GRAY DOORS",
					OPEN = "A PLACE TO HIDE FROM INFERIORS",
				},
				
				BASEMENT_EXIT = "UP AND ATOM",
			},
		},
		
		WICKERBOTTOM =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "The height of this basement is rather limited.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "I do hope no one is in there.",
					OPEN = "A quiet place to read.",
				},
				
				BASEMENT_EXIT = "These stairs are lacking railings and balusters.",
			},
		},
		
		WOODIE =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "This ceiling is lower than a fallen evergreen eh?",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Cool basement, eh?",
					OPEN = "Deeper than the pit of a stump eh?",
				},
				
				BASEMENT_EXIT = "Wanna go chopping some trees, Lucy?",
			},
		},
		
		WAXWELL =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It seems we will need to cut this down to size.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "It will not stop Them.",
					OPEN = "Charlie must be creeping around somewhere.",
				},
				
				BASEMENT_EXIT = "Up to the light of day.",
			},
		},
		
		WATHGRITHR =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Not a proper stage for building that.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Will there be a foe in there?",
					OPEN = "I would rather be fighting.",
				},
				
				BASEMENT_EXIT = "All the world's a stage!",
			},
		},
		
		WEBBER =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It won't fit!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "We want to pull the plug!",
					OPEN = "It looks scary down there.",
				},
				
				BASEMENT_EXIT = "I'm not supposed to play on the stairs.",
			},
		},
		
		WINONA =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "It's a bit too cramped in here.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Quittin' time!",
					OPEN = "The workshop is open for business.",
				},
				
				BASEMENT_EXIT = "A bit rough on the edges, but it'll do.",
			},
		},
		
		WORTOX =
		{
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Not a single soul can pass now.",
					OPEN = "Hyuyu, free to come and go!",
				},
				
				BASEMENT_EXIT = "A lifting experience. Hyuyu!",
			},
		},
	},
}