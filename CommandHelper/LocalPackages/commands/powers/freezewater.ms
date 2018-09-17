register_command('freezewater', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.freezewater',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 0) {
                return(false)
            }
            
            @player = player()
            @loc = ploc(@player)
            @radius = 2
            @blocktype = '8:'
            @bl2 = '9:'
            @world = pworld(@player)

            @blocksChanged = array()

            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedWind',10,@player)){
                return()
            }

            for(@x = @loc[0] - @radius, @x <= @loc[0] + @radius, @x++) {
                for(@y = @loc[1] - @radius, @y <= @loc[1] + @radius, @y++) {
                    for(@z = @loc[2] - @radius, @z <= @loc[2] + @radius, @z++) {
                        @arrLoc = array(@x,@y,@z)
                        @block = get_block(@arrLoc)
                        if(@block[0].@block[1] == @blocktype || @block[0].@block[1] == @bl2) {
                            @arrLoc = array(@x,@y,@z)
                            set_block(@arrLoc, 'minecraft:ice')
                            @blkLoc = array(@x,@y,@z,@world,@block)
                            array_push(@blocksChanged,@blkLoc)
                        }
                    }
                }
            }

            if(array_size(@blocksChanged) == 0){
                msg(color('RED').'Sorry, there needs to be water closer.')
                die()
            }
            
            export(@player.'blocksFrozen',@blocksChanged)

            set_timeout(3000,closure(
                @blocksChanged = import(@player.'blocksFrozen')
                foreach(@block in @blocksChanged){
                    @arrLoc = array(@block[0],@block[1],@block[2],@block[4])
                    set_block(@arrLoc,@block[3])
                }
            ))
        }
    )
)
