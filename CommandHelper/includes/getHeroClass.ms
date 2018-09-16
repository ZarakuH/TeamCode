proc('_getheroclass',@playerName,

    @groups = pgroup(@playerName)

    @numOfGroups = array_size(@groups)

    @baseGroup = @groups[@numOfGroups - 2]

    return(@baseGroup)

)
