local function e_or_z(en, zh)
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = e_or_z("Basements", "地下室")
author = "OpenSource"
version = "1.2.6"

description =e_or_z(
    [[
Build your own basement, 
hide in it to avoid danger, 
and never forget to bring a light source to find your way out in the endless darkness.
    ]],
    [[
建造你自己的地下室，
躲在里面躲避危险，
永远不要忘记带着光源在无尽的黑暗中寻找出路。
    ]]
)

server_filter_tags = { name, author }

standalone = false
restart_required = false
dst_compatible = true
api_version_dst = 10
priority = -99
all_clients_require_mod = true
client_only_mod = false

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

local function header(label, client)
	return { name = "", label = label, options = { { description = "", data = "" } }, default = "", client = client }
end

local function AddConfig(label, name, hover, options, default)
	return {
		label = label,
		name = name,
		hover = hover or '',
		options = options or {
			{description = e_or_z("On", "开启"), data = true},
			{description = e_or_z("Off", "关闭"), data = false},
		},
		default = default
	}
end

local function basement_recipe(num_gold, num_cutstone, num_gunpowder)
    return (e_or_z("Gold Nugget", "黄金") .. " x") .. num_gold .. ", " .. (e_or_z("Cut Stone", "石砖") .. " x")  .. num_cutstone .. ", " .. (e_or_z("Gunpowder", "火药") .. " x") .. num_gunpowder
end

configuration_options = 
{
	{
		name = "language",
		label = e_or_z('Language', '语言'),
		hover = e_or_z([[Translates in-game strings. Currently available:
English, Chinese, Polish, Portuguese, Russian and Spanish.]],
[[翻译游戏内字符串。目前可用的语言有：英文、中文、波兰语、葡萄牙语、俄语和西班牙语。]]),
		options =
		{	
			{ description = "English", data = false, hover = "English" },
            { description = "中文", data = "CHS", hover = "中文 by Gin" },
			{ description = "Polish", data = "PL", hover = "Polish (Polski) by Hemcio" },
			{ description = "Portuguese", data = "PT", hover = "Brazilian Portuguese (Português) by Shadow Mario" },
			{ description = "Russian", data = "RU", hover = "Russian (Русский)" },
			{ description = "Spanish", data = "ES", hover = "Spanish (Español) by cratos315" },
		},
		default = "CHS",
	},

	{	
		name = "recipe_ingredients",
		label = e_or_z("Recipe Difficulty", "配方难度"),
		hover = e_or_z("Ingredients required for building a basement.", "建造地下室所需的材料。"),
		options =
		{
			{ description = e_or_z("Free", "免费"), data = [[return {Ingredient(CHARACTER_INGREDIENT.SANITY, 5)}]], hover = "󰀓 -5" },
			{ description = e_or_z("Easy", "简单"), data = [[return {Ingredient("goldnugget", 5), Ingredient("cutstone", 10), Ingredient("gunpowder", 5)}]], hover = basement_recipe(5, 10 ,5)},
			{ description = e_or_z("Medium", "普通"), data = [[return {Ingredient("goldnugget", 10), Ingredient("cutstone", 30), Ingredient("gunpowder", 10)}]], hover = basement_recipe(10, 30, 10)},
			{ description = e_or_z("Hard", "困难"), data = [[return {Ingredient("goldnugget", 15), Ingredient("cutstone", 60), Ingredient("gunpowder", 20)}]], hover = basement_recipe(15, 60, 20)}
		},
		default = [[return {Ingredient("goldnugget", 5), Ingredient("cutstone", 10), Ingredient("gunpowder", 5)}]],
	},

    {	
		name = "basement_limit",
		label = e_or_z("Basement Limit", "数量限制"),
		hover = e_or_z("Set the maximum number of basements allowed", "设置允许的地下室最大数量"),
		options =
		{
            { description = e_or_z("Unlimited", "不限制"), data = false },
            { description = e_or_z("1 Basement", "限1个"), data = 1 },
            { description = e_or_z("3 Basements", "限3个"), data = 3 },
            { description = e_or_z("5 Basements", "限5个"), data = 5 },
		},
		default = false,
	},

    AddConfig(e_or_z("Food spoilage", "食物腐烂"), "basement_no_perish", e_or_z("Prohibition of food spoilage in the basement", "禁止在地下室中食物腐烂"), nil, true),

    AddConfig(e_or_z("basement lake", "人造湖"), "enable_basement_lake", e_or_z("Enable basement lake", "是否启用地下室人造湖"), nil, true),

    header(e_or_z("Plants", "种植类")),

    AddConfig(e_or_z("All Seasons Farm Plant", "全季节种植"), "all_seasons_growth", e_or_z("Enable all seasons growth.", "启用全季节生长。"), nil, true),
    AddConfig(e_or_z("Rapid growth", "快速生长"), "rapid_growth", e_or_z("Enable quick grow.", "启用快速生长。"), nil, true),
    {	
		name = "multiple_harvest",
		label = e_or_z("multiple harvest", "多倍收获"),
		hover = e_or_z("Enable multiple harvests.", "启用多倍收获。"),
		options =
		{
            { description = e_or_z("Off", "禁用"), data = false},
            { description = e_or_z("x3", "3倍"), data = 3 },
            { description = e_or_z("x5", "5倍"), data = 5 },
            { description = e_or_z("x10", "10倍"), data = 10 },
		},
		default = false,
	},
    {	
		name = "farm_soil_grid",
		label = e_or_z("farm_plow_item", "耕地机相关"),
		hover = e_or_z("Get a 3x3/4x4/5x5 grid if using in basement", "在地下室使用将获得一个3x3/4x4/5x5的矩阵 "),
		options =
		{
            { description = e_or_z("Off", "关闭"), data = false},
			{ description = "3x3", data = 3 },
			{ description = "4x4", data = 4 },
			{ description = "5x5", data = 5 },
		},
		default = 3,
	},
}
