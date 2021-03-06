local DeathInfo =
{
	Name = "DeathInfo",
	Type = "System",
	Namespace = "C_DeathInfo",

	Functions =
	{
		{
			Name = "GetSelfResurrectOptions",
			Type = "Function",

			Returns =
			{
				{ Name = "options", Type = "table", InnerType = "SelfResurrectOption", Nilable = false },
			},
		},
		{
			Name = "UseSelfResurrectOption",
			Type = "Function",

			Arguments =
			{
				{ Name = "optionType", Type = "SelfResurrectOptionType", Nilable = false },
				{ Name = "id", Type = "number", Nilable = false },
			},
		},
	},

	Events =
	{
		{
			Name = "AreaSpiritHealerInRange",
			Type = "Event",
			LiteralName = "AREA_SPIRIT_HEALER_IN_RANGE",
		},
		{
			Name = "AreaSpiritHealerOutOfRange",
			Type = "Event",
			LiteralName = "AREA_SPIRIT_HEALER_OUT_OF_RANGE",
		},
		{
			Name = "ConfirmXpLoss",
			Type = "Event",
			LiteralName = "CONFIRM_XP_LOSS",
		},
		{
			Name = "CorpseInInstance",
			Type = "Event",
			LiteralName = "CORPSE_IN_INSTANCE",
		},
		{
			Name = "CorpseInRange",
			Type = "Event",
			LiteralName = "CORPSE_IN_RANGE",
		},
		{
			Name = "CorpseOutOfRange",
			Type = "Event",
			LiteralName = "CORPSE_OUT_OF_RANGE",
		},
		{
			Name = "PlayerAlive",
			Type = "Event",
			LiteralName = "PLAYER_ALIVE",
		},
		{
			Name = "PlayerDead",
			Type = "Event",
			LiteralName = "PLAYER_DEAD",
		},
		{
			Name = "PlayerSkinned",
			Type = "Event",
			LiteralName = "PLAYER_SKINNED",
			Payload =
			{
				{ Name = "hasFreeRepop", Type = "number", Nilable = false },
			},
		},
		{
			Name = "PlayerUnghost",
			Type = "Event",
			LiteralName = "PLAYER_UNGHOST",
		},
		{
			Name = "RequestCemeteryListResponse",
			Type = "Event",
			LiteralName = "REQUEST_CEMETERY_LIST_RESPONSE",
			Payload =
			{
				{ Name = "isGossipTriggered", Type = "bool", Nilable = false },
			},
		},
		{
			Name = "ResurrectRequest",
			Type = "Event",
			LiteralName = "RESURRECT_REQUEST",
			Payload =
			{
				{ Name = "inviter", Type = "string", Nilable = false },
			},
		},
		{
			Name = "SelfResSpellChanged",
			Type = "Event",
			LiteralName = "SELF_RES_SPELL_CHANGED",
		},
	},

	Tables =
	{
		{
			Name = "SelfResurrectOptionType",
			Type = "Enumeration",
			NumValues = 2,
			MinValue = 0,
			MaxValue = 1,
			Fields =
			{
				{ Name = "Spell", Type = "SelfResurrectOptionType", EnumValue = 0 },
				{ Name = "Item", Type = "SelfResurrectOptionType", EnumValue = 1 },
			},
		},
		{
			Name = "SelfResurrectOption",
			Type = "Structure",
			Fields =
			{
				{ Name = "name", Type = "string", Nilable = false },
				{ Name = "optionType", Type = "SelfResurrectOptionType", Nilable = false },
				{ Name = "id", Type = "number", Nilable = false },
				{ Name = "canUse", Type = "bool", Nilable = false },
				{ Name = "isLimited", Type = "bool", Nilable = false },
				{ Name = "priority", Type = "number", Nilable = false },
			},
		},
	},
};

APIDocumentation:AddDocumentationTable(DeathInfo);