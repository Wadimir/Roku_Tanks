function initScreen(flag as integer)
    m.RND_VALUE_3 = 3
    m.RND_VALUE_5 = 5

    m.COLLISION_TIMER_DURATION = 0.02

    m.START_LABEL_TRANSLATION = [600, 300]

    m.GAME_OVER_LABEL_TRANSLATION = [570, 300]

    m.START_DESCRIPTION_TRANSLATION = [500, 330]

    m.TANK_LABEL_TRANSLATION = [20, 0]

    m.ENEMY_TANK_LABEL_TRANSLATION = [1150, 0]

    m.LIMIT_LINE_WIDTH = 1280
    m.LIMIT_LINE_HEIGHT = 3
    m.LIMIT_LINE_TRANSLATION = [0, 30]
    m.LIMIT_LINE_COLOR = "0x0000DC"

    m.TANK_TEXT = "0"

    m.START_LABEL_TEXT = "TANKS"

    m.GAME_OVER_LABEL_TEXT = "GAME OVER"
    m.GAME_OVER_LABEL_WON = "YOU WON"
    m.GAME_OVER_LABEL_LOSE = "YOU LOSE"

    m.START_DESCRIPTION_TEXT = "please press OK for start"

    m.gameOverLabel = m.top.findNode("gameOverLabel")
    m.gameOverLabel.visible = false

    m.tankLabel = m.top.findNode("tankLabel")
    m.tankLabel.text = m.TANK_TEXT
    m.tankLabel.visible = false
    m.tankLabel.translation = m.TANK_LABEL_TRANSLATION

    m.enemyTankLabel = m.top.findNode("enemyTankLabel")
    m.enemyTankLabel.text = m.TANK_TEXT
    m.enemyTankLabel.visible = false
    m.enemyTankLabel.translation = m.ENEMY_TANK_LABEL_TRANSLATION

    m.limitLine = m.top.findNode("limitLine")
    m.limitLine.width = m.LIMIT_LINE_WIDTH
    m.limitLine.height = m.LIMIT_LINE_HEIGHT
    m.limitLine.translation = m.LIMIT_LINE_TRANSLATION
    m.limitLine.color = m.LIMIT_LINE_COLOR
    m.limitLine.visible = false

    m.startDescription = m.top.findNode("startDescription")
    m.startDescription.visible = true
    m.startDescription.text = m.START_DESCRIPTION_TEXT
    m.startDescription.translation = m.START_DESCRIPTION_TRANSLATION

    m.top.setFocus(true)
    m.isStartGame = false
end function

function startGame()
    removeStartScreen()
    m.tank = createObject("roSGNode", "Tank")
    m.enemyTank = createObject("roSGNode", "EnemyTank")
    m.top.appendChild(m.tank)
    m.top.appendChild(m.enemyTank)
    m.tank.callFunc("initScreen", m.top)
    m.enemyTank.callFunc("initScreen", m.top)
    startEnemyRandom()
    startEnemyRandom()
    initCollosionTimer()
    m.score = 0
    m.enemyScore = 0

    showStartScreenElements()
end function

function startEnemyRandom()
   initTimer(Rnd(m.RND_VALUE_5))
end function

function initTimer(duration as float)
    m.gameTimer = m.top.findNode("gameTimer")
    m.gameTimer.repeat = false
    m.gameTimer.duration = duration
    m.gameTimer.control = "start"
    m.gameTimer.observeFieldScoped("fire", "onChangeEnemyDirection")
end function

function initCollosionTimer()
    m.collisionTimer = m.top.findNode("collisionTimer")
    m.collisionTimer.repeat = true
    m.collisionTimer.duration = m.COLLISION_TIMER_DURATION
    m.collisionTimer.control = "start"
    m.collisionTimer.observeFieldScoped("fire", "onCheckCollision")
end function

function onChangeEnemyDirection()
    drct = ["left", "right", "up", "down"]
    m.gameTimer.unobserveFieldScoped("fire")
    m.gameTimer.control = "stop"
    m.enemyTank.callFunc("setKey", drct[Rnd(m.RND_VALUE_3)])
    startEnemyRandom()
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if(key = "OK")
            if (m.isStartGame = false)
                m.isStartGame = true
                startGame()
            else
                m.tank.callFunc("letsFire", 0)
            end if

        else
            m.tank.callFunc("setKey", key)
        end if
    else
        m.tank.callFunc("setKey", "")
      end if
    return false
end function

function onCheckCollision() as void
    tankData = m.tank.callFunc("getTankData", 0)
    tankBulletData = m.tank.callFunc("getBulletData", 0)

    enemyTankData = m.enemyTank.callFunc("getTankData", 0)
    enemyBulletData = m.enemyTank.callFunc("getBulletData", 0)

    if (intersaction(enemyTankData, tankData) = true)
        gameOver()
        return
    end if

    if(enemyBulletData <> invalid and intersaction(tankData, enemyBulletData) = true)
        m.enemyTank.callFunc("removeBullet", 0)
        m.enemyScore += 1
    end if

   if (tankBulletData <> invalid and intersaction(enemyTankData, tankBulletData) = true)
        m.tank.callFunc("removeBullet", 0)
        m.score += 1
    end if

    m.tankLabel.text = " Green: " + m.score.toStr()
    m.enemyTankLabel.text = " Red: " + m.enemyScore.toStr()

    checkWin()
end function

function intersaction(a as object, b as object) as Boolean
    ax1 = a.x + 0
    ay1 = a.y + 0

    ax2 = a.x + a.width
    ay2 = a.y + a.height

    bx1 = b.x + 0
    by1 = b.y + 0

    bx2 = b.x + b.width
    by2 = b.y + b.height

    if (ax1 > bx2)
        return false
    end if
    if (ax2 < bx1)
        return false
    end if
    if (ay1 > by2)
        return false
    end if
    if (ay2 < by1)
        return false
    end if

    return true
end function

function removeStartScreen()
    m.startLabel = m.top.findNode("startLabel")
    m.startLabel.translation = m.START_LABEL_TRANSLATION
    m.startLabel.text = m.START_LABEL_TEXT

    m.startDescription.visible = false

    m.gameOverLabel.text = m.GAME_OVER_LABEL_TEXT
    m.gameOverLabel.translation = m.GAME_OVER_LABEL_TRANSLATION

    m.startLabel.visible = false
    m.gameOverLabel.visible = false
end function

function showStartScreenElements()
    m.tankLabel.visible = true
    m.enemyTankLabel.visible = true
    m.limitLine.visible = true
end function

function gameOver()
    m.enemyTank.callFunc("removeBullet", 0)
    m.tank.callFunc("removeBullet", 0)

    m.tank.callFunc("removeTank", 0)
    m.enemyTank.callFunc("removeTank", 0)

    m.top.removeChild(m.tank)
    m.top.removeChild(m.enemyTank)

    m.startDescription.visible = true
    m.gameOverLabel.visible = true
    m.gameOverLabel.text = m.GAME_OVER_LABEL_TEXT

    m.isStartGame = false
end function

function checkWin()
    POINTS = 3

    if(m.score = POINTS)
        winGame(true)
    end if

    if(m.enemyScore = POINTS)
        winGame(false)
    end if
end function

function winGame(param as Boolean)
    gameOver()

    if(param)
        m.gameOverLabel.text = m.GAME_OVER_LABEL_WON
    else
        m.gameOverLabel.text = m.GAME_OVER_LABEL_LOSE
    end if
end function