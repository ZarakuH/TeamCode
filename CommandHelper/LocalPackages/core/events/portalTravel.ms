/*bind('player_portal_travel', null, null, @e) {

    @to = @e['to']    

        
    set_timeout(5000,closure(
        @ploc = ploc()
        
        if(get_block(@ploc) == "49:0"){

            set_block(@ploc, "AIR")

            set_timeout(10000,closure(
                set_block(@ploc, "49:0")
                
                set_timeout(1000,closure(
                    @ploc['y'] = @ploc['y'] + 1
                    set_block(@ploc, "51:0")
                ))
            ))
        }

    ))

}
*/