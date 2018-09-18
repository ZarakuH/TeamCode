register_command('balkarma', 
    array(
        'description': 'Shows your Karma balance',
        'usage': '/balkarma',
        'permission': 'karma.balkarma',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(array_size(@args) > 0){
                tmsg(@sender,color('RED').'Usage: /balkarma')
                return()
            }

            @uuid = puuid(@sender)

            if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')){
                tmsg(@sender,color('RED').'You look like a first timer, creating your Karma file...')
                @data = associative_array()
                @data['karma'] = 100
                write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml',yml_encode(@data,true),'OVERWRITE')
                tmsg(@sender,color('RED').'Done!') 
                tmsg(@sender,color('RED').'You have 100 Karma!')
                tmsg(@sender,color('RED').'Visit /warp Karma to read up on what it is, how to use it, and why you want it!')
            }else{
                @data = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')
                @data = yml_decode(@data)
                tmsg(@sender,color('RED').'You have '.@data['karma'].' Karma!')
            }
        }
    )
)

register_command('payrep', 
    array(
        'description': 'Pays someone some Reputation',
        'usage': '/payrep',
        'permission': 'karma.payrep',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(array_size(@args) != 2){
                tmsg(@sender,color('RED').'Usage: /payrep <person> <amount>')
                return()
            }
            @target = @args[0]
            @amount = @args[1]
            try{
                @target = player(@target)
            }catch(Exception @e){
                tmsg(@sender,color('RED').'Did you spell their name right?')
                return()
            }

            if(@target == @sender){
                tmsg(@sender,color('RED').'You cannot pay yourself.')
                tmsg(@sender,color('RED').'Usage: /payrep <person> <amount>')
                return()
            }

            if(!is_numeric(@amount)){
                tmsg(@sender,color('RED').'Make sure the amount is a number.')
                tmsg(@sender,color('RED').'Usage: /payrep <person> <amount>')
                return()
            }
            if(@amount < 1){
                tmsg(@sender,color('RED').'Sorry, you cannot pay less than 1 Reputation.')
                return()
            }

            @reputation = import(@sender.'reputation')

            if(@reputation == null){
                @reputation = associative_array()
                @reputation['reputation'] = 10
            }
            if(@amount > @reputation['reputation']){
                tmsg(@sender,color('RED').'Sorry, you can only afford to pay '.@reputation['reputation'].' reputation.')
                tmsg(@sender,color('RED').'You will get 10 Reputation (does not accumulate) to pay out every 20 minutes.')
                return()
            }

            @targetUUID = puuid(@target)

             if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml')){
                @data = associative_array()
                @data['karma'] = 100 + @amount
            }else{
                @data = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml')
                @data = yml_decode(@data)
                @data['karma'] = @data['karma'] + @amount
            }
            write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml',yml_encode(@data,true),'OVERWRITE')
            @reputation['reputation'] = @reputation['reputation'] - @amount
            export(@sender.'reputation',@reputation)
            broadcast(color('RED').@sender.' paid '.@target.' '.@amount.' Karma!')
        }
    )
)

register_command('balrep', 
    array(
        'description': 'Shows your karma balance',
        'usage': '/balrep',
        'permission': 'karma.balrep',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(array_size(@args) > 0){
                tmsg(@sender,color('RED').'Usage: /balrep')
                return()
            }

            @uuid = puuid(@sender)
            @reputation = import(@sender.'reputation')
            if(@reputation == null){
                @reputation = associative_array()
                @reputation['reputation'] = 10
                export(@sender.'reputation',@reputation)
                tmsg(@sender,color('RED').'You have 10 Reputation you can pay to other people.')
            }else{
                tmsg(@sender,color('RED').'You have '.@reputation['reputation'].' Reputation to pay people with!')
            }
        }
    )
)

set_cron('*/20 * * * *',closure(

    @players = all_players()
    @sendingKarma = associative_array()
    @sendingKarma['karma'] = 10
    foreach(@player in @players){
        export(@player.'reputation',@sendingKarma)
    }
    broadcast(color('RED').'All online players have had their Payment Karma filled!')

))