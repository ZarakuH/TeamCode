register_command('chars', 
    array(
        'description': 'Lists the Super Heroes available on the Server',
        'usage': '/chars [page number]',
        'permission': 'ch.alias.listheroes',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) > 1) {
                return(false)
            } else if (array_size(@args) == 1) {
                @pageNum = @args[0]
            } else {
                @pageNum = null
            }

            if(@pageNum < 1 && @pageNum != null){
                msg(color('RED').color('BOLD').'Sorry, the page number must be at least 1.');
                die()
            }

            @fString = shell('/home/minecraft/getHeroesAlphabetically.sh')
            @fString = trimr(@fString)
            @files = split('\n',@fString)
            if(@pageNum == null){
                for(@i = 0, @i < 10, @i++){
                    try{
                        @class = substr(@files[@i],0,string_position(@files[@i],'.'))
                        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                        @hero = yml_decode(@contents)
                        @extraNames = ''
                        @heroName = @hero['costumes'][0]['name']
                        if(array_size(@hero['costumes']) > 1){
                            @numper = 0
                            foreach(@cost in @hero['costumes']){
                                if(@numper == 0){
                                    @numper++
                                    continue()
                                }
                                if(array_index_exists(@cost,'name')){
                                    @extraNames = @extraNames.color('GREEN').'/'.@cost['name']
                                }
                            }
                        }
                    
                        runas('~console','/tellraw '.@sender.' {"text":"'.@heroName.@extraNames.'","color":"gold","clickEvent":{"action":"run_command","value":"/selectchar '.@hero['class'].'"},"hoverEvent":{"action":"show_text","value":"'.@hero['class'].'"}}')
                    }catch(Exception @e){
                        break()
                    }
                }
                msg(color('RED').'For more characters check out '.color('GREEN').color('BOLD').'/chars 2')
                msg(color('RED').'Click a character to select it.')
            }else{
                @start = @pageNum * 10 - 9
                for(@i = @start, @i < @start+10, @i++){
                    try{
                        @class = substr(@files[@i],0,string_position(@files[@i],'.'))
                        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                        @hero = yml_decode(@contents)
                        @extraNames = ''
                        @heroName = @hero['costumes'][0]['name']
                        if(array_size(@hero['costumes']) > 1){
                            @numper = 0
                            foreach(@cost in @hero['costumes']){
                                if(@numper == 0){
                                    @numper++
                                    continue()
                                }
                                if(array_index_exists(@cost,'name')){
                                    @extraNames = @extraNames.color('GREEN').'/'.@cost['name']
                                }
                            }
                        }
                        runas('~console','/tellraw '.@sender.' {"text":"'.@heroName.@extraNames.'","color":"gold","clickEvent":{"action":"run_command","value":"/selectchar '.@hero['class'].'"},"hoverEvent":{"action":"show_text","value":"'.@hero['class'].'"}}')
                    }catch(Exception @e){
                        break()
                    }
                }
                msg(color('RED').'For more characters check out '.color('GREEN').color('BOLD').'/chars '.(@pageNum + 1))
                msg(color('RED').'Click a character to select it.')
            }
        }
    )
)


