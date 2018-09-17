register_command('lightfix', 

    array(
        'description': 'Roll the Dice. Play the Lottery',
        'usage': '/roll',
        'permission': 'command.lightfix',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            bind('player_move',array('id': @sender.'lightFixBind'),array('player': @sender),@event){
                @ploc = ploc(@event['player'])
                @ploc['y'] = @ploc['y'] + 1
                @oldBlock = get_block(@ploc)

                if(@oldBlock == 'AIR'){
                    set_block(@ploc,169)
    
                    set_timeout(500,closure(
                        set_block(@ploc,'AIR')
                    ))
                }
            }
        }
    )
)
register_command('lightfixstop', 

    array(
        'description': 'Roll the Dice. Play the Lottery',
        'usage': '/roll',
        'permission': 'command.lightfixstop',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {
            unbind(@sender.'lightFixBind')
        }
    )
)
