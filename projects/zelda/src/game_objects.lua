--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },

    ['pot'] = {
        type = 'pot',
        texture = 'pot',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'origin',
        states = {
            ['origin'] = {
                frame = 14
            },
        }
    },

    ['heartObj'] = {
        type = 'heartObj',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        istaken = false,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 5
            }
        }
    }
}