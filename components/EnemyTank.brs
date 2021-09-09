function initScreen(scene as dynamic)
    m.RANDOM_VALUE = 600
    m.TRANSLATION_OFFSET = 30

    m.SCREEN_WIDTH = 1280
    m.SCREEN_HEIGHT = 720

    m.TANK_SIZE = 100
    m.TANK_TRANSLATION = [1180, 30]
    m.TANK_RIGHT_URI = "pkg:/images/eTank0.png"
    m.TANK_DOWN_URI = "pkg:/images/eTank1.png"
    m.TANK_LEFT_URI = "pkg:/images/eTank2.png"
    m.TANK_UP_URI = "pkg:/images/eTank3.png"

    m.ENEMY_TANK_TIMER_DURATION = 0.050

    m.bullet = invalid
    initTank()
    addProgressBullet()

    initTimer()
    setStartPosition()

    m.scene = scene
    m.isFire = false
end function

function initTank()
    m.enemyTankUp = m.top.findNode("enemyTankUp")
    m.enemyTankRight = m.top.findNode("enemyTankRight")
    m.enemyTankDown = m.top.findNode("enemyTankDown")
    m.enemyTankLeft = m.top.findNode("enemyTankLeft")

    m.enemyTankUp.uri = m.TANK_UP_URI
    m.enemyTankUp.translation = m.TANK_TRANSLATION
    m.enemyTankUp.width = m.TANK_SIZE
    m.enemyTankUp.height = m.TANK_SIZE
    m.enemyTankUp.visible = false

    m.enemyTankRight.uri = m.TANK_RIGHT_URI
    m.enemyTankRight.translation = m.TANK_TRANSLATION
    m.enemyTankRight.width = m.TANK_SIZE
    m.enemyTankRight.height = m.TANK_SIZE
    m.enemyTankRight.visible = true

    m.enemyTankDown.uri = m.TANK_DOWN_URI
    m.enemyTankDown.translation = m.TANK_TRANSLATION
    m.enemyTankDown.width = m.TANK_SIZE
    m.enemyTankDown.height = m.TANK_SIZE
    m.enemyTankDown.visible = false

    m.enemyTankLeft.uri = m.TANK_LEFT_URI
    m.enemyTankLeft.translation = m.TANK_TRANSLATION
    m.enemyTankLeft.width = m.TANK_SIZE
    m.enemyTankLeft.height = m.TANK_SIZE
    m.enemyTankLeft.visible = false
end function

function setStartPosition()
    m.pressKey = "left"
    y = rnd(m.RANDOM_VALUE)
    if (y < m.TRANSLATION_OFFSET)
        y = m.TRANSLATION_OFFSET
    end if
    m.enemyTankUp.translation = [m.enemyTankUp.translation[0], y]
    m.enemyTankRight.translation = [m.enemyTankUp.translation[0], y]
    m.enemyTankDown.translation = [m.enemyTankUp.translation[0], y]
    m.enemyTankLeft.translation = [m.enemyTankUp.translation[0], y]
end function

function getTankData(flag as integer) as object
    obj = {}
    obj.width = m.enemyTankUp.width
    obj.height = m.enemyTankUp.height
    obj.x = m.enemyTankUp.translation[0]
    obj.y = m.enemyTankUp.translation[1]

    return obj
end function

function getBulletData(flag as integer) as object
    if (m.bullet <> invalid)
        obj = {}
        data = m.bullet.callFunc("getBulletData", 0)
        obj.width = data.width
        obj.height = data.height
        obj.x = data.x
        obj.y = data.y
    else
        return invalid
    end if

    return obj
end function

function removeTank(flag as integer)
    m.bulletProgress1.unobserveFieldScoped("visible")
    m.bulletProgress2.unobserveFieldScoped("visible")
    m.bulletProgress3.unobserveFieldScoped("visible")
    m.bulletProgress4.unobserveFieldScoped("visible")

    m.enemyTankRight.removeChild(m.bulletProgress1)
    m.enemyTankLeft.removeChild(m.bulletProgress2)
    m.enemyTankUp.removeChild(m.bulletProgress3)
    m.enemyTankDown.removeChild(m.bulletProgress4)

    m.enemyTankTimer.unobserveFieldScoped("fire")
    m.enemyTankTimer.control = "stop"
    m.top.visible = false
end function

function removeBullet(flag as integer)
    if (m.bullet <> invalid)
        m.bullet.callFunc("removeBullet", 0)
    end if
end function

