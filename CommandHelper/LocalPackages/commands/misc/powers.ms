register_command('powers', 
    array(
        'description': 'Displays a list of Powers to the Player Associated with their Super Hero',
        'usage': '/powers',
        'permission': 'ch.alias.powers',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @plr, @args) {
        
                //@plr = player()
                @numArgs = array_size(@args)
                if(@numArgs == 0){
                    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                    @class = _getheroclass(@plr)
                }else{
                    @searchTerm = ''
                    foreach(@arg in @args){
                        @searchTerm = @searchTerm.@arg
                    }
                    @class = to_lower(@searchTerm)
                }
                
                try {
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                    @hero = yml_decode(@contents)

                } catch (IOException @ErrorInfo) {
                    # Ignore file doesn't exist message and kill the script
                    tmsg(@plr, 'There\'s no power\'s associated with your current Character Class')
                    die()
                }
                
                if(array_index_exists(@hero,'powers')){
                    msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                    msg(color('GOLD').  '          '.@hero['costumes'][0]['name'].'\'S POWERS                    ')
                    msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                    foreach(@power in @hero['powers']){
                        tmsg(@plr,color('GOLD').@power)
                    }
                    msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')    
                }else{
                    tmsg(@plr, 'There\'s no power\'s associated with your current Character Class')
                    die()
                }
                
        }
    )
)