register_command('characterselect', 
    array(
        'description': 'Searches for a character',
        'usage': '/characterselect <searchTerm>',
        'permission': 'command.characterselect',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',		
        'aliases': array('charsel', 'findchar','csel'),
        'executor': closure(@alias, @sender, @args) {
            @argNum = array_size(@args)
            if (@argNum < 1) {
                msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                msg(color('RED').'Please search for a character.')
                msg('Example:'.color('GREEN').' /findchar wonder woman')
                msg('Example:'.color('GREEN').' /findchar Captain America')
                msg('Example:'.color('GREEN').' /findchar greenlantern')
                msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                return(false)
            }
 
            @searchTerm = ''
            foreach(@arg in @args){
                @searchTerm = @searchTerm.'*'.@arg
            }
            @searchTerm = '*'.@searchTerm.'*'
            @heroes = array()

            @var = shell('/home/minecraft/searchHero.sh '.to_lower(@searchTerm))
            @heroes = split('\n',@var)
            msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
            @foundAHero = false
            foreach(@her in @heroes){

                try{
                    @her = trim(@her)
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@her.'.yml')
                    @hero = yml_decode(@contents)
                    @foundAHero = true
                    @extraNames = ''
                    @heroName = @hero['costumes'][0]['name']
                    if(array_size(@hero['costumes']) > 1){
                        @i = 0
                        foreach(@cost in @hero['costumes']){
                            if(@i == 0){
                                @i++
                                continue()
                            }
                            if(array_index_exists(@cost,'name')){
                                @extraNames = @extraNames.color('GREEN').'/'.@cost['name']
                            }
                        }
                    }
                    
                    queue_push(closure(runas('~console','/tellraw '.@sender.' {"text":"'.@heroName.@extraNames.'","color":"gold","clickEvent":{"action":"run_command","value":"/selectchar '.@her.'"},"hoverEvent":{"action":"show_text","value":"'.@her.'"}}')))
                    
                }catch(IOException @e){
                    continue()
                }
            }
            queue_push(closure(
            if(@foundAHero){
                msg(color('RED').'Click a character to select it.')
            }else{
                msg(color('RED').'Sorry, we don\'t have that character yet :(')
                msg(color('RED').'You can add it to the server by watching the following videos:')
                msg(color('RED').'Please note, only the 1st 3 videos are required, the rest are optional.')
                msg(color('GREEN').'http://mynecraft.servegame.com/howtomakeahero.html')
            }
            msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
            ))
       }
    )
)


