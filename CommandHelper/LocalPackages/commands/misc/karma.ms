register_command('karmabal', 
    array(
        'description': 'Shows your karma balance',
        'usage': '/karmabal',
        'permission': 'karma.balance',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(num_args(@args) > 0){
                tmsg(@sender,color('RED').'Usage: /karmabal')
                return()
            }

            @uuid = puuid(@sender)

            if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')){
                tmsg(@sender,color('RED').'You look like a first timer, creating your Karma file...')
                @data = associative_array()
                @data['karma'] = 5
                write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml',yml_encode(@data,true),'OVERWRITE')
                tmsg(@sender,color('RED').'Done!') 
                tmsg(@sender,color('RED').'You have 5 Karma!')
                tmsg(@sender,color('RED').'Visit /warp Karma to read up on what it is, how to use it, and why you want it!')
            }else{
                @data = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')
                @data = yml_decode(@data)
                tmsg(@sender,color('RED').'You have '.@data['karma'].' Karma!')
            }
        }
    )
)

register_command('karmapay', 
    array(
        'description': 'Shows your karma balance',
        'usage': '/karmabal',
        'permission': 'karma.balance',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(num_args(@args) > 0){
                tmsg(@sender,color('RED').'Usage: /karmabal')
                return()
            }
            @target = @args[0]
            @amount = @args[1]
            try{
                @target = player(@target)
            }(catch @e){
                tmsg(@sender,color('RED').'Did you spell their name right?')
                return()
            }

            @data = import(@sender.'karmadata')

            if(@data == null){
                @data = associative_array()
                @data['karma'] = 5
        
            if(@amount < 1){
                tmsg(@sender,color('RED').'Sorry, you cannot pay less than 1 Karma.')
                return()
            }
            if(@amount > @data['karma'){
                tmsg(@sender,color('RED').'Sorry, you can only afford to pay '.@data['karma'].' Karma.')
                return()
            }

            @targetUUID = puuid(@target)

             if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml')){
                @data['karma'] = 5 + @amount
                write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml',yml_encode(@data,true),'OVERWRITE')
                tmsg(@sender,color('RED').'Done! You have paid them '.@amount.' Karma!')
            }else{
                @data = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml')
                @data = yml_decode(@data)
                @data['karma'] = @data['karma'] + @amount
                tmsg(@sender,color('RED').'Done! You have paid them '.@amount.' Karma!')
            }
        }
    )
)

