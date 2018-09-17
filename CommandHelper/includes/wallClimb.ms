proc('_spidermanVinePlacement', @ploc, @block, @player,
    
    include('/home/minecraft/server/plugins/CommandHelper/includes/facingDirection.ms')
    @facing = _facingDirection(@ploc)
    
    assign(@pointer, @ploc[])
    assign(@wallCheck, @ploc[])
    @blocksToChange = array()
    @counter = 0
    @rowStart = @ploc['y']
    @rowMax = @ploc['y'] + 3
        
    if(@facing == "north"){
        #LR = -x/x
        
        @colStart = @ploc['x'] - 1
        @colMax = @ploc['x'] + 1
        
        for(@row = @rowStart, @row <= @rowMax, @row++){
            @pointer['y'] = @row
            for(@col = @colStart, @col <= @colMax, @col++){
                @pointer['x'] = @col
                assign(@wallCheck, @pointer[])
                @wallCheck['z'] = @wallCheck['z'] - 1
                if(get_block_at(@pointer) == "AIR" && get_block_at(@wallCheck) != "AIR"){
                    array_push(@blocksToChange,array_get(@pointer))
                }

                if(@counter > 11)
                {
                    die()
                }
                @counter++
            }
        }
        
        foreach(@val in @blocksToChange){
            psend_block_change(@val,"minecraft:vine[north=true]")
        }
        
        return(array_get(@blocksToChange))
    }else if(@facing == "east"){
        #LR = -z/z
        
        @colStart = @ploc['z'] - 1
        @colMax = @ploc['z'] + 1
        
        for(@row = @rowStart, @row <= @rowMax, @row++){
            @pointer['y'] = @row
            for(@col = @colStart, @col <= @colMax, @col++){
                @pointer['z'] = @col
                assign(@wallCheck, @pointer[])
                @wallCheck['x'] = @wallCheck['x'] + 1
                if(get_block_at(@pointer) == "AIR" && get_block_at(@wallCheck) != "AIR"){
                    array_push(@blocksToChange,array_get(@pointer))
                }

                if(@counter > 11)
                {
                    die()
                }
                @counter++
            }
        }
        
        foreach(@val in @blocksToChange){
            psend_block_change(@val,"minecraft:vine[east=true]")
        }
        
        return(array_get(@blocksToChange))
    }else if(@facing == "south"){
        #LR = x/-x
        @colStart = @ploc['x'] + 1
        @colMax = @ploc['x'] - 1
        
        for(@row = @rowStart, @row <= @rowMax, @row++){
            @pointer['y'] = @row
            for(@col = @colStart, @col >= @colMax, @col--){
                @pointer['x'] = @col
                assign(@wallCheck, @pointer[])
                @wallCheck['z'] = @wallCheck['z'] + 1
                if(get_block_at(@pointer) == "AIR" && get_block_at(@wallCheck) != "AIR"){
                    array_push(@blocksToChange,array_get(@pointer))
                }

                if(@counter > 11)
                {
                    die()
                }
                @counter++
            }
        }
        
        foreach(@val in @blocksToChange){
            psend_block_change(@val,"minecraft:vine[south=true]")
        }
        
        return(array_get(@blocksToChange))
    }else{
        #LR = z/-z
        @colStart = @ploc['z'] + 1
        @colMax = @ploc['z'] - 1
        
        for(@row = @rowStart, @row <= @rowMax, @row++){
            @pointer['y'] = @row
            for(@col = @colStart, @col >= @colMax, @col--){
                @pointer['z'] = @col
                assign(@wallCheck, @pointer[])
                @wallCheck['x'] = @wallCheck['x'] - 1
                if(get_block_at(@pointer) == "AIR" && get_block_at(@wallCheck) != "AIR"){
                    array_push(@blocksToChange,array_get(@pointer))
                }

                if(@counter > 11)
                {
                    die()
                }
                @counter++
            }
        }
        
        foreach(@val in @blocksToChange){
            psend_block_change(@val,"minecraft:vine[west=true]")
        }
        
        return(array_get(@blocksToChange))
    }
    
)