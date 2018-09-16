register_command('taxi', 

    array(
        'description': 'taxi',
        'usage': '/taxi <person>',
        'permission': 'command.taxi',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            @numArgs = array_size(@args)
            if(@numArgs > 1){
                tmsg(@sender,color('RED').'Usage: /taxi <destination>')
                tmsg(@sender,color('RED').'or')
                tmsg(@sender,color('RED').'Usage: /taxi')
                return()
            }

            if(@numArgs == 0){
               sudo('/warp')
               return()
            }

            @dest = @args[0]

            if(acc_balance(@sender) >= 20)) {
               acc_subtract(@sender, 20)
               sudo('/warp '.@dest)
               tmsg(@sender,color('RED').'Taxi fee: $20.')
            } else {
                tmsg(@sender,color('RED').'You do not have enough money.')
            }
        }
    )
) 