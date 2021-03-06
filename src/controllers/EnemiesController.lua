local Enemy = require "models.entities.Enemy"

local EnemiesController = {}; EnemiesController.__index = EnemiesController

function EnemiesController:new(world)
    local this = setmetatable({
        enemies = {},
        ai = {types = {
            Bill = require "models.business.enemies_ai.BillAi",
            Seu_Barriga = require "models.business.enemies_ai.SeuBarrigaAi",
            Two_Guys_In_a_Bike = require "models.business.enemies_ai.TwoGuysInMotorcycleAi"
        }},
        world = world.world,
        enemiesUserData = {
            Bill = {idle = "_Idle", running = "_Running", up = "_Idle", down = "_Idle", dying = "_Dying"},
            Seu_Barriga = {idle = "", running = "", up = "", down = "", dying = ""},
            Two_Guys_In_a_Bike = {idle = "", running = "", up = "", down = "", dying = ""}
        },
        enemiesFactory = {
            Seu_Barriga = {colisor = {24}, sprite = nil, category = {body = 4, bullet = 4}, damage = 1, bullet = {normal = "shot", hit = "bullet_hit"}, scale = {1, 1}},
            Bill = {colisor = {16}, sprite = nil, category = {body = 3, bullet = 4}, damage = 1, bullet = {normal = "bill_bullet", hit = "bullet_hit"}, scale = {1, 1}},
            Two_Guys_In_a_Bike = {colisor = {48}, sprite = nil, category = {body = 4, bullet = 4}, damage = 2, bullet = {normal = "shot", hit = "bullet_hit"}, scale = {1.5, 1.5}}
        }
    }, EnemiesController)

    return this
end

function EnemiesController:factory(enemyName, animation)
    local enemyAnimation = {
        idle = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(enemyName .. animation.idle, "assets/sprites/" .. enemyName .. "/", true, 0.7, nil, nil, true),
        running = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(enemyName .. animation.running, "assets/sprites/" .. enemyName .. "/", true, 0.2, nil, nil, true),
        up = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(enemyName .. animation.up, "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        down = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(enemyName .. animation.down, "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        dying = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(enemyName .. animation.dying, "assets/sprites/" .. enemyName .. "/", false, 0.06, nil, nil, true)
    }
    return enemyAnimation
end

function EnemiesController:startFactory()
    for key, animation in pairs(self.enemiesUserData) do
        self.enemiesFactory[key].sprite = self:factory(key, animation)
    end
end

function EnemiesController:clearEnemies()
    repeat
        for _, enemy in pairs(self.enemies) do
            enemy:destroy()
        end
    until #self.enemies <= 0
    self.enemies = {}
end

function EnemiesController:getDamage(enemyType)
    return self.enemiesFactory[enemyType].damage
end

function EnemiesController:createEnemy(enemyType, x, y)
    assert(enemyType, "Needs to receive enemyType Parameter")
    local enemyConfig = self.enemiesFactory[enemyType]
    local enemy = Enemy:new(enemyConfig.sprite, self.world, x or 600, y or 500, enemyType, enemyConfig.colisor, enemyConfig.category.body, enemyConfig.category.bullet, enemyConfig.scale, enemyConfig.bullet)
    table.insert(self.enemies, enemy)
    self.ai[enemy] = self.ai.types[enemyType]:new(enemy)
end

function EnemiesController:getEnemyByFixture(fixture)
    if self.enemiesUserData[fixture:getUserData().type] then
        for _, enemy in pairs(self.enemies) do
            if enemy:compareFixture(fixture) then
                return enemy
            end
        end
    end
    return nil
end

function EnemiesController:remove(enemy)
    for index = 1, #self.enemies do
        if self.enemies[index] == enemy then
            table.remove(self.enemies, index)
            self.ai[enemy] = nil
            return true
        end
    end
end

function EnemiesController:update(dt)
    for index, enemy in pairs(self.enemies) do
        self.ai[enemy]:update(dt)
        enemy:update(dt)
    end
end

function EnemiesController:draw()
    for index, enemy in pairs(self.enemies) do
        enemy:draw()
    end
end

return EnemiesController
