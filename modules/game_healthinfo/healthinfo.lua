Icons = {}
Icons[PlayerStates.Poison] = { tooltip = tr('You are poisoned'), path = '/images/game/states/poisoned', id = 'condition_poisoned' }
Icons[PlayerStates.Burn] = { tooltip = tr('You are burning'), path = '/images/game/states/burning', id = 'condition_burning' }
Icons[PlayerStates.Energy] = { tooltip = tr('You are electrified'), path = '/images/game/states/electrified', id = 'condition_electrified' }
Icons[PlayerStates.Drunk] = { tooltip = tr('You are drunk'), path = '/images/game/states/drunk', id = 'condition_drunk' }
Icons[PlayerStates.ManaShield] = { tooltip = tr('You are protected by a magic shield'), path = '/images/game/states/magic_shield', id = 'condition_magic_shield' }
Icons[PlayerStates.Paralyze] = { tooltip = tr('You are paralysed'), path = '/images/game/states/slowed', id = 'condition_slowed' }
Icons[PlayerStates.Haste] = { tooltip = tr('You are hasted'), path = '/images/game/states/haste', id = 'condition_haste' }
Icons[PlayerStates.Swords] = { tooltip = tr('You may not logout during a fight'), path = '/images/game/states/logout_block', id = 'condition_logout_block' }
Icons[PlayerStates.Drowning] = { tooltip = tr('You are drowning'), path = '/images/game/states/drowning', id = 'condition_drowning' }
Icons[PlayerStates.Freezing] = { tooltip = tr('You are freezing'), path = '/images/game/states/freezing', id = 'condition_freezing' }
Icons[PlayerStates.Dazzled] = { tooltip = tr('You are dazzled'), path = '/images/game/states/dazzled', id = 'condition_dazzled' }
Icons[PlayerStates.Cursed] = { tooltip = tr('You are cursed'), path = '/images/game/states/cursed', id = 'condition_cursed' }
Icons[PlayerStates.PartyBuff] = { tooltip = tr('You are strengthened'), path = '/images/game/states/strengthened', id = 'condition_strengthened' }
Icons[PlayerStates.PzBlock] = { tooltip = tr('You may not logout or enter a protection zone'), path = '/images/game/states/protection_zone_block', id = 'condition_protection_zone_block' }
Icons[PlayerStates.Pz] = { tooltip = tr('You are within a protection zone'), path = '/images/game/states/protection_zone', id = 'condition_protection_zone' }
Icons[PlayerStates.Bleeding] = { tooltip = tr('You are bleeding'), path = '/images/game/states/bleeding', id = 'condition_bleeding' }
Icons[PlayerStates.Hungry] = { tooltip = tr('You are hungry'), path = '/images/game/states/hungry', id = 'condition_hungry' }

healthInfoWindow = nil
healthBar = nil
manaBar = nil
healthLabel = nil
manaLabel = nil
-- experienceBar = nil
-- soulLabel = nil
-- capLabel = nil
healthTooltip = 'Your character health is %d out of %d.'
manaTooltip = 'Your character mana is %d out of %d.'
-- experienceTooltip = 'You have %d%% to advance to level %d.'

-- overlay = nil
-- healthCircleFront = nil
-- manaCircleFront = nil
-- healthCircle = nil
-- manaCircle = nil
-- topHealthBar = nil
-- topManaBar = nil

