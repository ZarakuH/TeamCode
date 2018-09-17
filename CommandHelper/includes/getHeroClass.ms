proc('_getheroclass',@playerName,

    @groups = pgroup(@playerName)

    @numOfGroups = array_size(@groups)

    foreach(@g in @groups){
        if(
            @g != 'default' && 
            @g != 'superherocity' && 
            @g != 'mortal'  && 
            @g != 'commonherotraits'
        ){
            @baseGroup = @g
            break()
        }
    }

    return(@baseGroup)

)
