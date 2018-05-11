local L = "LoseControl"
local BS = AceLibrary("Babble-Spell-2.2");
local CC      = "CC"
local Silence = "Silence"
local Root    = "Root"
local Snare   = "Snare"

--[[
	SaySapped: Says "Sapped!" when you get sapped allowing you to notify nearby players about it.
	Also works for many other CCs.
	Author: Coax  - Nostalrius PvP
	Translate and rework by: CFM - LH
	Original idea: Bitbyte of Icecrown
--]]

-- Slash Command
SLASH_LOSECONTROL1 = '/saysapped'
SLASH_LOSECONTROL2 = '/ssap'
function SlashCmdList.LOSECONTROL(msg, editbox)
  	if SaySappedConfig then
		SaySappedConfig = false
		DEFAULT_CHAT_FRAME:AddMessage(SS_DISABLED)
	else
		SaySappedConfig = true
		DEFAULT_CHAT_FRAME:AddMessage(SS_ENABLED)
	end
end

-- Translated by CFM
if GetLocale()=="ruRU" then
	SS_Sapped='Sapped!'
	SS_SpellSap='"Ошеломление".'
	SS_Loaded='|cffffff55LoseControl загружен /ssap. Мод от CFM.'
	SS_SELFHARMFULL='Вы находитесь'
	SS_DISABLED='|cffffff55SaySapped выключен!'
	SS_ENABLED='|cffffff55SaySapped включен!'
else
	SS_Sapped='Sapped!'
	SS_SpellSap=' Sap.'
	SS_Loaded='|cffffff55LoseControl loaded /ssap. Mod by CFM.'
	SS_SELFHARMFULL='You are'
	SS_DISABLED='|cffffff55SaySapped disabled!'
	SS_ENABLED='|cffffff55SaySapped enabled!'
end

local SaySapped = CreateFrame("Frame",nil,UIParent)
SaySapped:RegisterEvent("ADDON_LOADED")

SaySapped:SetScript("OnEvent", function()
	if arg1 == "LoseControl" then
		DEFAULT_CHAT_FRAME:AddMessage(SS_Loaded)
		if not SaySappedConfig then
			SaySappedConfig = true;
		end
		SaySapped.checkbuff = CreateFrame("Frame")
		SaySapped.checkbuff:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
		SaySapped.checkbuff:SetScript("OnEvent", function()
			if string.find(arg1, SS_SELFHARMFULL) then
				SaySapped_FilterDebuffs(arg1)
			end
		end)
	end
end)

-- Check if sapped
function SaySapped_FilterDebuffs(spell)
	if string.find(spell, SS_SpellSap) and SaySappedConfig then
		SendChatMessage(SS_Sapped,"SAY")
		DEFAULT_CHAT_FRAME:AddMessage(SS_Sapped)
	end
end

