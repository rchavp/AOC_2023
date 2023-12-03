import strutils
import sequtils
# import sugar


type RGBTokens = seq[tuple[color: int, qty: int]]
type Game = tuple[id: int, tokens: RGBTokens]
type RGBBucket = tuple[r: int, g: int, b: int]
type GameRGBBucket = tuple[id: int, bucket: RGBBucket]
type GamePower = tuple[id: int, power: int]


proc getColorCode( color: string ): int =
    if color == "red":
        1
    elif color == "green":
        2
    elif color == "blue":
        3
    else:
        echo( "ERROR" )
        -1

proc parseGame( line: string ): Game =
    var res: seq[tuple[color: int, qty: int]] = @[]
    let toks1 = line.split( ":" )
    let gameId = toks1[0].split( " " )[1]
    let turns = toks1[1].split( ";" ).mapIt( it.strip() )
    for turn in turns.items:
        let cubes = turn.split( "," ).mapIt( it.strip() )
        for cube in cubes.items:
            let colorAndQty = cube.split( " " ).mapIt( it.strip() )
            res.add( ( getColorCode( colorAndQty[1] ), colorAndQty[0].parseInt() ) )
    ( gameId.parseInt(), res )

proc aggregateRGB( rgbTokens: Game ): GameRGBBucket =
    var aggrRGB: RGBBucket = ( 0, 0, 0 )
    for token in rgbTokens[1]:
        if token[0] == 1: # RED
            aggrRGB[0] = aggrRGB[0] + token[1]
        if token[0] == 2: # GREEN
            aggrRGB[1] = aggrRGB[1] + token[1]
        if token[0] == 3: # BLUE
            aggrRGB[2] = aggrRGB[2] + token[1]
    ( rgbTokens[0], aggrRGB )
    
proc isGamePossible( game: GameRGBBucket ): bool =
    let bucket = game[1]
    if bucket[0] <= 12 and bucket[1] <= 13 and bucket[2] <= 14:
        true
    else:
        false

proc isGamePossible1( game: Game ): bool =
    for token in game.tokens:
        if token.color == 1 and token.qty > 12:
            return false
        if token.color == 2 and token.qty > 13:
            return false
        if token.color == 3 and token.qty > 14:
            return false
    true
    
proc getMinSizeBucket( game: Game ): GameRGBBucket =
    var minSizeBucket: RGBBucket = ( 0,0,0 )
    for token in game.tokens:
        if token.color == 1:
            minSizeBucket.r = if token.qty > minSizeBucket.r: token.qty else: minSizeBucket.r
        if token.color == 2:
            minSizeBucket.g = if token.qty > minSizeBucket.g: token.qty else: minSizeBucket.g
        if token.color == 3:
            minSizeBucket.b = if token.qty > minSizeBucket.b: token.qty else: minSizeBucket.b
    ( game.id, minSizeBucket )
        

proc main() =
    let data = readFile( "./input02.txt" )
    let lines = data.split( '\n' )
    
    let groupedRGBs = lines.mapIt( it.parseGame() )
        
    # for e in groupedRGBs.items:
        # echo( "game->", e )
    
    # let aggrRGBs = groupedRGBs.mapIt( aggregateRGB( it ) )
        
    # for e in aggrRGBs.items:
    #     echo( "game->", e )
    
    let validGames = groupedRGBs.filterIt( isGamePossible1( it ) )

    # for e in validGames.items:
        # echo( "valid game->", e )
        
    let result_1 = validGames.foldl( a + b.id, 0 )
    echo( "Result 1: ", result_1 )
    
    let minSizeBuckets = groupedRGBs.mapIt( getMinSizeBucket( it ) )

    # for e in minSizeBuckets.items:
        # echo( "game min bucket->", e )
        
    let bucketPowers: seq[GamePower] = minSizeBuckets.mapIt( ( it.id, it.bucket.r * it.bucket.g * it.bucket.b ) )
    
    # for e in bucketPowers.items:
        # echo( "Game powers->", e )
    
    let result_2 = bucketPowers.foldl( a + b.power, 0 )
    echo("Result 2: ", result_2)




main()

