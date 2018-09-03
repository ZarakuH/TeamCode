bind('hanging_break',null,array('type': '/ITEM_FRAME|PAINTING/'),@e){
        cancel()
        if(@e['player'] != null && has_permission(@e['player'],'cancel.entityclicks') == false){
            cancel(false)
        }else if(@e['cause'] == 'PHYSICS'){
            cancel(false)\
        }
}

bind('player_interact_at_entity',null,null,@e){
    cancel()
    if(has_permission(@e['player'],'cancel.entityclicks') == false){
        cancel(false)
    }
    
}

bind('player_interact_entity',null,array('clicked':'ITEM_FRAME'),@e){
    cancel()
    if(has_permission(@e['player'],'cancel.entityclicks') == false){
        cancel(false)
    }
}

bind('entity_damage',null,array('type':'/ARMOR_STAND|ITEM_FRAME|PAINTING|MINECART|CHEST_MINECART|TNT_MINECART|FURNACE_MINECART|HOPPER_MINECART/'),@e){
    cancel()
    @damager = ''

    if(array_index_exists(@e,'damager')){
        @damager = @e['damager']
    }

    if(@damager != ''){
        if(has_permission(@e['damager'],'cancel.entityclicks') == false){
            cancel(false)
            die()
        }
    }

    @loc = entity_loc(@e['id'])
    @id = get_claim_id(@loc)
    if(@id != null){
        @info = get_claim_info(@loc)
        if(@info['owner'] != @damager){
            die()
        }else{
            cancel(false)
        }
    }
}

bind('vehicle_destroy',null,null,@e){
    cancel()
    if(array_index_exists(@e, 'damager') && has_permission(@e['damager'],'cancel.entityclicks') == false){
        cancel(false)
    }
}

bind('block_dispense',null,null,@e){
    if(@e['item'] == null){
        die()
    }
    cancel()

    @itemType = @e['item']['name']
    switch(@itemType){
        case 'DIAMOND_HELMET':
        case 'DIAMOND_CHESTPLATE':
        case 'DIAMOND_LEGGINGS':
        case 'DIAMOND_BOOTS':
        case 'LEATHER_HELMET':
        case 'LEATHER_CHESTPLATE':
        case 'LEATHER_LEGGINGS':
        case 'LEATHER_BOOTS':
        case 'IRON_HELMET':
        case 'IRON_CHESTPLATE':
        case 'IRON_LEGGINGS':
        case 'IRON_BOOTS':
        case 'GOLDEN_HELMET':
        case 'GOLDEN_CHESTPLATE':
        case 'GOLDEN_LEGGINGS':
        case 'GOLDEN_BOOTS':
        case 'CHAINMAIL_HELMET':
        case 'CHAINMAIL_CHESTPLATE':
        case 'CHAINMAIL_LEGGINGS':
        case 'CHAINMAIL_BOOTS':
        case 'ELYTRA':
        case 'SHIELD':
        case 'SKELETON_SKULL':
		case 'WITHER_SKELETON_SKULL':
		case 'ZOMBIE_HEAD':
		case 'PLAYER_HEAD':
		case 'CREEPER_HEAD':
		case 'DRAGON_HEAD':
            die()
    }

    if(
        @e['location']['world'] == 'survival112' || 
        @e['location']['world'] == 'survival112_nether' || 
        @e['location']['world'] == 'survival112_the_end' ||
        @e['location']['world'] == 'tutorial'
    ){
        cancel(false)
    }
}

bind('inventory_drag',null,null,@e){
    if(
		@e['oldcursoritem']['name'] == 'SKELETON_SKULL' || 
		@e['oldcursoritem']['name'] == 'WITHER_SKELETON_SKULL' || 
		@e['oldcursoritem']['name'] == 'ZOMBIE_HEAD' || 
		@e['oldcursoritem']['name'] == 'PLAYER_HEAD' || 
		@e['oldcursoritem']['name'] == 'CREEPER_HEAD' || 
		@e['oldcursoritem']['name'] == 'DRAGON_HEAD'
	){
        foreach(@slot in @e['slots']){
            console(@slot)
            if(@slot == 39){
                cancel()
                return()
            }
        }
    }
}

