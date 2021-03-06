g_Players = NULL;
 
function OnResourceStart()
    g_Players = {};
   
    for x, pPlayer in ipairs( getElementsByType( "player" ) ) do
        g_Players[ x ] = pPlayer;
       
        setElementData( pPlayer, "ID", x );
    end
end
addEventHandler ( "onResourceStart", getRootElement(), OnResourceStart )
function OnPlayerQuit()
    g_Players[ getElementData( source, "ID" ) or 0 ] = NULL;
end

addEventHandler ( "onPlayerQuit", getRootElement(), OnPlayerQuit )

function OnPlayerJoin()
    exports.scoreboard:scoreboardAddColumn( "kd", root, 75, "Kills/Death", 2 )
    exports.scoreboard:scoreboardAddColumn( "ID", root, 35, "ID", 1 )

	local iID = 0;
    for x in ipairs( g_Players ) do
        iID = x;
    end
    iID = iID + 1;
    g_Players[ iID ] = source;
    setElementData( source, "ID", iID );
    --outputChatBox (getElementData(source, "ID"))
end
addEventHandler("onPlayerJoin", getRootElement(), OnPlayerJoin)

addEventHandler ( "onPlayerWasted", root,
	function ( ammo, killer, killerWeap )
		if killer and getElementType(killer) == "player" and getElementType(source) == "player" then
			takePlayerMoney ( source, 50 )
			givePlayerMoney ( killer, 50 )
			setTimer( spawnPlayer, 4000, 1, source, g_Positions[iRandom][1], g_Positions[iRandom][2], g_Positions[iRandom][3] )
		else
            setTimer( spawnPlayer, 4000, 1, source, g_Positions[iRandom][1], g_Positions[iRandom][2], g_Positions[iRandom][3] )
        end
    end
)

addEventHandler ( "onPlayerWasted", root,
    function ( ammo, killer, killerWeap )
        if killer and getElementType(killer) == "player" and getElementType(source) == "player" then
            -- source death
            acc = getPlayerAccount ( source )
            setAccountData ( acc, "ClassicDM.Death", tostring ( tonumber (getAccountData (acc, "ClassicDM.Death") +1 ) ) )
            local kdArray = { getAccountData(acc, "ClassicDM.Kills"), getAccountData(acc, "ClassicDM.Death") }
            setElementData ( source, "kd", kdArray[1] .."/".. kdArray[2] )
            -- killer death
            accKiller = getPlayerAccount ( killer )
            setAccountData ( accKiller, "ClassicDM.Kills", tostring ( tonumber (getAccountData (accKiller, "ClassicDM.Kills") +1 ) ) )
            local kdArrayKiller = { getAccountData(accKiller, "ClassicDM.Kills"), getAccountData(accKiller, "ClassicDM.Death") }
            setElementData ( killer, "kd", kdArrayKiller[1] .."/".. kdArrayKiller[2] )
        else
            acc = getPlayerAccount ( source )
            setAccountData ( acc, "ClassicDM.Death", tostring ( tonumber (getAccountData (acc, "ClassicDM.Death") +1 ) ) )
            local kdArray = { getAccountData(acc, "ClassicDM.Kills"),getAccountData(acc, "ClassicDM.Death") }
            setElementData ( source, "kd", kdArray[1] .."/".. kdArray[2] )
        end
    end
)