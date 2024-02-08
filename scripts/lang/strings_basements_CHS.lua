return
{
	ACTIONS =
	{
		JUMPIN =
		{
			USE = "使用",
		},
	},
	
	NAMES =
	{
		BASEMENT_ENTRANCE_BUILDER = "地下室",
		BASEMENT_ENTRANCE = "地下室入口",
		BASEMENT_EXIT = "楼梯",
		BASEMENT_UPGRADE_WALL = "石墙块",
		BASEMENT_UPGRADE_FLOOR_1 = "岩石地板",
		BASEMENT_UPGRADE_FLOOR_2 = "木质地板",
		BASEMENT_UPGRADE_FLOOR_3 = "棋盘格地板",
		BASEMENT_UPGRADE_STAIRS_1 = "石制楼梯",
		BASEMENT_UPGRADE_STAIRS_2 = "宽版石制楼梯",
		BASEMENT_UPGRADE_STAIRS_3 = "无拱门石制楼梯",
		BASEMENT_UPGRADE_STAIRS_4 = "宽版无拱门石制楼梯",
		BASEMENT_UPGRADE_GUNPOWDER = "催化火药",
        BASEMENT_LAKE = "人造湖",
	},
	
	RECIPE_DESC =
	{
		BASEMENT_ENTRANCE_BUILDER = "一个迷雾缭绕的避难所。",
		BASEMENT_UPGRADE_WALL = "使用镐来撤销更改。",
		BASEMENT_UPGRADE_FLOOR_1 = "默认地板。",
		BASEMENT_UPGRADE_STAIRS_1 = "默认楼梯。",
		BASEMENT_UPGRADE_STAIRS_2 = "更宽的版本。",
		BASEMENT_UPGRADE_STAIRS_3 = "没有拱门。",
		BASEMENT_UPGRADE_STAIRS_4 = "宽版且没有拱门。",
		BASEMENT_UPGRADE_GUNPOWDER = "点燃火药摧毁地下室。",
        BASEMENT_LAKE = "地下室人造湖",
	},
	
	HUD =
	{
		BASEMENT =
		{
			ANNOUNCE_INVALID_POSITION = "错误！没有空间生成新的地下室。",
			ANNOUNCE_LOST_ENTITIES = "这些实体在地下室的废墟下丢失了：\n%s",
            BASEMENT_LIMIT_ANNOUNCEMENT = "地下室数量已达上限。",
		},
	},
	
    UI = 
    {
        CRAFTING_STATION_FILTERS = 
        {
            BASEMENT_EXIT = "楼梯",
        },
        CRAFTING_FILTERS = 
        {
            BASEMENT = "地下室",
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
					LOWCEILING = "这里放不下。",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "下面正冒着气泡。",
					OPEN = "去秘密实验室！",
				},
				
				BASEMENT_EXIT = "盯着楼梯是不礼貌的。",
			},
		},
		
		WILLOW =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "放不下，真想一把火烧了它！",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "下面的火能有足够的氧气吗？",
					OPEN = "我可以把烟困在这里。",
				},
				
				BASEMENT_EXIT = "上面有柴火。",
			},
		},
		
		WOLFGANG =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "放不下！",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "可怕的洞是关闭的。",
					OPEN = "沃尔夫冈不喜欢可怕的地下室。",
				},
				
				BASEMENT_EXIT = "逃离可怕的房间！",
			},
		},
		
		WENDY =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "它放不下，就像我的灵魂一样...",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "被封闭起来，就像我的悲伤。",
					OPEN = "一个人可能会像饿了一样渴望光。",
				},
				
				BASEMENT_EXIT = "不行动将通往无处。",
			},
		},
		
		WX78 =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "我们需要抬高屋顶。",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "打开地下室的灰色大门",
					OPEN = "一个躲避低等生物的地方",
				},
				
				BASEMENT_EXIT = "向上而行",
			},
		},
		
		WICKERBOTTOM =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "这个地下室的高度相当有限。",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "我真希望里面没有人。",
					OPEN = "一个安静的阅读地方。",
				},
				
				BASEMENT_EXIT = "这楼梯缺少扶手和栏杆。",
			},
		},
		
		WOODIE =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "这个天花板比倒下的常青树还低，是吧？",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "凉爽的地下室，是吧？",
					OPEN = "比树桩的坑还深，是吧？",
				},
				
				BASEMENT_EXIT = "露西，想去砍些树吗？",
			},
		},
		
		WAXWELL =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "看来我们需要将其缩小。",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "它无法阻止它们。",
					OPEN = "查理一定在某处徘徊。",
				},
				
				BASEMENT_EXIT = "走向光明。",
			},
		},
		
		WATHGRITHR =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "不是建造那个的合适舞台。",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "里面会有敌人吗？",
					OPEN = "我宁愿在战斗。",
				},
				
				BASEMENT_EXIT = "全世界都是一个舞台！",
			},
		},
		
		WEBBER =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "放不下！",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "我们想拔掉插头！",
					OPEN = "下面看起来很吓人。",
				},
				
				BASEMENT_EXIT = "我不应该在楼梯上玩。",
			},
		},
		
		WINONA =
		{
			ACTIONFAIL =
			{
				BUILD =
				{
					LOWCEILING = "这里有点太拥挤了。",
				},
			},
			
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "下班时间！",
					OPEN = "工坊开张了。",
				},
				
				BASEMENT_EXIT = "边缘有点粗糙，但可以接受。",
			},
		},
		
		WORTOX =
		{
			DESCRIBE =
			{
				BASEMENT_ENTRANCE =
				{
					GENERIC = "现在一个灵魂也过不去。",
					OPEN = "呼呼，自由来去！",
				},
				
				BASEMENT_EXIT = "提升体验。呼呼！",
			},
		},
	},
}