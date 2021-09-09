function initScreen(scene as dynamic)
    m.RANDOM_VALUE = 600
    m.TRANSLATION_OFFSET = 30
    m.SCREEN_WIDTH = 1280
    m.SCREEN_HEIGHT = 720

    m.TANK_SIZE = 100
    m.TANK_TRANSLATION = [0, 30]
    m.TANK_RIGHT_URI = "pkg:/images/tank1.png"
    m.TANK_DOWN_URI = "pkg:/images/tank2.png"
    m.TANK_LEFT_URI = "pkg:/images/tank3.png"
    m.TANK_UP_URI = "pkg:/images/tank0.png"

    m.TANK_TIMER_DURATION = 0.050

    initTank()
    addProgressBullet()

    initTimer()
    setStartPosition()
    m.scene = scene
    m.isFire = false
end function

function initTank()
    m.tankUp = m.top.findNode("tankUp")
    m.tankRight = m.top.findNode("tankRight")
    m.tankDown = m.top.findNode("tankDown")
    m.tankLeft = m.top.findNode("tankLeft")

    m.tankUp.uri = m.TANK_UP_URI
    m.tankUp.translation = m.TANK_TRANSLATION
    m.tankUp.width = m.TANK_SIZE
    m.tankUp.height = m.TANK_SIZE
    m.tankUp.visible = false

    m.tankRight.uri = m.TANK_RIGHT_URI
    m.tankRight.translation = m.TANK_TRANSLATION
    m.tankRight.width = m.TANK_SIZE
    m.tankRight.height = m.TANK_SIZE
    m.tankRight.visible = true

    m.tankDown.uri = m.TANK_DOWN_URI
    m.tankDown.translation = m.TANK_TRANSLATION
    m.tankDown.width = m.TANK_SIZE
    m.tankDown.height = m.TANK_SIZE
    m.tankDown.visible = false

    m.tankLeft.uri = m.TANK_LEFT_URI
    m.tankLeft.translation = m.TANK_TRANSLATION
    m.tankLeft.width = m.TANK_SIZE
    m.tankLeft.height = m.TANK_SIZE
    m.tankLeft.visible = false
end function

function setStartPosition()
    m.pressKey = "right"
    y = rnd(m.RANDOM_VALUE)
    if (y < m.TRANSLATION_OFFSET)
        y = m.TRANSLATION_OFFSET
    end if
    m.tankUp.translation = [m.tankUp.translation[0], y]
    m.tankRight.translation = [m.tankUp.translation[0], y]
    m.tankDown.translation = [m.tankUp.translation[0], y]
    m.tankLeft.translation = [m.tankUp.translation[0], y]
end function

function getTankData(flag as integer) as object
    obj = {}
    obj.width = m.tankUp.width
    obj.height = m.tankUp.height
    obj.x = m.tankUp.translation[0]
    obj.y = m.tankUp.translation[1]

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

    m.tankRight.appendChild(m.bulletProgress1)
    m.tankLeft.appendChild(m.bulletProgress2)
    m.tankUp.appendChild(m.bulletProgress3)
    m.tankDown.appendChild(m.bulletProgress4)
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
        obj.startX = m.tankUp.translation[0]
        obj.startY = m.tankUp.translation[1]
        obj.offset = m.tankUp.width
        obj.direction = m.pressKey

        recharge()

        m.bullet = createObject("roSGNode", "Bullet")
        m.bullet.observeFieldScoped("visible", "onRemoveBullet")
        m.scene.appendChild(m.bullet)
        m.bullet.callFunc("initBullet", obj)
    end if
end function

function removeBullet(flag as integer)
    if (m.bullet <> invalid)
        m.bullet.callFunc("removeBullet", 0)
    end if
end function

function removeTank(flag as integer)
    m.bulletProgress1.unobserveFieldScoped("visible")
    m.bulletProgress2.unobserveFieldScoped("visible")
    m.bulletProgress3.unobserveFieldScoped("visible")
    m.bulletProgress4.unobserveFieldScoped("visible")

    m.tankRight.removeChild(m.bulletProgress1)
    m.tankLeft.removeChild(m.bulletProgress2)
    m.tankUp.removeChild(m.bulletProgress3)
    m.tankDown.removeChild(m.bulletProgress4)

    m.tankTimer.unobserveFieldScoped("fire")
    m.tankTimer.control = "stop"
    m.top.visible = false
end function

function recharge()
    for i = 0 to (m.progresses.count() - 1)
        m.progresses[i].callFunc("playProgress", true)
    end for
end function

function onRemoveBullet()
    m.scene.removeChild(m.bullet)
    m.bullet.unobserveFieldScoped("visible")
    m.bullet = invalid
end function

function initTimer()
    m.tankTimer = m.top.findNode("tankTimer")
    m.tankTimer.duration = m.TANK_TIMER_DURATION
    m.tankTimer.repeat = true
    m.tankTimer.control = "start"
    m.tankTimer.observeFieldScoped("fire", "onMoveItem")
end function

function onMoveItem()
    OFFSET = 10
    x = m.tankUp.translation[0]
    y = m.tankUp.translation[1]
    changeTank()
    if(m.pressKey = "up")
        if(y > m.TRANSLATION_OFFSET)
            m.tankUp.translation = [x, y - OFFSET]
            m.tankRight.translation = [x, y - OFFSET]
            m.tankDown.translation = [x, y - OFFSET]
            m.tankLeft.translation = [x, y - OFFSET]
        else
            m.pressKey = "down"
        end if
    else if(m.pressKey = "down")
        if(y < (m.SCREEN_HEIGHT - m.tankUp.height))
            m.tankUp.translation = [x, y + OFFSET]
            m.tankRight.translation = [x, y + OFFSET]
            m.tankDown.translation = [x, y + OFFSET]
            m.tankLeft.translation = [x, y + OFFSET]
        else
            m.pressKey = "up"
        end if
    else if(m.pressKey = "left")
        if(x > 0)
            m.tankUp.translation = [x - OFFSET, y]
            m.tankRight.translation = [x - OFFSET, y]
            m.tankDown.translation = [x - OFFSET, y]
            m.tankLeft.translation = [x - OFFSET, y]
        else
            m.pressKey = "right"
        end if
    else if(m.pressKey = "right")
        if(x < (m.SCREEN_WIDTH - m.tankUp.width))
            m.tankUp.translation = [x + OFFSET, y]
            m.tankRight.translation = [x + OFFSET, y]
            m.tankDown.translation = [x + OFFSET, y]
            m.tankLeft.translation = [x + OFFSET, y]
        else
            m.pressKey = "left"
        end if
    end if
end function

function changeTank()
    if (m.pressKey <> "")
        m.tankUp.visible = false
        m.tankRight.visible = false
        m.tankDown.visible = false
        m.tankLeft.visible = false
    end if

    if (m.pressKey = "up")
         m.tankUp.visible = true
    else if (m.pressKey = "down")
        m.tankDown.visible = true
    else if (m.pressKey = "right")
        m.tankRight.visible = true
    else if (m.pressKey = "left")
        m.tankLeft.visible = true
    end if
end function