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

            @taxiLocs = array(
                'chinatown',
                'walmart',
                'docks',
                'cruiseship',
                'shopping',
                'construction',
                'plaza',
                'stadium',
                'residential',
                'firehall',
                'police'
            )

            if(@numArgs == 0){
                @locs = ''
                foreach(@loc in @taxiLocs){
                   @locs = @locs.@loc.', '
                }
                tmsg(@sender,color('RED').'Taxi Locations')
                tmsg(@sender,@locs)
                tmsg(@sender,color('RED').'------------------')
                return()
            }

            @dest = @args[0]

            @allowed = false
            foreach(@loc in @taxiLocs){
                if(@dest == @loc){
                    @allowed = true
                    break()
                }
            }

            if(!@allowed){
                tmsg(@sender,color('RED').'Sorry, that is not a taxi location.')
                return()
            }

            if(acc_balance(@sender) >= 20) {
               acc_subtract(@sender, 20)
               sudo('/warp '.@dest)
               tmsg(@sender,color('RED').'Taxi fee: $20.')
            } else {
                tmsg(@sender,color('RED').'You do not have enough money.')
            }
        }
    )
) 