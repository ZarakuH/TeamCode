proc('_getheroclass',@playerName,

    @groups = pgroup(@playerName)

    @numOfGroups = array_size(@groups)

    @baseGroup = ''

    foreach(@g in @groups){
        if(
            @g != 'default' && 
            @g != 'superherocity' && 
            @g != 'mortal'  && 
            @g != 'commonherotraits'
        ){
            @baseGroup = @g
            return(@baseGroup)
        }
    }
    return(null)
)
