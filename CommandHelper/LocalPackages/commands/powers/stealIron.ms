register_command('stealiron', 
    array(
        'description': 'Eat the world',
        'permission': 'powers.stealiron',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            @vics = players_in_radius(ploc(@sender),100)

            foreach(@vic in @vics){
                if(@vic != @sender){
                    @inv = pinv(@vic)
                    foreach(@slot: @item in @inv){
                        if(@item != null){
                            switch(@item['name']){
                                case 'minecraft:iron_horse_armor':
                                case 'minecraft:iron_helmet':
                                case 'minecraft:iron_chestplate':
                                case 'minecraft:iron_leggings':
                                case 'minecraft:iron_boots':
                                case 'minecraft:iron_ore':
                                case 'minecraft:iron_block':
                                case 'minecraft:iron_bars':
                                case 'minecraft:iron_trapdoor':
                                case 'minecraft:iron_shovel':
                                case 'minecraft:iron_pickaxe':
                                case 'minecraft:iron_axe':
                                case 'minecraft:iron_ingot':
                                case 'minecraft:iron_sword':
                                case 'minecraft:iron_hoe':
                                case 'minecraft:iron_door':
                                case 'minecraft:iron_nugget':
                                    ptake_item(@vic,@item)
                                    pgive_item(@sender,@item)
                                    switch(@slot){
                                        case '100':
                                        case '101':
                                        case '102':
                                        case '103':
                                            @inv[@slot] = null
                                            set_pinv(@plr,@inv)
                                    }
                            }
                        }
                    }
                    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                    @class = _getheroclass(@sender)
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                    @hero = yml_decode(@contents)
                    
                    tmsg(@vic,@hero['costumes'][0]['name'].color('RED').' stole the iron from your inventory!')
                }
            }
        }
    )
)
