function init()
  --guildButton = modules.client_topmenu.addLeftGameToggleButton('guildButton', tr('Guild'), '/modules/game_guild/img/guild', toggle, true)
  --guildButton:setOn(true)
  
   guildButton = modules.client_topmenu.addRightButton('guildButton', tr('guild'), '/modules/game_guild/img/guild', toggle, true)
  guildButton:setOn(true)

  guildCreate = g_ui.displayUI('guildcreate')
  guildInvite = g_ui.displayUI('guildinvite')
  guildJoin = g_ui.displayUI('guildjoin')
  guildLeave = g_ui.displayUI('guildleave')
  guildKick = g_ui.displayUI('guildkick')
  guildRevoke = g_ui.displayUI('guildrevoke')
  guildPromote = g_ui.displayUI('guildpromote')
  guildDemote = g_ui.displayUI('guilddemote')
  guildNick = g_ui.displayUI('guildnick')
  guildRankName = g_ui.displayUI('guildrankname')
  guildPassLeader = g_ui.displayUI('guildpassleader')
  guildDisband = g_ui.displayUI('guilddisband')

  g_keyboard.bindKeyDown('Escape', guildCancel)
end

function toggle()
  local menu = g_ui.createWidget('PopupMenu')
  menu:addOption("Create guild", function() guildCreate:setVisible(true) end)
  menu:addOption("Invite player", function() guildInvite:setVisible(true) end)
  menu:addSeparator()
  menu:addOption("Join guild", function() guildJoin:setVisible(true) end)
  menu:addOption("Leave guild", function() guildLeave:setVisible(true) end)
  menu:addSeparator()
  menu:addOption("Kick player", function() guildKick:setVisible(true) end)
  menu:addOption("Revoke player", function() guildRevoke:setVisible(true) end)
  menu:addSeparator()
  menu:addOption("Promote player", function() guildPromote:setVisible(true) end)
  menu:addOption("Demote player", function() guildDemote:setVisible(true) end)
  menu:addSeparator()
  menu:addOption("Pass leadership", function() guildPassLeader:setVisible(true) end)
  menu:addOption("Disband guild", function() guildDisband:setVisible(true) end)
  menu:display()
end

function createGuild()
  local text = guildCreate:getChildById('createGuildText'):getText()
  g_game.talk('!createguild ' .. text)
  guildCreate:setVisible(false)
end

function inviteGuild()
  local text = guildInvite:getChildById('inviteGuildText'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!invite ' .. text)
  guildInvite:setVisible(false)
end

function joinGuild()
  local text = guildJoin:getChildById('joinGuildText'):getText()
  g_game.talk('!joinguild ' .. text)
  guildJoin:setVisible(false)
end

function leaveGuild()
  g_game.talkChannel(MessageModes.Channel, 0, '!leaveguild')
  guildLeave:setVisible(false)
end

function kickGuild()
  local text = guildKick:getChildById('kickGuildText'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!kick ' .. text)
  guildKick:setVisible(false)
end

function revokeGuild()
  local text = guildRevoke:getChildById('revokeGuildText'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!revokeplayer ' .. text)
  guildRevoke:setVisible(false)
end

function promoteGuild()
  local text = guildPromote:getChildById('promoteGuildText'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!promoteplayer ' .. text)
  guildPromote:setVisible(false)
end

function demoteGuild()
  local text = guildDemote:getChildById('demoteGuildText'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!demoteplayer ' .. text)
  guildDemote:setVisible(false)
end

function nickGuild()
  local text1 = guildNick:getChildById('nickGuildText1'):getText()
  local text2 = guildNick:getChildById('nickGuildText2'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!nickname ' .. text1 .. ', ' .. text2)
  guildNick:setVisible(false)
end

function rankNameGuild()
  local text1 = guildRankName:getChildById('rankNameGuildText1'):getText()
  local text2 = guildRankName:getChildById('rankNameGuildText2'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!setrankname ' .. text1 .. ', ' .. text2)
  guildRankName:setVisible(false)
end

function passLeaderGuild()
  local text = guildPassLeader:getChildById('passLeaderGuildText'):getText()
  g_game.talkChannel(MessageModes.Channel, 0, '!passleadership ' .. text)
  guildPassLeader:setVisible(false)
end

function disbandGuild()
  g_game.talkChannel(MessageModes.Channel, 0, '!disbandguild')
  guildDisband:setVisible(false)
end

function guildCancel()
  guildCreate:setVisible(false)
  guildInvite:setVisible(false)
  guildJoin:setVisible(false)
  guildLeave:setVisible(false)
  guildKick:setVisible(false)
  guildRevoke:setVisible(false)
  guildPromote:setVisible(false)
  guildDemote:setVisible(false)
  guildNick:setVisible(false)
  guildRankName:setVisible(false)
  guildPassLeader:setVisible(false)
  guildDisband:setVisible(false)
end