function init()
  connect(LocalPlayer, { onHealthChange = onHealthChange,
                         onManaChange = onManaChange,
                         -- onLevelChange = onLevelChange,
                         onStatesChange = onStatesChange
                         -- onSoulChange = onSoulChange,
                         -- onFreeCapacityChange = onFreeCapacityChange
                         })

  connect(g_game, { onGameEnd = offline })

  healthInfoWindow = g_ui.loadUI('healthinfo', modules.game_interface.getRightPanel())
  healthInfoWindow:disableResize()
 
  if not healthInfoWindow.forceOpen then
    healthInfoButton = modules.client_topmenu.addRightGameToggleButton('healthInfoButton', tr('Health Information'), '/images/topbuttons/healthinfo', toggle)
    if g_app.isMobile() then
      healthInfoButton:hide()
    else
      healthInfoButton:setOn(true)
    end
  end

  healthBar = healthInfoWindow:recursiveGetChildById('healthBar')
  manaBar = healthInfoWindow:recursiveGetChildById('manaBar')
  healthLabel = healthInfoWindow:recursiveGetChildById('healthLabel')
  manaLabel = healthInfoWindow:recursiveGetChildById('manaLabel')
  healthInfoWindow:getChildById('contentsPanel'):setMarginTop(5)
  -- experienceBar = healthInfoWindow:recursiveGetChildById('experienceBar')
  -- soulLabel = healthInfoWindow:recursiveGetChildById('soulLabel')
  -- capLabel = healthInfoWindow:recursiveGetChildById('capLabel')

  -- overlay = g_ui.createWidget('HealthOverlay', modules.game_interface.getMapPanel()) 
  -- healthCircleFront = overlay:getChildById('healthCircleFront')
  -- manaCircleFront = overlay:getChildById('manaCircleFront')
  -- healthCircle = overlay:getChildById('healthCircle')
  -- manaCircle = overlay:getChildById('manaCircle')
  -- topHealthBar = overlay:getChildById('topHealthBar') 
  -- topManaBar = overlay:getChildById('topManaBar')
 
  -- connect(overlay, { onGeometryChange = onOverlayGeometryChange })
 
  -- load condition icons
  for k,v in pairs(Icons) do
    g_textures.preload(v.path)
  end

  if g_game.isOnline() then
    local localPlayer = g_game.getLocalPlayer()
    onHealthChange(localPlayer, localPlayer:getHealth(), localPlayer:getMaxHealth())
    onManaChange(localPlayer, localPlayer:getMana(), localPlayer:getMaxMana())
    -- onLevelChange(localPlayer, localPlayer:getLevel(), localPlayer:getLevelPercent())
    onStatesChange(localPlayer, localPlayer:getStates(), 0)
    -- onSoulChange(localPlayer, localPlayer:getSoul())
    -- onFreeCapacityChange(localPlayer, localPlayer:getFreeCapacity())
  end


  -- hideLabels()
  -- hideExperience()

  healthInfoWindow:setup()
 
  if g_app.isMobile() then
    healthInfoWindow:close()
    healthInfoButton:setOn(false) 
  end
end

function terminate()
  disconnect(LocalPlayer, { onHealthChange = onHealthChange,
                            onManaChange = onManaChange,
                            -- onLevelChange = onLevelChange,
                            onStatesChange = onStatesChange
                            -- onSoulChange = onSoulChange,
                            -- onFreeCapacityChange = onFreeCapacityChange
                            })

  disconnect(g_game, { onGameEnd = offline })
  disconnect(overlay, { onGeometryChange = onOverlayGeometryChange })
 
  healthInfoWindow:destroy()
  if healthInfoButton then
    healthInfoButton:destroy()
  end
  -- overlay:destroy()
end

function toggle()
  if not healthInfoButton then return end
  if healthInfoButton:isOn() then
    healthInfoWindow:close()
    healthInfoButton:setOn(false)
  else
    healthInfoWindow:open()
    healthInfoButton:setOn(true)
  end
end

function toggleIcon(bitChanged)
  local content = healthInfoWindow:recursiveGetChildById('conditionPanel')

  local icon = content:getChildById(Icons[bitChanged].id)
  if icon then
    icon:destroy()
  else
    icon = loadIcon(bitChanged)
    icon:setParent(content)
  end
end

function loadIcon(bitChanged)
  local icon = g_ui.createWidget('ConditionWidget', content)
  icon:setId(Icons[bitChanged].id)
  icon:setImageSource(Icons[bitChanged].path)
  icon:setTooltip(Icons[bitChanged].tooltip)
  return icon
end

function offline()
  healthInfoWindow:recursiveGetChildById('conditionPanel'):destroyChildren()
end

-- hooked events
function onMiniWindowClose()
  if healthInfoButton then
    healthInfoButton:setOn(false)
  end
end

function round(val, decimal)
  if (decimal) then
      return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
      return math.floor(val+0.5)
  end
end

function onHealthChange(localPlayer, health, maxHealth)
  healthLabel:setText(""..health.. "")
  healthBar:setTooltip(tr(healthTooltip, health, maxHealth))
  healthBar:setValue(health, 0, maxHealth)
 
  local healthPercent = ((health*100)/maxHealth)
  local globalWidth = healthBar:getImageTextureWidth() -- 100%
  local sizePercent = ((healthPercent*globalWidth)/100) -- x%
  local percent = round(sizePercent, decimal)
  healthBar:setWidth(percent)
  healthBar:setImageClip(torect('0 0 ' .. tonumber(percent) .. ' 0'))
