-- private variables
local background
local clientVersionLabel
local infoWindow

-- public functions
function init()
  background = g_ui.displayUI('background')
  background:lower()

  infoWindow = g_ui.createWidget('InfoWindow', background)
  infoWindow:hide()

  clientVersionLabel = background:getChildById('clientVersionLabel')
  clientVersionLabel:setText('OTClientV8 ' .. g_app.getVersion() .. '\nrev ' .. g_app.getBuildRevision() .. '\nMade by:\n' .. g_app.getAuthor() .. "")
 
  if not g_game.isOnline() then
    addEvent(function() g_effects.fadeIn(clientVersionLabel, 1500) end)
  end

  connect(g_game, { onGameStart = hide })
  connect(g_game, { onGameEnd = show })
end

function terminate()
  disconnect(g_game, { onGameStart = hide })
  disconnect(g_game, { onGameEnd = show })

  g_effects.cancelFade(background:getChildById('clientVersionLabel'))
  background:destroy()

  infoWindow:destroy()
  infoWindow = nil

  Background = nil
end

function hide()
  background:hide()
end

function show()
  background:show()
end

function showInfoWindow()
  if not infoWindow:isVisible() then
   infoWindow:show()
  end
end

function hideVersionLabel()
  background:getChildById('clientVersionLabel'):hide()
end

function setVersionText(text)
  clientVersionLabel:setText(text)
end

function getBackground()
  return background
end
