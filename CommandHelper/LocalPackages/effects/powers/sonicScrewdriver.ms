bind('player_interact',null,array('button': 'RIGHT'),@event){
    
    @player = player()
    @wasPlaced = false
    
    if(!has_permission(@player,"powers.sonicscrewdriver")){
        die()
    }
    @item = pinv(@player,null)
    if(@item == null || @item['name'] != 'minecraft:redstone_torch'){
        die()
    }
    
    if(@item['meta'] == null || @item['meta']['display'] == null){
        die()
    }

    
    //adjust the names of the screwdrivers to match these. only 1 name was programmed originally
     switch(@item['meta']['display']){
        case '§4S§7onic §0S§7crewdr§8i§7ver':
            break()
        default:
            return()
     } 


    assign(@cooldown, 10)
    assign(@lastSonicScrewdriver, import(@player.'lastSonicScrewdriver'))
    if(@lastSonicScrewdriver + @cooldown > time() / 1000,
        tmsg(@player,color('RED').'Sonic Screwdriver has a 10 second cooldown!')
        die()
    )
    export(@player.'lastSonicScrewdriver', time() / 1000)
    
    
    try(
        @face = @event['facing']
        @blockLocation = @event['location']

        if(@face == 'up'){
            @blockLocation[1] = @blockLocation[1] + 1
            @arrLoc = array(@blockLocation[0],@blockLocation[1],@blockLocation[2],@blockLocation[3])
            if(get_block(@arrLoc == 'AIR'){
                set_block(@arrLoc,'AIR')
                set_timeout(50,closure(
                    set_block(@arrLoc,'minecraft:redstone_wall_torch')
                ))
                @wasPlaced = true
            }
        }else if(@face == 'north'){
            @blockLocation[2] = @blockLocation[2] - 1
            @arrLoc = array(@blockLocation[0],@blockLocation[1],@blockLocation[2],@blockLocation[3])
            if(get_block(@arrLoc == 'AIR'){
                set_block(@arrLoc,'AIR')
                set_timeout(50,closure(    
                    set_block(@arrLoc,'minecraft:redstone_wall_torch[facing=north]')
                ))
                @wasPlaced = true
            }
        }else if(@face == 'east'){
            @blockLocation[0] = @blockLocation[0] + 1
            @arrLoc = array(@blockLocation[0],@blockLocation[1],@blockLocation[2],@blockLocation[3])
            if(get_block(@arrLoc == 'AIR'){
                set_block(@arrLoc,'AIR')
                set_timeout(50,closure(    
                    set_block(@arrLoc,'minecraft:redstone_wall_torch[facing=east]')
                ))
                @wasPlaced = true
            }
        }else if(@face == 'west'){
            @blockLocation[0] = @blockLocation[0] - 1
            @arrLoc = array(@blockLocation[0],@blockLocation[1],@blockLocation[2],@blockLocation[3])
            if(get_block(@arrLoc == 'AIR'){
                set_block(@arrLoc,'AIR')
                set_timeout(50,closure(    
                    set_block(@arrLoc,'minecraft:redstone_wall_torch[facing=west]')
                ))
                @wasPlaced = true
            }
        }else if(@face == 'south'){
            @blockLocation[2] = @blockLocation[2] + 1
            @arrLoc = array(@blockLocation[0],@blockLocation[1],@blockLocation[2],@blockLocation[3])
            if(get_block(@arrLoc == 'AIR'){
                set_block(@arrLoc,'AIR')
                set_timeout(50,closure(    
                    set_block(@arrLoc,'minecraft:redstone_wall_torch[facing=south]')
                ))
                @wasPlaced = true
            }
        }else{
            return()
        }

        if(@wasPlaced){
            set_timeout(5000,closure(
                @arrLoc = array(@blockLocation[0],@blockLocation[1],@blockLocation[2],@blockLocation[4])
                set_block(@arrLoc,'AIR')
            ))
            cancel()
        }
    ,
    )
}