end

function onManaChange(localPlayer, mana, maxMana)
  manaLabel:setText(""..mana.. "")
  manaBar:setTooltip(tr(manaTooltip, mana, maxMana))
  manaBar:setValue(mana, 0, maxMana)
 
  local manaPercent = ((mana*100)/maxMana)
  local globalWidth = manaBar:getImageTextureWidth() -- 100%

  local sizePercent = ((manaPercent*globalWidth)/100) -- x%
  local percent = round(sizePercent, decimal)
 
  if maxMana == 0 then
  manaBar:setWidth(90)
 
  else
 
  manaBar:setWidth(percent)
  manaBar:setImageClip(torect('0 0 ' .. tonumber(percent) .. ' 0'))
  end
end

function onLevelChange(localPlayer, value, percent)
  experienceBar:setText(percent .. '%')
  experienceBar:setTooltip(tr(experienceTooltip, percent, value+1))
  experienceBar:setPercent(percent)
end

function onSoulChange(localPlayer, soul)
  soulLabel:setText(tr('Soul') .. ': ' .. soul)
end

function onFreeCapacityChange(player, freeCapacity)
  capLabel:setText(tr('Cap') .. ': ' .. freeCapacity)
end

function onStatesChange(localPlayer, now, old)
  if now == old then return end

  local bitsChanged = bit32.bxor(now, old)
  for i = 1, 32 do
    local pow = math.pow(2, i-1)
    if pow > bitsChanged then break end
    local bitChanged = bit32.band(bitsChanged, pow)
    if bitChanged ~= 0 then
      toggleIcon(bitChanged)
    end
  end
end

-- personalization functions
function hideLabels()
  local content = healthInfoWindow:recursiveGetChildById('conditionPanel')
  local removeHeight = math.max(capLabel:getMarginRect().height, soulLabel:getMarginRect().height) + content:getMarginRect().height - 3
  capLabel:setOn(false)
  soulLabel:setOn(false)
  content:setVisible(false)
  healthInfoWindow:setHeight(math.max(healthInfoWindow.minimizedHeight, healthInfoWindow:getHeight() - removeHeight))
end

function hideExperience()
  local removeHeight = experienceBar:getMarginRect().height
  experienceBar:setOn(false)
  healthInfoWindow:setHeight(math.max(healthInfoWindow.minimizedHeight, healthInfoWindow:getHeight() - removeHeight))
end

function setHealthTooltip(tooltip)
  healthTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    healthBar:setTooltip(tr(healthTooltip, localPlayer:getHealth(), localPlayer:getMaxHealth()))
  end
end

function setManaTooltip(tooltip)
  manaTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    manaBar:setTooltip(tr(manaTooltip, localPlayer:getMana(), localPlayer:getMaxMana()))
  end
end

function setExperienceTooltip(tooltip)
  experienceTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    experienceBar:setTooltip(tr(experienceTooltip, localPlayer:getLevelPercent(), localPlayer:getLevel()+1))
  end
end

function onOverlayGeometryChange() 
  if g_app.isMobile() then
    topHealthBar:setMarginTop(35)
    topManaBar:setMarginTop(35)
    local width = overlay:getWidth() 
    local margin = width / 3 + 10
    topHealthBar:setMarginLeft(margin)
    topManaBar:setMarginRight(margin)    
    return
  end

  local classic = g_settings.getBoolean("classicView")
  local minMargin = 40
  if classic then
    topHealthBar:setMarginTop(15)
    topManaBar:setMarginTop(15)
  else
    topHealthBar:setMarginTop(45 - overlay:getParent():getMarginTop())
    topManaBar:setMarginTop(45 - overlay:getParent():getMarginTop())  
    minMargin = 200
  end

  local height = overlay:getHeight()
  local width = overlay:getWidth()
     
  topHealthBar:setMarginLeft(math.max(minMargin, (width - height + 50) / 2 + 2))
  topManaBar:setMarginRight(math.max(minMargin, (width - height + 50) / 2 + 2))
end