register_command('selectchar', 
    array(
        'description': 'Selects a character',
        'usage': '/selectchar <character>',
        'permission': 'command.selectchar',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',		
        'executor': closure(@alias, @sender, @args) {
                @argNum = array_size(@args)
                if (@argNum != 1) {
                    msg(color('RED').'Error: Incorrect parameters. Try: /selectchar superman')
                    return(false)
                }

                @player = @sender
                @class = @args[0]
                
                @confirmed = import(@player."charConfirmed")
                if(@confirmed != @class){
                    export(@player."charConfirmed",@class)
                    msg(@class.color('RED').' selected! Please click again to confirm your choice.')
                    die()
                }
                @forgottenHeroes = import('forgottenHeroes')
                if(@forgottenHeroes != null){
                    if(is_array(@forgottenHeroes)){
                        foreach(@fhero in @forgottenHeroes){
                            if(@fhero == @class){
                                msg(color('RED').'Sorry, that hero is currently locked. Please check back later.')
                                die()
                            }
                        }
                    }else{
                        if(@forgottenHeroes == @class){
                            msg(color('RED').'Sorry, that hero is currently locked. Please check back later.')
                            die()
                        }
                    }
                }

                if(@class == 'fanfic'){
                    @uuid = puuid(@player,true)
                    queue_push(closure(runas('~console','/lp deletegroup '.@class.@uuid)))
                    queue_push(closure(runas('~console','/lp creategroup '.@class.@uuid)))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' parent set commonherotraits')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' parent add superherocity')))
                    queue_push(closure(runas('~console','/lp user '.@player.' parent set '.@class.@uuid)))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.run0 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.run1 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.run2 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.haste0 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.haste1 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.haste2 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.jump0 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.jump1 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.jump2 true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.fanficlaser true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.fanficname true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set ch.alias.fanficchatcolor true')))
                    queue_push(closure(runas('~console','/lp group '.@class.@uuid.' permission set is.fanfic true')))
                    broadcast(color('GRAY').color('ITALIC').'A shitty fanfic has entered the game!')
                    queue_push(closure(runas('~console',"/fly ".@player." off")))
                    queue_push(closure(runas('~console',"/gamemode survival ".@player)))
                    queue_push(closure(runas('~console',"/minecraft:effect clear ".@player)))
                    queue_push(closure(runas('~console',"/minecraft:clear" @player)))
                    queue_push(closure(runas('~console',"/god ".@player." off")))
                    queue_push(closure(runas('~console',"/tptoggle ".@player." on")))
                    queue_push(closure(sudo('/stageselect')))
                    die()
                }

                include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/' . @class . '.yml')
                @hero = yml_decode(@contents)
                @plrs = all_players()
                @multipleAllowed = false
                @multipleInUse = false
                if(array_index_exists(@hero,'allowMultiple') && @hero['allowMultiple'] == true){
                    @multipleAllowed = true
                }
                
                
                foreach(@playa in @plrs){
                    @otherPlayerGroup = _getheroclass(@playa)
                    if(@otherPlayerGroup == @hero['class'] && @player != @playa){
                        if(!@multipleAllowed){
                            msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                            msg(color('RED').'Sorry, '.color('WHITE').@playa.color('RED').' is already using '.@hero['costumes'][0]['name'].color('RED').'.')
                            msg(color('DARK_RED').'Please choose a different character.')
                            msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                            die()
                        }else{
                            @multipleInUse = true
                            break()
                        }
                    }
                    if(array_index_exists(@hero,'transformations')){
                        @alts = @hero['transformations']
                        foreach(@alt in @alts){
                            if(@alt == @otherPlayerGroup){
                                @h1 = @hero['costumes'][0]['name']
                                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/' . @class . '.yml')
                                @hero = yml_decode(@contents)
                                @h2 = @hero['costumes'][0]['name']
                                msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                                msg(color('RED').'Sorry, '.color('WHITE').@playa.color('RED').' is already using '.@h2.color('RED').'.')
                                msg(color('RED').'Try again with:')
                                msg(color('GREEN').'/characterselect')
                                msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                                die()
                            }
                        } 
                    }
                }

                if(!@multipleInUse){
                    queue_push(closure(runas('~console','/lp deletegroup '.@hero['class'])))
                    queue_push(closure(runas('~console','/lp creategroup '.@hero['class'])))
                }

                queue_push(closure(runas('~console','/minecraft:clear '.@player)))
                //queue_push(closure(set_peffect(@player, 14, 1, 9999, true, false)))
                queue_push(closure(runas('~console','/lp group '.@hero['class'].' parent set commonherotraits')))
                queue_push(closure(runas('~console','/lp group '.@hero['class'].' parent add superherocity')))
                queue_push(closure(runas('~console','/lp group '.@hero['class'].' meta addsuffix 6 '.@hero['costumes'][0]['chatcolor'])))
                @niceName = replace(@hero['costumes'][0]['name'],'§','&')
                queue_push(closure(runas('~console','/lp group '.@hero['class'].' meta addprefix 6 "'.@niceName.'"')))
                queue_push(closure(runas('~console','/lp user '.@player.' parent set '.@hero['class'])))
                if(array_index_exists(@hero,'permissions') && is_array(@hero['permissions'])){
                    foreach(@worldName: @worldPerms in @hero['permissions']){
                        foreach(@perm in @worldPerms){
                            queue_push(closure(runas('~console','/lp group '.@hero['class'].' permission set '.@perm.' true')))
                        }
                    }
                }

                clear_task(import(@player.'isBurningInSunlight'))
                export(@player.'skinNum',1)
                queue_push(closure(runas('~console',"/fly ".@player." off")))
                queue_push(closure(runas('~console',"/gamemode survival ".@player)))
                queue_push(closure(runas('~console',"/minecraft:effect clear ".@player)))
                queue_push(closure(runas('~console',"/god ".@player." off")))
                queue_push(closure(runas('~console',"/tptoggle ".@player." on")))
                
                if(@hero['trail'] != ''){
                    sudo("/trailsid ".@hero['trail'])
                }else{
                    sudo("/trailsid none")
                }
                queue_push(closure(sudo('/stageselect')))
        }
    )
)
