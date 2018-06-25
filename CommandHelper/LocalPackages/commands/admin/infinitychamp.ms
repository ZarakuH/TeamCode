register_command('infinitychamp', 

    array(
        'description': 'Gives a player infinity champ perms',
        'usage': '/infinitychamp <player>',
        'permission': 'infinity.champ',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
                return(false)
            }

            @player = player()
            @vic = player(@args[0])
            if(has_permission(@vic,'donot.hire')){
                msg(color('RED').'Sorry, that person can no longer be hired')
                die()
            }

            include('/home/minecraft/server/plugins/CommandHelper/includes/checkJobs.ms')
            if(!_checkJobs(@vic)){
                die()
            }
            
            runas('~console',"/pex user ".@vic." add is.infinity")
            runas('~console',"/pex user ".@vic." group add infinity")
            tmsg(@player,color('RED')."You have made ".@vic. " the Infinity Champion!")
            tmsg(@vic,color('RED')."You are now the Infinity Champion!")
        }
    )
)

register_command('infinitytake', 

    array(
        'description': 'Takes away a players perms of infinitychamp',
        'usage': '/infinitytake <player>',
        'permission': 'infinity.take',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
                return(false)
            }
        
            @player = player()
            @vic = player(@args[0])

            runas('~console',"/pex user ".@vic." remove is.infinity")
            runas('~console',"/pex user ".@vic." group remove infinity")
            tmsg(@player,color('RED')."You have stripped ". @vic ." of Infinite Power!")
            tmsg(@vic,color('RED')."You have lost your Infinite power")
        }
    )
)
