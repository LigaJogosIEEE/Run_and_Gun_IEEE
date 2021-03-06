local Button = require "util.ui.Button"

local ButtonManager = {}

ButtonManager.__index = ButtonManager

function ButtonManager:new(next, previous)
    local this = {
        buttons = {}, options = {}, controls = {next = next or "down", previous = previous or "up"},
        currentOption = 1, previousState = "normal", currentState = "hover",
        cursor = {hover = love.mouse.getSystemCursor("hand"), normal = love.mouse.getCursor()}
    }

    return setmetatable(this, ButtonManager)
end

function ButtonManager:addNewButton(buttonName, x, y, width, height, image, originalImage, animation)
    local newButton = Button:new(buttonName, x, y, width, height, image, originalImage, animation, self.cursor)
    table.insert(self.buttons, newButton)
    table.insert(self.options, buttonName)
    return newButton
end

function ButtonManager:addButton(button)
    button:setCursor(self.cursor)
    table.insert(self.buttons, button); table.insert(self.options, button:getName())
end

function ButtonManager:keypressed(key, scancode, isrepeat)
    local valid = false
    if key == self.controls.next and self.currentOption < #self.options then
        if self.buttons[self.currentOption + 1]:getState() ~= "disabled" then
            self.buttons[self.currentOption]:setState(self.previousState)
            self.currentOption = self.currentOption + 1
            valid = true
        end
    elseif key == self.controls.previous and self.currentOption > 1 then
        if self.buttons[self.currentOption - 1]:getState() ~= "disabled" then
            self.buttons[self.currentOption]:setState(self.previousState)
            self.currentOption = self.currentOption - 1
            valid = true
        end
    end
    if valid then
        self.previousState = self.buttons[self.currentOption]:getState() == "disabled" and "disabled" or "normal"
    elseif (key == "space" or key == "return" or key == "kpenter") and self.buttons[self.currentOption]:getState() ~= "disabled" then
        self.buttons[self.currentOption]:executeCallback()
    end
end

function ButtonManager:keyreleased(key, scancode)
end

function ButtonManager:mousemoved(x, y, dx, dy, istouch)
    for index, button in pairs(self.buttons) do
        local buttonName = button:mousemoved(x, y, dx, dy, istouch)
        if buttonName then
            self.currentOption = index; self.currentState = "hover"
            --love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
        end
    end
end

function ButtonManager:mousepressed(x, y, button)
    for index, guiButton in pairs(self.buttons) do
        local buttonName = guiButton:mousepressed(x, y, button)
        if buttonName then
            self.currentState = "pressed"
        end
    end
end

function ButtonManager:mousereleased(x, y, button)
    for index, guiButton in pairs(self.buttons) do
        guiButton:mousereleased(x, y, button)
    end
    self.currentState = "hover"
end

function ButtonManager:update(dt)
    if self.buttons[self.currentOption]:getState() ~= "disabled" then
        self.buttons[self.currentOption]:setState(self.currentState)
    end
    for index, button in pairs(self.buttons) do
        button:update(dt)
    end
end

function ButtonManager:draw()
    for index, button in pairs(self.buttons) do
        button:draw()
    end
end

return ButtonManager
