function initBullet(obj as object)
    m.ROTATION = 1.57
    m.SCREEN_WIDTH = 1280
    m.SCREEN_HEIGHT = 720
    m.TRANSLATION_OFFSET = 30
    m.BULLET_WIDTH = 20
    m.BULLET_HEIGHT = 5
    m.BULLET_DURATION = 0.010

    initElement()

    m.offset = obj.offset/2
    m.bulletRectangle.translation = [obj.startX, obj.startY]
    m.direction = obj.direction
    changeDirection()
    initTimer()
end function

function initElement()
    m.bulletRectangle = m.top.findNode("bulletRectangle")
    m.bulletRectangle.width = m.BULLET_WIDTH
    m.bulletRectangle.height = m.BULLET_HEIGHT
end function

function initTimer()
    m.bulletTimer = m.top.findNode("bulletTimer")
    m.bulletTimer.repeat = true
    m.bulletTimer.duration = m.BULLET_DURATION
    m.bulletTimer.control = "START"
    m.bulletTimer.observeField("fire", "onMoveBullet")
end function

function removeBullet(flag as integer)
    if (m.top.visible = true)
        m.bulletTimer.unobserveField("fire")
        m.bulletTimer.control = "stop"
        m.top.visible = false
    end if
end function

function changeDirection()
    x = m.bulletRectangle.translation[0]
    y = m.bulletRectangle.translation[1]

    if (m.direction = "left")
        m.bulletRectangle.rotation = 0
        m.bulletRectangle.translation = [x, y + m.offset]
    else if (m.direction = "right")
        m.bulletRectangle.rotation = 0
        m.bulletRectangle.translation = [x + m.offset*2, y + m.offset]
    else if (m.direction = "up")
        m.bulletRectangle.rotation = m.ROTATION
        m.bulletRectangle.translation = [x + m.offset, y]
    else if (m.direction = "down")
        m.bulletRectangle.rotation = -m.ROTATION
        m.bulletRectangle.translation = [x + m.offset, y  + m.offset*2]
    end if
end function

function getBulletData(flag as integer) as object
    obj = {}
    obj.width = m.bulletRectangle.width
    obj.height = m.bulletRectangle.height
    obj.x = m.bulletRectangle.translation[0]
    obj.y = m.bulletRectangle.translation[1]

    return obj
end function

function onMoveBullet()
    OFFSET = 20

    isStop = false
    x = m.bulletRectangle.translation[0]
    y = m.bulletRectangle.translation[1]

    if (m.direction = "left")
        m.bulletRectangle.translation = [x - OFFSET, y]

        if(x < 0)
            isStop = true
        end if
    else if (m.direction = "right")
        m.bulletRectangle.translation = [x + OFFSET, y]
        if(x > m.SCREEN_WIDTH)
            isStop = true
        end if
    else if (m.direction = "up")
        m.bulletRectangle.translation = [x, y - OFFSET]
        if(y < m.TRANSLATION_OFFSET)
            isStop = true
        end if
    else if (m.direction = "down")
        m.bulletRectangle.translation = [x, y + OFFSET]
        if(y > m.SCREEN_HEIGHT)
            isStop = true
        end if
    end if

    if(isStop)
        m.bulletTimer.unobserveField("fire")
        m.bulletTimer.control = "stop"
        m.top.visible = false
    end if
end function