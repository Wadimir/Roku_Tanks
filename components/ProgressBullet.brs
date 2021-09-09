function initProgressBullet(direction as string)
    m.ROTATION = 1.57
    m.TRANSLATION_UP = [100, 0]
    m.TRANSLATION_DOWN = [0, 100]
    m.PROGRESS = 100
    m.BULLET_HEIGHT = 5
    m.PROGRESS_BULLET_WIDTH = 10
    m.PROGRESS_BULLET_DURATION = 0.1

    m.bulletProgress = m.top.findNode("bulletProgress")
    m.bulletProgress.width = m.PROGRESS_BULLET_WIDTH
    m.bulletProgress.height = m.PROGRESS
    setDirection(direction)
end function

function playProgress(flag as Boolean)
    m.bulletProgress.height = 0
    initTimer()
end function

function setDirection(direction as string)
    if (direction = "left")
        m.bulletProgress.rotation = 0
        m.bulletProgress.translation = m.TRANSLATION_UP
    else if (direction = "right")
        m.bulletProgress.rotation = 0
    else if (direction = "up")
        m.bulletProgress.rotation = m.ROTATION
        m.bulletProgress.translation = m.TRANSLATION_DOWN
    else if (direction = "down")
        m.bulletProgress.rotation = m.ROTATION
    end if
end function

function initTimer()
    m.timerProgressBullet = m.top.findNode("timerProgressBullet")
    m.timerProgressBullet.repeat = true
    m.timerProgressBullet.duration = m.PROGRESS_BULLET_DURATION
    m.timerProgressBullet.observeFieldScoped("fire", "onRecharge")
    m.timerProgressBullet.control = "start"
end function

function onRecharge()
    m.bulletProgress.height += m.BULLET_HEIGHT

    if (m.bulletProgress.height = m.PROGRESS)
        m.timerProgressBullet.control = "stop"
        m.timerProgressBullet.unobserveFieldScoped("fire")
        m.top.visible = false
        m.top.visible = true
    end if
end function