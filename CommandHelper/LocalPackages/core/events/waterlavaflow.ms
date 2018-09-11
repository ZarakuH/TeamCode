bind('block_from_to',null,null,@event){
    cancel()
    switch(@event['location']['world']){
        case 'survival':
        case 'infiniteparkour':
        case 'waynemanor':
        case 'survival_nether':
        case 'survival_the_end':
            cancel(false)
    }
}
