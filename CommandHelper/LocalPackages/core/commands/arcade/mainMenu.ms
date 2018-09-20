register_command('mainmenu', 

    array(
        'description': 'Unplugs from The Matrix',
        'permission': 'command.mainmenu',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {        
            
            @plr = player()
            assign(@cooldown, 10)

            assign(@lastUsedMindLock, import(@plr."lastUsedMainMenu"))
            if(@lastUsedMindLock + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedMindLock, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can use this again!'))
                die()
            )

            @uuid = puuid(@plr)

            if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')){
                @data = associative_array()
                @data['karma'] = 100
            }else{
                @data = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')
                @data = yml_decode(@data)
            }

            tmsg(@plr,color('RED').'You have a '.@data['karma'].'% chance of becoming a superhero.')
            tmsg(@plr,color('RED').'This is based on how much Karma you have.')
            tmsg(@plr,color('RED').'If you fail, you will have 10% less chance on your next attempt, until you get more Karma by doing jobs for people.')
            tmsg(@plr,color('RED').'Type "yes" to continue or "no" to cancel...')

            bind('player_chat', null, array('player': player()), @e, @data, @plr, @uuid){
                @msg = @e['message']
                if(@msg == 'yes' || @msg == '/yes'){
                    @rand = rand(1,101)
                    if(@rand > @data['karma']){
                        if(@data['karma'] >= 10){
                            @data['karma'] = @data['karma'] - 10
                        }else{
                            @data['karma'] = 0
                        }
                        tmsg(@plr,color('RED').'Oof, sorry, maybe next time!')
                        tmsg(@plr,color('RED').'If you try again, you\'ll have a '.@data['karma'].'% chance!')
                        console(color('RED').'If you try again, you\'ll have a '.@data['karma'].'% chance!')
                        write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml',yml_encode(@data,true),'OVERWRITE')
                        cancel()
                        unbind()
                        return()
                    }else{
                        cancel()
                        unbind()
                        tmsg(@plr,color('GREEN').'Success! Time to pick a hero! Choose wisely!')
                        if(@data['karma'] < 100){
                            @data['karma'] = 0
                        }else{
                            @data['karma'] = @data['karma'] - 100
                        }
                        
                        write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml',yml_encode(@data,true),'OVERWRITE')
                        include('/home/minecraft/server/plugins/CommandHelper/includes/mortal.ms')
                        _mortal(@plr)
                        queue_push(closure(runas('~console','/cmi warp mainmenu '.@plr)))
                        //set_timeout(3100,closure(
                        //    queue_push(closure(set_peffect(@plr,14,1,9999,true,false)))
                        //))
                    }
                }else{
                    tmsg(@plr,color('RED').'Cancelled the chance to be a superhero.')
                    cancel()
                    unbind()
                    return()
                }
            }
        }
    )
)
register_command('leavemenu', 

    array(
        'description': 'Unplugs from The Matrix',
        'permission': 'command.leavemenu',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {        
            
            @plr = @args[0]
            assign(@cooldown, 10)
            
            assign(@lastUsedMindLock, import(@plr."lastUsedMainMenu"))
            if(@lastUsedMindLock + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedMindLock, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can exit!'))
                die()
            )

            include('/home/minecraft/server/plugins/CommandHelper/includes/mortal.ms')
            _mortal(@plr)
            queue_push(closure(runas('~console','/cmi warp vrexit '.@plr)))
        }
    )
)
