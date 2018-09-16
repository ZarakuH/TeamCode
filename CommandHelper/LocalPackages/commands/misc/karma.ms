register_command('karmabal', 
    array(
        'description': 'Shows your karma balance',
        'usage': '/karmabal',
        'permission': 'karma.balance',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            @uuid = puuid(@sender)

            if(!file_exists('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')){
                tmsg(@sender,color('RED').'You look like a first timer, creating your Karma file...')
                @data['karma'] = 5
                write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml',yml_encode(@data,true))
                tmsg(@sender,color('RED').'Done!') 
                tmsg(@sender,color('RED').'You have 5 Karma!')
                tmsg(@sender,color('RED').'Visit /warp Karma to read up on what it is, how to use it, and why you want it!')
            }else{
                @data = write_file('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/karma/'.@uuid.'.yml')
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

        }
    )
)

