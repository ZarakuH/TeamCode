register_command('destinychamp', 

    array(
        'description': 'Gives a player destiny champ perms',
        'usage': '/destinychamp <player>',
        'permission': 'destiny.champ',
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
            
            runas('~console',"/pex user ".@vic." add is.destiny")
            runas('~console',"/pex user ".@vic." group add destiny")
            tmsg(@player,color('RED')."You have made ".@vic. " the Destiny Champion!")
            tmsg(@vic,color('RED')."You are now the Destiny Champion!")
        }
    )
)

register_command('destinytake', 

    array(
        'description': 'Takes away a players perms of destinychamp',
        'usage': '/destinytake <player>',
        'permission': 'destiny.take',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
                return(false)
            }
        
            @player = player()
            @vic = player(@args[0])

            runas('~console',"/pex user ".@vic." remove is.destiny")
            runas('~console',"/pex user ".@vic." group remove destiny")
            tmsg(@player,color('RED')."You have stripped ". @vic ." of the Spear of Destiny!")
            tmsg(@vic,color('RED')."You have lost your Spear of Destiny")
        }
    )
)
