--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(originalStats, increaseStats, callback)

    self.originalStats = originalStats
    self.increaseStats = increaseStats
    self.callback = callback or function() end

    self.levelUpMenu = Menu {
        cursor = false,
        x = 0,
        y = VIRTUAL_HEIGHT - 128,
        width = VIRTUAL_WIDTH,
        height = 128,
        items = {
            {
                text = 'HP: ' .. self.originalStats.HP .. ' + ' .. self.increaseStats.HP .. ' = ' .. (self.originalStats.HP + self.increaseStats.HP)
            },
            {
                text = 'Attack: ' .. self.originalStats.attack .. ' + ' .. self.increaseStats.attack .. ' = ' .. (self.originalStats.attack + self.increaseStats.attack)
            },
            {
                text = 'Defense: ' .. self.originalStats.defense .. ' + ' .. self.increaseStats.defense .. ' = ' .. (self.originalStats.defense + self.increaseStats.defense)
            },
            {
                text = 'Speed: ' .. self.originalStats.speed .. ' + ' .. self.increaseStats.speed .. ' = ' .. (self.originalStats.speed + self.increaseStats.speed)
            }
        }
    }
end

function LevelUpState:update(dt)
    self.levelUpMenu:update(dt)

    if self.levelUpMenu.selection.closed then
        gStateStack:pop()
        self.callback()
    end
end

function LevelUpState:render()
    self.levelUpMenu:render()
end
