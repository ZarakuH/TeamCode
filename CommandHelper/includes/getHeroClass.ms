proc('_getheroclass',@playerName,

    @groups = pgroup(@playerName)

    @numOfGroups = array_size(@groups)

    @baseGroup = @groups[@numOfGroups - 2]

    if(@baseGroup == 'mortal' || @baseGroup == 'default'){
        console('was going to choose '.@baseGroup.' in getheroclass, whoopsie')
        die()
    }

    return(@baseGroup)

)
