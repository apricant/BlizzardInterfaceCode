
MAX_TALENT_GROUPS = 2;
MAX_TALENT_TABS = 4;
MAX_TALENT_TIERS = 7;
NUM_TALENT_COLUMNS = 3;

DEFAULT_TALENT_SPEC = "spec1";
DEFAULT_TALENT_TAB = 1;

local min = min;
local max = max;
local huge = math.huge;
local rshift = bit.rshift;

function TalentFrame_Load(TalentFrame)

end

function TalentFrame_Clear(TalentFrame)
	if ( not TalentFrame ) then
		return;
	end

	for tier=1, 6 do
		for column=1, 3 do
			local button = TalentFrame["tier"..tier]["talent"..column];
			if(button ~= nil) then
				SetDesaturation(button.icon, true);
				button.border:Hide();
			end
		end
	end
end

function TalentFrame_Update(TalentFrame, talentUnit)
	if ( not TalentFrame ) then
		return;
	end
	-- have to disable stuff if not active talent group
	local disable;
	if ( TalentFrame.inspect ) then
		-- even though we have inspection data for more than one talent group, we're only showing one for now
		disable = false;
	else
		disable = ( TalentFrame.talentGroup ~= GetActiveSpecGroup(TalentFrame.inspect) );
	end
	if(TalentFrame.bg ~= nil) then
		TalentFrame.bg:SetDesaturated(disable);
	end
	
	for tier=1, MAX_TALENT_TIERS do
		local talentRow = TalentFrame["tier"..tier];
		local rowAvailable = true;
		
		local tierAvailable, selectedTalent = GetTalentTierInfo(tier, TalentFrame.talentGroup, TalentFrame.inspect, talentUnit);
		-- Skip updating rows that we recently selected a talent for but have not received a server response
		if (TalentFrame.inspect or not TalentFrame.talentInfo[tier] or
			(selectedTalent ~= 0 and TalentFrame.talentInfo[tier] == selectedTalent)) then
			
			if (not TalentFrame.inspect and selectedTalent ~= 0) then
				TalentFrame.talentInfo[tier] = nil;
			end
			
			local restartGlow = false;
			for column=1, NUM_TALENT_COLUMNS do
				-- Set the button info
				local talentID, name, iconTexture, selected, available, _, _, _, _, _, grantedByAura = GetTalentInfo(tier, column, TalentFrame.talentGroup, TalentFrame.inspect, talentUnit);
				local button = talentRow["talent"..column];
				button.tier = tier;
				button.column = column;
				
				if (button and name) then
					button:SetID(talentID);

					SetItemButtonTexture(button, iconTexture);
					if(button.name ~= nil) then
						button.name:SetText(name);
					end

					if(button.knownSelection ~= nil) then
						if ( grantedByAura ) then
							button.knownSelection:Show();
							button.knownSelection:SetAtlas("Talent-Selection-Legendary");
							button.knownSelection:SetDesaturated(disable);
						elseif ( selected ) then
							button.knownSelection:Show();
							button.knownSelection:SetAtlas("Talent-Selection");
							button.knownSelection:SetDesaturated(disable);
						else
							button.knownSelection:Hide();
						end
					end
					button.shouldGlow = (available and not selected) and talentUnit == "player";
					if ( button.grantedByAura ~= grantedByAura ) then
						button.grantedByAura = grantedByAura;
						restartGlow = true;
					end
					
					if( TalentFrame.inspect ) then
						SetDesaturation(button.icon, not (selected or grantedByAura));
						button.border:SetShown(selected or grantedByAura);
						if ( grantedByAura ) then
							local color = ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_LEGENDARY];
							button.border:SetVertexColor(color.r, color.g, color.b);
						else
							button.border:SetVertexColor(1, 1, 1);
						end
					else
						button.disabled = (not tierAvailable or disable);
						SetDesaturation(button.icon, (button.disabled or (selectedTalent ~= 0 and not selected)) and not grantedByAura);
						button.Cover:SetShown(button.disabled);
						button.highlight:SetAlpha((selected or not tierAvailable) and 0 or 1);
					end
					
					button:Show();
				elseif (button) then
					button:Hide();
				end
			end
			TalentFrame_UpdateRowGlow(talentRow, restartGlow);
			-- do tier level number after every row
			if(talentRow.level ~= nil) then
				if ( selectedTalent == 0 and tierAvailable) then
					talentRow.level:SetTextColor(1, 0.82, 0);
				else
					talentRow.level:SetTextColor(0.5, 0.5, 0.5);
				end
			end
		end
	end
	if(TalentFrame.unspentText ~= nil) then
		local numUnspentTalents = GetNumUnspentTalents();
		if ( not disable and numUnspentTalents > 0 ) then
			TalentFrame.unspentText:SetFormattedText(PLAYER_UNSPENT_TALENT_POINTS, numUnspentTalents);
		else
			TalentFrame.unspentText:SetText("");
		end
	end
end

function TalentFrame_UpdateRowGlow(talentRow, restartGlow)
	if ( talentRow.GlowFrame ) then
		local somethingGlowing = false;
		for i, button in ipairs(talentRow.talents) do
			if ( button.shouldGlow and not button.grantedByAura ) then
				somethingGlowing = true;
				if ( restartGlow ) then
					button.GlowFrame:Hide();
				end
				button.GlowFrame:Show();
			else
				button.GlowFrame:Hide();
			end
		end
		if ( somethingGlowing ) then
			if ( restartGlow ) then
				talentRow.GlowFrame:Hide();
			end
			talentRow.GlowFrame:Show();
		else
			talentRow.GlowFrame:Hide();
		end
	end
end

function TalentFrame_UpdateSpecInfoCache(cache, inspect, pet, talentGroup)
	-- initialize some cache info
	cache.primaryTabIndex = 0;

	local numTabs = GetNumSpecializations(inspect);
	cache.numTabs = numTabs;
	local sex = pet and UnitSex("pet") or UnitSex("player");
	for i = 1, MAX_TALENT_TABS do
		cache[i] = cache[i] or { };
		if ( i <= numTabs ) then
			local id, name, description, icon = GetSpecializationInfo(i, inspect, nil, nil, sex);

			-- cache the info we care about
			cache[i].name = name;
			cache[i].icon = icon;
		else
			cache[i].name = nil;
		end
	end
end
