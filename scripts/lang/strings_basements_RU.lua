return
{
	ACTIONS =
	{
		JUMPIN =
		{
			USE = "Использовать",
		},
	},
	
	NAMES =
	{
		BASEMENT_ENTRANCE_BUILDER = "Подвал",
		BASEMENT_ENTRANCE = "Люк",
		BASEMENT_EXIT = "Лестница",
		BASEMENT_UPGRADE_WALL = "Блок каменной стены",
		BASEMENT_UPGRADE_FLOOR_1 = "Каменное покрытие",
		BASEMENT_UPGRADE_FLOOR_2 = "Деревянное покрытие",
		BASEMENT_UPGRADE_FLOOR_3 = "Шахматное покрытие",
		BASEMENT_UPGRADE_STAIRS_1 = "Каменная лестница",
		BASEMENT_UPGRADE_STAIRS_2 = "Широкая каменная лестница",
		BASEMENT_UPGRADE_STAIRS_3 = "Полная каменная лестница",
		BASEMENT_UPGRADE_STAIRS_4 = "Широкая полная каменная лестница",
		BASEMENT_UPGRADE_GUNPOWDER = "Катализированный порох",
	},
	
	RECIPE_DESC =
	{
		BASEMENT_ENTRANCE_BUILDER = "Туманное убежище.",
		BASEMENT_UPGRADE_WALL = "Обрати изменения киркой.",
		BASEMENT_UPGRADE_FLOOR_1 = "Стандартное покрытие.",
		BASEMENT_UPGRADE_STAIRS_1 = "Стандартная лестница.",
		BASEMENT_UPGRADE_STAIRS_2 = "Более широкая.",
		BASEMENT_UPGRADE_STAIRS_3 = "Без арки.",
		BASEMENT_UPGRADE_STAIRS_4 = "Шире и без арки.",
		BASEMENT_UPGRADE_GUNPOWDER = "Своего рода прощальный фейерверк.",
	},
	
	HUD =
	{
		BASEMENT =
		{
			ANNOUNCE_INVALID_POSITION = "ОШИБКА! Не удалось найти пространства для генерации подвала.",
			ANNOUNCE_LOST_ENTITIES = "Данные объекты были похоронены под обломками подвала:\n%s",
            BASEMENT_LIMIT_ANNOUNCEMENT = "Достигнут предел количества подвалов.",
		},
	},
	
    UI = 
    {
        CRAFTING_STATION_FILTERS = 
        {
            BASEMENT_EXIT = "Лестница",
        },
        CRAFTING_FILTERS = 
        {
            BASEMENT = "Подвал",
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
					LOWCEILING = "Это здесь не поместится.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Внизу готовятся химикаты.",
					OPEN = "В подземелье!",
				},
				
				BASEMENT_EXIT = "Эта лестница сделана грубо.",
			},
		},
		
		WILLOW =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Это сюда не поместится. Тогда я сожгну это!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Хватит ли огню здесь воздуха?",
					OPEN = "Я могу удерживать внутри весь дым.",
				},
				
				BASEMENT_EXIT = "Наверху должны быть дрова.",
			},
		},
		
		WOLFGANG =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Не помещается!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Страшная дыра закрыта.",
					OPEN = "Вольфгангу не нравится страшный подвал.",
				},
				
				BASEMENT_EXIT = "Прочь из страшной комнаты!",
			},
		},
		
		WENDY =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Это здесь не поместится, как и моя душа...",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Все скрыто, словно мое горе.",
					OPEN = "Всякий будет жаждать света там во тьме.",
				},
				
				BASEMENT_EXIT = "Бездействие ведет в никуда.",
			},
		},
		
		WX78 =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "МЫ ДОЛЖНЫ ПОВЫСИТЬ ПОТОЛОК.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "ОТВОРИТЕСЬ СЕРЫЕ ВОРОТА",
					OPEN = "МЕСТО ДЛЯ ПОБЕГА ОТ ЖИВЫХ СУЩЕСТВ",
				},
				
				BASEMENT_EXIT = "ПОРА ЗА РАБОТУ",
			},
		},
		
		WICKERBOTTOM =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Высота этого подвала слишком ограничена.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Я надеюсь, что никого там нет.",
					OPEN = "Тихий уголок для чтения.",
				},
				
				BASEMENT_EXIT = "Этой лестнице не хватает перил.",
			},
		},
		
		WOODIE =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Этот потолок пониже упавшей ели.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Хм, прохладный подвальчик.",
					OPEN = "Глубже, чем яма от пеня.",
				},
				
				BASEMENT_EXIT = "Люси, пойдем рубить деревья?",
			},
		},
		
		WAXWELL =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Эту штуку придется уменьшить, чтобы поместить сюда.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Это не остановит Их.",
					OPEN = "Charlie must be creeping around somewhere.",
				},
				
				BASEMENT_EXIT = "Путь к дневному свету.",
			},
		},
		
		WATHGRITHR =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Этому не место на подобной сцене.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Окажется ли там мой противник?",
					OPEN = "Я лучше буду сражаться.",
				},
				
				BASEMENT_EXIT = "Весь мир – сцена!",
			},
		},
		
		WEBBER =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Это не поместится!",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Мы хотим подергать за затвор!",
					OPEN = "Там внизу немного жутковато.",
				},
				
				BASEMENT_EXIT = "Я не должен играться с лестницой.",
			},
		},
		
		WINONA =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "Тут немного тесновато.",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "Время перерыва!",
					OPEN = "Мастерская готова к работе.",
				},
				
				BASEMENT_EXIT = "Грубовата по краям, но сойдет.",
			},
		},
	},
}