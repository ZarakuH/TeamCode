bind('entity_damage', null, array('type':'/PLAYER/', 'cause': '/ENTITY_ATTACK|MAGIC|CONTACT|PROJECTILE|LIGHTNINIG|FALLING_BLOCK|CUSTOM|ENTITY_SWEEP_ATTACK/'), @e) {
    if(array_index_exists(@e,'damager') && ponline(@e['damager']) && has_permission(@e['damager'],'is.op')){
        die()
    }
    @num = rand(1, 10)
    if(has_permission(@e['player'], "powers.speedsterdodge") && import(@e['player'].'isDepowered') != true && pmode(@e['player']) == 'SURVIVAL' && @num < 7)
    {
        cancel()
        tmsg(@e['player'], color('RED').'Your Speed allows you to dodge the attack!')
        @ploc = ploc(@e['player'])
        
        for(@i = 0, @i < 10, @i++){
            if(rand(0,2) == 1){
                @xOffset = 1
            }else{
                @xOffset = -1
            }
            
            if(rand(0,2) == 1){
                @zOffset = 1
            }else{
                @zOffset = -1
            }
            @newLoc = array_deep_clone(@ploc)
            @newLoc['x'] = @newLoc['x'] + @xOffset
            @newLoc['z'] = @newLoc['z'] + @zOffset
            @newLoc['y'] = @newLoc['y'] + 1

            if(get_block_at(@newLoc) == '0:0'){
                @newLoc['y'] = @newLoc['y'] + 1
                if(get_block_at(@newLoc) == '0:0' ){
                    @newLoc['y'] = @newLoc['y'] - 2
                    set_ploc(@e['player'],@newLoc)
                    return()
                }
            }
        }
    }
}
