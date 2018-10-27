local ConfigurationScene = {}

ConfigurationScene.__index = ConfigurationScene

function ConfigurationScene:addButton(this, buttonName,sceneName ,buttonDimensions, originalSize, callback)
    local scaleButtonName = "configuration" .. buttonName
    scaleDimension:calculeScales(scaleButtonName, unpack(buttonDimensions))
    scaleDimension:centralize(scaleButtonName, true, false, false)
    scaleDimension:relativeScale(scaleButtonName, originalSize)
    local scales = scaleDimension:getScale(scaleButtonName)

    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = this.buttonManager:addButton(buttonName, scales.x, scales.y, scales.width, scales.height, this.buttonsQuads, this.buttonsImage)
     button.callback = callback or function(this) sceneDirector:switchScene(sceneName) end
   button:setScale(scales.relative.x, scales.relative.y)
    button:setScale(scales.relative.x, scales.relative.y)
    this.buttonNames[scaleButtonName] = button
   -- if(buttonName == "Move Left" ) then


    --sceneDirector:switchSubscene("ConfKey")


    --end
    
    return button
end

function ConfigurationScene:new()
    local this = {
        selected = nil,
        buttonManager = gameDirector:getLibrary("ButtonManager"):new(),
        buttonsImage = nil,
        buttonsQuads = nil,
        buttonNames = {}
    }

    local spriteSheet = gameDirector:getLibrary("SpriteSheet"):new("buttons.json", "assets/gui/", nil)
    local spriteQuads = spriteSheet:getQuads()
    this.buttonsQuads = {
        normal = spriteQuads["normal"],
        hover = spriteQuads["hover"],
        pressed = spriteQuads["pressed"],
        disabled = spriteQuads["disabled"]
    }
    this.buttonsImage = spriteSheet:getAtlas()

    local x, y, width, height = this.buttonsQuads["normal"]:getViewport()
    local originalSize = {width = width, height = height}
   

   -- self:addButton(this, 'Toggle Fullscreen',"ConfKey", {128, 60, 350, 220}, originalSize):setCallback(function()
     --   love.window.setFullscreen(not love.window.getFullscreen())
    --end)
    self:addButton(this, 'Move Left',"ConfKeySceneLeft",{128, 60, 350, 290}, originalSize)
    self:addButton(this, 'Move Right',"ConfKeySceneRight", {128, 60, 350, 360}, originalSize)
    self:addButton(this, 'Move Up', "ConfKeySceneUp",{128, 60, 350, 430}, originalSize)
    self:addButton(this, 'Move Down', "ConfKeySceneDown",{128, 60, 350, 500}, originalSize)
   -- self:addButton(this, 'Jump', "ConfKeySceneJump",{128, 60, 350, 500}, originalSize)
     --   self:addButton(this, 'Atack', "ConfKeySceneAtack",{128, 60, 350, 500}, originalSize)


    return setmetatable(this, ConfigurationScene)
end

function ConfigurationScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    end
    self.buttonManager:keypressed(key, scancode, isrepeat)
end



function ConfigurationScene:keyreleased(key, scancode)
    self.buttonManager:keyreleased(key, scancode)
end

function ConfigurationScene:mousemoved(x, y, dx, dy, istouch)
    self.buttonManager:mousemoved(x, y, dx, dy, istouch)
end

function ConfigurationScene:mousepressed(x, y, button)
    self.buttonManager:mousepressed(x, y, button)
end

function ConfigurationScene:mousereleased(x, y, button)
    self.buttonManager:mousereleased(x, y, button)
end

function ConfigurationScene:wheelmoved(x, y)
end

function ConfigurationScene:update(dt)
    self.buttonManager:update(dt)
end

function ConfigurationScene:draw()
    self.buttonManager:draw()
end

function ConfigurationScene:resize(w, h)
    for index, value in pairs(self.buttonNames) do
        local scales = scaleDimension:getScale(index)
        value:setXY(scales.x, scales.y)
        value:setDimensions(scales.width, scales.height)
        value:setScale(scales.relative.x, scales.relative.y)
    end
end






return ConfigurationScene