function addProgressBullet()
    m.bulletProgress1 = createObject("roSGNode", "ProgressBullet")
    m.bulletProgress2 = createObject("roSGNode", "ProgressBullet")
    m.bulletProgress3 = createObject("roSGNode", "ProgressBullet")
    m.bulletProgress4 = createObject("roSGNode", "ProgressBullet")

    m.bulletProgress1.observeFieldScoped("visible", "onProgresComplete")
    m.bulletProgress2.observeFieldScoped("visible", "onProgresComplete")
    m.bulletProgress3.observeFieldScoped("visible", "onProgresComplete")
    m.bulletProgress4.observeFieldScoped("visible", "onProgresComplete")

    m.progresses = [m.bulletProgress1, m.bulletProgress2, m.bulletProgress3, m.bulletProgress4]

    m.bulletProgress1.callFunc("initProgressBullet", "right")
    m.bulletProgress2.callFunc("initProgressBullet", "left")
    m.bulletProgress3.callFunc("initProgressBullet", "up")
    m.bulletProgress4.callFunc("initProgressBullet", "down")

    m.enemyTankRight.appendChild(m.bulletProgress1)
    m.enemyTankLeft.appendChild(m.bulletProgress2)
    m.enemyTankUp.appendChild(m.bulletProgress3)
    m.enemyTankDown.appendChild(m.bulletProgress4)
end function

function onProgresComplete()
    m.isFire = false
end function

function setKey(key as string)
    if (key = "left" or key = "right" or key = "up" or key = "down")
        m.pressKey = key
    end if
end function

function letsFire(flag as integer)
    if(m.isFire = false)
        m.isFire = true
        obj = {}
        obj.startX = m.enemyTankUp.translation[0]
        obj.startY = m.enemyTankUp.translation[1]
        obj.offset = m.enemyTankUp.width
        obj.direction = m.pressKey

        recharge()

        m.bullet = createObject("roSGNode", "Bullet")
        m.bullet.observeFieldScoped("visible", "onRemoveBullet")
        m.scene.appendChild(m.bullet)
        m.bullet.callFunc("initBullet", obj)
    end if
end function

function recharge()
    for i = 0 to (m.progresses.count() - 1)
        m.progresses[i].callFunc("playProgress", true)
    end for

end function

function onRemoveBullet()
    m.bullet.unobserveFieldScoped("visible")
    m.scene.removeChild(m.bullet)
    m.bullet = invalid
end function

function initTimer()
    m.enemyTankTimer = m.top.findNode("enemyTankTimer")
    m.enemyTankTimer.repeat = true
    m.enemyTankTimer.duration = m.ENEMY_TANK_TIMER_DURATION
    m.enemyTankTimer.control = "START"
    m.enemyTankTimer.observeFieldScoped("fire", "onMoveItem")
end function

function onMoveItem()
    OFFSET = 10

    x = m.enemyTankUp.translation[0]
    y = m.enemyTankUp.translation[1]
    changeTank()
    letsFire(0)
    if(m.pressKey = "up")
        if(y > m.TRANSLATION_OFFSET)
            m.enemyTankUp.translation = [x, y - OFFSET]
            m.enemyTankRight.translation = [x, y - OFFSET]
            m.enemyTankDown.translation = [x, y - OFFSET]
            m.enemyTankLeft.translation = [x, y - OFFSET]
        else
            m.pressKey = "down"
        end if
    else if(m.pressKey = "down")
        if(y < (m.SCREEN_HEIGHT - m.enemyTankUp.height))
            m.enemyTankUp.translation = [x, y + OFFSET]
            m.enemyTankRight.translation = [x, y + OFFSET]
            m.enemyTankDown.translation = [x, y + OFFSET]
            m.enemyTankLeft.translation = [x, y + OFFSET]
        else
            m.pressKey = "up"
        end if
    else if(m.pressKey = "left")
        if(x > 0)
            m.enemyTankUp.translation = [x - OFFSET, y]
            m.enemyTankRight.translation = [x - OFFSET, y]
            m.enemyTankDown.translation = [x - OFFSET, y]
            m.enemyTankLeft.translation = [x - OFFSET, y]
        else
            m.pressKey = "right"
        end if
    else if(m.pressKey = "right")
        if(x < (m.SCREEN_WIDTH - m.enemyTankUp.width))
            m.enemyTankUp.translation = [x + OFFSET, y]
            m.enemyTankRight.translation = [x + OFFSET, y]
            m.enemyTankDown.translation = [x + OFFSET, y]
            m.enemyTankLeft.translation = [x + OFFSET, y]
        else
            m.pressKey = "left"
        end if
    end if
end function

function changeTank()
    if (m.pressKey <> "")
        m.enemyTankUp.visible = false
        m.enemyTankRight.visible = false
        m.enemyTankDown.visible = false
        m.enemyTankLeft.visible = false
    end if

    if (m.pressKey = "up")
         m.enemyTankUp.visible = true
    else if (m.pressKey = "down")
        m.enemyTankDown.visible = true
    else if (m.pressKey = "right")
        m.enemyTankRight.visible = true
    else if (m.pressKey = "left")
        m.enemyTankLeft.visible = true
    end if
end function