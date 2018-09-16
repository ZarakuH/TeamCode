register_command('karmabal', 
    array(
        'description': 'Shows your karma balance',
        'usage': '/karmabal',
        'permission': 'karma.balance',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(array_size(@args) > 0){
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

            if(array_size(@args) > 0){
                tmsg(@sender,color('RED').'Usage: /karmapay <person> <amount>')
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
                tmsg(@sender,color('RED').'Usage: /karmapay <person> <amount>')
                return()
            }

            if(!is_number(@amount)){
                tmsg(@sender,color('RED').'Make sure the amount is a number.')
                tmsg(@sender,color('RED').'Usage: /karmapay <person> <amount>')
                return()
            }

            @sendingKarma = import(@sender.'paymentKarma')

            if(@sendingKarma == null){
                @sendingKarma = associative_array()
                @sendingKarma['karma'] = 5
            }
            if(@amount < 1){
                tmsg(@sender,color('RED').'Sorry, you cannot pay less than 1 Karma.')
                return()
            }
            if(@amount > @sendingKarma['karma']){
                tmsg(@sender,color('RED').'Sorry, you can only afford to pay '.@sendingKarma['karma'].' Karma.')
                tmsg(@sender,color('RED').'You will get 10 karma (does not accumulate) to pay out every 20 minutes.')
                return()
            }

            @targetUUID = puuid(@target)

             if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml')){
                @recievingKarma['karma'] = 5 + @amount
            }else{
                @recievingKarma = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml')
                @recievingKarma = yml_decode(@recievingKarma)
                @recievingKarma['karma'] = @recievingKarma['karma'] + @amount
            }
            write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@targetUUID.'.yml',yml_encode(@recievingKarma,true),'OVERWRITE')
            @sendingKarma = @sendingKarma - @amount
            export(@sender.'paymentKarma',@sendingKarma)
            tmsg(@sender,color('RED').'Done! You have paid them '.@amount.' Karma!')
        }
    )
)

register_command('karmapaybal', 
    array(
        'description': 'Shows your karma balance',
        'usage': '/karmabal',
        'permission': 'karma.balance',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(array_size(@args) > 0){
                tmsg(@sender,color('RED').'Usage: /karmabal')
                return()
            }

            @uuid = puuid(@sender)
            @paymentKarma = import(@sender.'paymentKarma')
            if(@paymentKarma == null){
                @paymentKarma = associative_array()
                @paymentKarma['karma'] = 10
                export(@sender.'paymentKarma',@sendingKarma)
                tmsg(@sender,color('RED').'You have 10 Karma you can pay to other people.')
            }else{
                tmsg(@sender,color('RED').'You have '.@paymentKarma['karma'].' Karma to pay people with!')
            }
        }
    )
)

set_cron('*/20 * * * *',closure(

    @players = all_players()
    @sendingKarma = associative_array()
    @sendingKarma['karma'] = 10
    foreach(@player in @players){
        export(@player.'paymentKarma',@sendingKarma)
    }

))