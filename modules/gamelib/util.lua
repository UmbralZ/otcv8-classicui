function postostring(pos)
  return pos.x .. " " .. pos.y .. " " .. pos.z
end

function dirtostring(dir)
  for k,v in pairs(Directions) do
    if v == dir then
      return k
    end
  end
end

function createTexturedBar(id, min, max, texWidth, texHeight, panel, step, pos)
  local clipY
  local posY
  local height

  if step == nil and pos == nil then
    clipY = 0
    posY = 0
    height = texHeight
  else
    clipY = texHeight / step
    posY = clipY * pos
    height = clipY
  end

  local val = panel
  local bar = val:getChildById(id)
  local globalWidth = texWidth
  local percent = ((min * 100) / max)
  local sizePercent = ((percent * globalWidth) / 100)
  local width = round(sizePercent, decimal)

  bar:setId(id)
  bar:setHeight(height)

  if max <= 0 then
    bar:setWidth(texWidth)
    bar:setImageClip('0 ' .. posY .. ' ' .. texWidth .. ' ' .. height)
  else
    bar:setWidth(width)
    bar:setImageClip('0 ' .. posY .. ' ' .. width .. ' ' .. height)
  end

  return bar
end