local spellIds = {
	-- Druid
	[BS["Bash"]] = CC, -- Bash
	[BS["Feral Charge Effect"]] = Root, -- Feral Charge Efect
	[BS["Hibernate"]] = CC, -- Hibernate
	[BS["Pounce"]] = CC, -- Pounce
	[BS["Entangling Roots"]] = Root, -- Entangling Roots
	-- Hunter
	[BS["Freezing Trap"]] = CC, -- Freezing Trap
	[BS["Intimidation"]] = CC, -- Intimidation
	[BS["Scare Beast"]] = CC, -- Scare Beast
	[BS["Scatter Shot"]] = CC, -- Scatter Shot
	[BS["Wyvern Sting"]] = CC, -- Wyvern Sting; requires a hack to be removed later
	-- Mage
	[BS["Frost Nova"]] = Root, -- Frost Nova
	[BS["Polymorph"]] = CC, -- Polymorph
	[BS["Frostbite"]] = Root, -- Frostbite
	[BS["Freeze"]] = Root, -- Freeze
	[BS["Cone of Cold"]] = Snare, -- Cone of Cold
	[BS["Counterspell - Silenced"]] = Silence, -- Counterspell - Silenced
	-- Paladin
	[BS["Hammer of Justice"]] = CC, -- Hammer of Justice
	[BS["Repentance"]] = CC, -- Repentance
	-- Priest
	[BS["Mind Control"]] = CC, -- Mind Control
	[BS["Psychic Scream"]] = CC, -- Psychic Scream
	[BS["Silence"]] = Silence, -- Silence
	[BS["Blackout"]] = CC, -- Затмение
	-- Rogue
	[BS["Blind"]] = CC, -- Blind
	[BS["Cheap Shot"]] = CC, -- Cheap Shot
	[BS["Gouge"]] = CC, -- Gouge
	[BS["Kidney Shot"]] = CC, -- Kidney shot; the buff is 30621
	[BS["Sap"]] = CC, -- Sap
	-- Warlock
	[BS["Death Coil"]] = CC, -- Death Coil
	[BS["Fear"]] = CC, -- Fear
	[BS["Howl of Terror"]] = CC, -- Howl of Terror
	[BS["Seduction"]] = CC, -- Seduction
	-- Warrior
	[BS["Charge Stun"]] = CC, -- Charge Stun
	[BS["Intercept Stun"]] = CC, -- Intercept Stun
	[BS["Intimidating Shout"]] = CC, -- Intimidating Shout
	[BS["Piercing Howl"]] = Snare, -- Piercing Howl
	[BS["Mortal Strike"]] = Snare, -- Mortal Strike CFM
	--CFM
	-- other
	[BS["War Stomp"]] = CC, -- War Stomp
	--[BS["Mace Stun Effect"]] = СС, -- Mace Specialization CFM
	[BS["Ice Blast"]] = CC, -- Ice Yeti
	[BS["Snap Kick"]] = CC, -- Ashenvale Outrunner
	[BS["Lash"]] = CC, -- Lashtail Raptor
	[BS["Crystal Gaze"]] = CC, -- Crystal Spine Basilisk
	[BS["Web"]] = Root,      -- Carrion Lurker
	[BS["Terrify"]] = CC, -- Fr Pterrordax
	[BS["Terrifying Screech"]] = CC, -- Pterrordax
	[BS["Flash Freeze"]] = CC, -- Freezing Ghoul
	[BS["Knockdown"]] = CC, -- Zaeldarr the Outcast etc
	[BS["Net"]] = Root,-- Witherbark Headhunter etc
	[BS["Flash Bomb"]] = CC,-- AV 	Световая бомба
	[BS["Reckless Charge"]] = CC, -- инженерка Безрассудная атака
}

	LCPlayer = CreateFrame("Frame", "LoseControlPlayer", ActionButtonTemplate)
	LCPlayer:SetHeight(50)
	LCPlayer:SetWidth(50)
	LCPlayer:SetPoint("CENTER", 0,0)
	LCPlayer:RegisterEvent("UNIT_AURA")
	LCPlayer:RegisterEvent("PLAYER_AURAS_CHANGED")
	LCPlayer.texture = LCPlayer:CreateTexture(LCPlayer, "BACKGROUND")
	LCPlayer.texture:SetAllPoints(LCPlayer)
	LCPlayer.cooldown = CreateFrame("Model", "Cooldown", LCPlayer, "CooldownFrameTemplate")
	LCPlayer.cooldown:SetAllPoints(LCPlayer) 
	LCPlayer.maxExpirationTime = 0
	LCPlayer:Hide()
	LCPlayer:SetScript("OnEvent", function()
		if event=="UNIT_AURA" and arg1 ~= "player" then return end
		local spellFound = false
		for i=1, 16 do -- 16 is enough due to HARMFUL filter
			local texture = UnitDebuff("player", i)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			GameTooltip:SetUnitDebuff("player", i)
			local buffName = GameTooltipTextLeft1:GetText()
			GameTooltip:Hide()
			if spellIds[buffName] then
				spellFound = true
				for j=0, 31 do
					local buffTexture = GetPlayerBuffTexture(j)
					if texture == buffTexture then
						local expirationTime = GetPlayerBuffTimeLeft(j)
						LCPlayer:Show()
						LCPlayer.texture:SetTexture(buffTexture)
						LCPlayer.cooldown:SetModelScale(1)
						if LCPlayer.maxExpirationTime <= expirationTime then
							CooldownFrame_SetTimer(LCPlayer.cooldown, GetTime(), expirationTime, 1)
							LCPlayer.maxExpirationTime = expirationTime
						end
						return
					end
				end
			end
		end
		if spellFound == false then
			LCPlayer.maxExpirationTime = 0
			LCPlayer:Hide()
		end
	end)
