return
{
	ACTIONS =
	{
		JUMPIN =
		{
			USE = "Użyj",
		},
	},
	
	NAMES =
	{
		BASEMENT_ENTRANCE_BUILDER = "Piwnica",
		BASEMENT_ENTRANCE = "Właz",
		BASEMENT_EXIT = "Schody",
		BASEMENT_UPGRADE_WALL = "Blok kamienny",
		BASEMENT_UPGRADE_FLOOR_1 = "Skalista podłoga",
		BASEMENT_UPGRADE_FLOOR_2 = "Drewniana podłoga",
		BASEMENT_UPGRADE_FLOOR_3 = "Marmurowa podłoga",
		BASEMENT_UPGRADE_STAIRS_1 = "Kamienna podłoga",
		BASEMENT_UPGRADE_STAIRS_2 = "Szerokie schody",
		BASEMENT_UPGRADE_STAIRS_3 = "W pełni kamienne schody",
		BASEMENT_UPGRADE_STAIRS_4 = "Szerokie w pełni kamiennie schody",
		BASEMENT_UPGRADE_GUNPOWDER = "Katalizowany proch strzelniczy",
	},
	
	RECIPE_DESC =
	{
		BASEMENT_ENTRANCE_BUILDER = "Mglista krypta do schowania się.",
		BASEMENT_UPGRADE_WALL = "Użyj kilofa by cofnąć zmiany.",
		BASEMENT_UPGRADE_FLOOR_1 = "Podstawowa podłoga.",
		BASEMENT_UPGRADE_STAIRS_1 = "Podstawowe schody.",
		BASEMENT_UPGRADE_STAIRS_2 = "Szersza wersja.",
		BASEMENT_UPGRADE_STAIRS_3 = "Bez łuku.",
		BASEMENT_UPGRADE_STAIRS_4 = "Szerokie i bez łuku.",
		BASEMENT_UPGRADE_GUNPOWDER = "Rodzaj pożegnalnych fajerwerek.",
	},
	
	HUD =
	{
		BASEMENT =
		{
			ANNOUNCE_INVALID_POSITION = "Nie udało się znaleźć prawidłowej pozycji dla piwnicy.",
			ANNOUNCE_LOST_ENTITIES = "Po usunięciu piwnicy, te jednostki zostały zgubione pod gruzami:\n%s",
            BASEMENT_LIMIT_ANNOUNCEMENT = "Osiągnięto limit piwnic.",
		},
	},
	
    UI = 
    {
        CRAFTING_STATION_FILTERS = 
        {
            BASEMENT_EXIT = "Schody",
        },
        CRAFTING_FILTERS = 
        {
            BASEMENT = "Piwnica",
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
					LOWCEILING = "To tutaj nie pasuje.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Na dole substancje chemiczne bulgoczą.",
					OPEN = "Do Sekretnego Labolatorium!",
				},
				
				BASEMENT_EXIT = "To nieuprzejme wobec schodów.",
			},
		},
		
		WILLOW =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "To nie pasuje. Potem to spalę!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Czy ogień może tam dostac wystarczającą ilość powietrza?",
					OPEN = "Mogłam tu uwięzić dym.",
				},
				
				BASEMENT_EXIT = "Drewno opałowe jest tam.",
			},
		},
		
		WOLFGANG =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "To nie pasuje!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Straszna dziura jest zamknięta.",
					OPEN = "Wolfgang nie lubi strasznych piwnicy.",
				},
				
				BASEMENT_EXIT = "Uciekam z strasznego pomieszczenia!",
			},
		},
		
		WENDY =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "To tutaj nie pasuje... jak moja dusza.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Wszystko zabutelkowane, jak mój smutek.",
					OPEN = "Ktoś mógłby stać się głodny światła, jak ja jedzenia.",
				},
				
				BASEMENT_EXIT = "Bezczynność prowadzi do nikąd.",
			},
		},
		
		WX78 =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "MUSIMY PODNOSIĆ DACH.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "OTWÓRZ SZARE DRZWI PIWNICY",
					OPEN = "MIEJSCE DO UKRYCIA SIĘ PRZED LICHYMI",
				},
				
				BASEMENT_EXIT = "W GÓRĘ I ATOM",
			},
		},
		
		WICKERBOTTOM =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Wysokość tej piwnicy jest raczej ograniczona.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Mam nadzieję, że nikogo tam nie ma.",
					OPEN = "Ciche miejsce do czytania.",
				},
				
				BASEMENT_EXIT = "W tych schodach brakuje poręczy i balustrad.",
			},
		},
		
		WOODIE =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Ten pułap jest niższy niż upadły zimozielony eh?",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Super piwnicy, eh?",
					OPEN = "Głębiej niż dół kikuta co?",
				},
				
				BASEMENT_EXIT = "Chcesz pościnać parę drzew, Lucy?",
			},
		},
		
		WAXWELL =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Wygląda na to, że będziemy musieli to ograniczyć.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "To ich nie zatrzyma.",
					OPEN = "Charlie musi gdzieś się skradać.",
				},
				
				BASEMENT_EXIT = "Do światła dziennego.",
			},
		},
		
		WATHGRITHR =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "To nie jest odpowiedni etap do budowania tego.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Czy będzie tam jakiś przeciwnik?",
					OPEN = "Wolę walczyć.",
				},
				
				BASEMENT_EXIT = "Cały świat jest etapem!",
			},
		},
		
		WEBBER =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "To nie pasuje!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Chcemy wyciągnąć wtyczkę!",
					OPEN = "Na dole wygląda strasznie.",
				},
				
				BASEMENT_EXIT = "Nie powinienem bawić się na schodach.",
			},
		},
		
		WINONA =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Jest tu trochę zbyt ciasno.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Czas wychodzić!",
					OPEN = "Warsztat jest gotowy do biznesu.",
				},
				
				BASEMENT_EXIT = "Trochę szorstko na krawędziach, ale to zrobię.",
			},
		},
	},
}