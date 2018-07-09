register_command('timer',
    array(
        'description': 'A Timer',
        'usage': '/timer <gameName> <single/group> <start/stop> [secs] [player]',
        'permission': 'command.timer',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',

        'executor': closure(@alias, @sender, @args) {

            switch (array_size(@args)) {
                case 3:
                    @secs = 10
                    @player = ''
                    break ()
                case 4:
                    @secs = @args[3]
                    @player = ''
                    break ()
                case 5:
                    @secs = @args[3]
                    @player = @args[4]
                    break ()
                default:
                    msg('Usage: /timer <gameName> <single/group> <start/stop> [secs] [player]')
                    return ()
            }

            if (@args[1] != 'single' && @args[1] != 'group') {
                msg('Make sure you spelled "single" or "group" correctly. The correct usage is: /timer <gameName> <single/group> [secs] [player]')
                return ()
            }

            @gameName = @args[0]
            @timerType = @args[1]
            @startStop = @args[2]




            if (@timerType == 'single') {
                if (@startStop == 'stop') {
		    @prevTime = import('timer'.@gameName.@player)
                    @curTime = time()
                    @elapsedTime = ((@curTime - @prevTime) / 1000)
                    broadcast(@player.' finished '.@gameName.' in '.@elapsedTime.' seconds!')
                    export ('timer'.@gameName.@player, null)
                    return ()
                } else {
                    @countdown = import(@gameName.@player.'countDown')
                    if(@countdown != null){
                        clear_task(@countdown)
                    }
                    tmsg(@player, @gameName.' is starting in '.@secs.'...')
                    @secs--
                    export(@gameName.@player.'countDownNum',@secs)
                    @id = set_interval(1000, closure(
                        @secsLeft = import(@gameName.@player.'countDownNum')
                        if (@secsLeft == 0) {
			    export('timer'.@gameName.@player, time())
                            tmsg(@player, 'GO!')
                            clear_task()
                            return()
                        }
                        tmsg(@player, @secsLeft.'...')
                        @secsLeft--
                        export(@gameName.@player.'countDownNum',@secsLeft)
                    ))
                    export(@gameName.@player.'countDown',@id)
                }
            } else {
                if (@startStop == 'stop') {
                    @prevTime = import('timer'.@gameName)
                    @curTime = time()
                    @elapsedTime = ((@curTime - @prevTime) / 1000)
                    broadcast(@player.' finished '.@gameName.' in '.@elapsedTime.' seconds!')
                    export ('timer'.@gameName, null)
                    return ()
                } else {
                    @countdown = import(@gameName.'countDown')
                    if(@countdown != null){
                        clear_task(@countdown)
                    }
                    broadcast(@gameName.' is starting in '.@secs.'...')
                    @secs--
                    export(@gameName.'countDownNum',@secs)
                    @id = set_interval(1000, closure(
                        @secsLeft = import(@gameName.'countDownNum')
                        if (@secsLeft == 0) {
                            broadcast('GO!')
			    export('timer'.@gameName, time())
                            clear_task()
                            return()
                        }
                        broadcast(@secsLeft.'...')
                        @secsLeft--
                        export(@gameName.'countDownNum',@secsLeft)
                    ))
                    export(@gameName.'countDown',@id)
                }
            }
        }
    )
)