bind('inventory_click',null,null,@e){
    if(@e['slotitem'] != null){
        if(@e['shiftclick'] == true){
            if(
				@e['slotitem']['name'] == 'SKELETON_SKULL' || 
				@e['slotitem']['name'] == 'WITHER_SKELETON_SKULL' || 
				@e['slotitem']['name'] == 'ZOMBIE_HEAD' || 
				@e['slotitem']['name'] == 'PLAYER_HEAD' || 
				@e['slotitem']['name'] == 'CREEPER_HEAD' || 
				@e['slotitem']['name'] == 'DRAGON_HEAD'
			){
                cancel()
                return()
            }
        }
        if(array_index_exists(@e['slotitem'],'enchants')){
            foreach(@enchant in @e['slotitem']['enchants']){
                if(@enchant['etype'] == 'FROST_WALKER'){
                    modify_event('slotitem',null)
                    tmsg(@e['player'], color('RED').'Sorry, frost walker is not allowed, that item has been removed.')
                }
            }
        }else{
            //if(array_index_exists(@e,'cursoritem')){}
			if(@e['cursoritem'] != null){
                if(array_index_exists(@e,'slottype')){
					console(@e)
                    if(
						@e['cursoritem']['name'] == 'SKELETON_SKULL' ||
						@e['cursoritem']['name'] == 'WITHER_SKELETON_SKULL' ||
						@e['cursoritem']['name'] == 'ZOMBIE_HEAD' ||
						@e['cursoritem']['name'] == 'PLAYER_HEAD' ||
						@e['cursoritem']['name'] == 'CREEPER_HEAD' ||
						@e['cursoritem']['name'] == 'DRAGON_HEAD'
					){
						if(@e['slottype'] == 'ARMOR'){
							cancel()
						}
                    }
                }
            }
        }
    }else{
        if(@e['slot'] == 39){
			if(
				@e['cursoritem']['name'] == 'SKELETON_SKULL' ||
				@e['cursoritem']['name'] == 'WITHER_SKELETON_SKULL' ||
				@e['cursoritem']['name'] == 'ZOMBIE_HEAD' ||
				@e['cursoritem']['name'] == 'PLAYER_HEAD' ||
				@e['cursoritem']['name'] == 'CREEPER_HEAD' ||
				@e['cursoritem']['name'] == 'DRAGON_HEAD'
			){
				cancel()
				return()
			}
        }
    }
}

bind('player_interact', null, array('button': 'right'), @e){
    if(@e['action'] == 'right_click_air'){
        @meta = get_itemmeta(@e['player'], null)
        if(@meta != null && is_array(@meta['enchants'])){
            @item = pinv(@e['player'],null)
			
            if(
				@item['name'] == 'SKELETON_SKULL' ||
				@item['name'] == 'WITHER_SKELETON_SKULL' ||
				@item['name'] == 'ZOMBIE_HEAD' ||
				@item['name'] == 'PLAYER_HEAD' ||
				@item['name'] == 'CREEPER_HEAD' ||
				@item['name'] == 'DRAGON_HEAD'
			){
                cancel()
            }
            if(@item['name'] == 'LEATHER_BOOTS' || @item['name'] == 'CHAINMAIL_BOOTS' || @item['name'] == 'IRON_BOOTS' || @item['name'] == 'DIAMOND_BOOTS' || @item['name'] == 'GOLDEN_BOOTS'){
                foreach(@enchant in @meta['enchants']){
                    if(@enchant['etype'] == 'FROST_WALKER'){
                        @enchant['elevel'] = 0
                    }
                }
                set_itemmeta(@e['player'], null, @meta)
            }
        }
    }
}
