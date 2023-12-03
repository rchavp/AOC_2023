import strutils
import sequtils


type NumCoord = tuple[num: int, coord: tuple[s: int, e: int]]
type LineData = tuple[numCoords: seq[NumCoord], symCoords: seq[NumCoord]]


proc getNumCoords( line: string ): seq[NumCoord] =
    var res: seq[NumCoord] = @[]
    var p = 0
    var q = 0
    var foundOne = false
    while p < line.len():
        foundOne = false
        q = p
        while q < line.len() and line[q].isDigit():
            foundOne = true
            q += 1
        if foundOne:
            # echo( "FOUND ONE: ", line[p..<q] )
            res.add( ( line[p..<q].parseInt(), ( p, q-1 ) ) )
            p = q
        else:
            p += 1
    res

proc getSymbolCoords( line: string ): seq[NumCoord] =
    var res: seq[NumCoord] = @[]
    var p = 0
    var val = 0
    while p < line.len():
        if not ( line[p].isDigit() ) and not ( line[p] == '.' ):
            val = if line[p] == '*': -42 else: -1
            res.add( ( val, ( p, p ) ) )
        p += 1
    res

proc main() =
    # let s = "....%..863..#......................36.............956..337%......692..............*744....$..........*......../.....187..-.................."
    # let r = getSymbolCoords( s )
    # echo( r )
    # return
    let data = readFile( "./input03.txt" )
    let lines = data.split( '\n' )

    # let numCoords = lines.mapIt( getNumCoords( it ) )
    # for e in numCoords.items:
        # echo( "nums->", e )
    
    let lineData = lines.mapIt( ( getNumCoords( it ), getSymbolCoords( it ) ) )
    for e in lineData.items:
        echo( "lineData->", e )
    

    var prevLine: LineData
    var nextLine: LineData
    var res: seq[int] = @[]
    for i, v in lineData.pairs:
        let ( numCoords, symCoords ) = v
        for nc in numCoords.items:
            if true:
                for sym in symCoords.items:
                    if sym.coord.s >= nc.coord.s - 1 and sym.coord.s <= nc.coord.e + 1:
                        res.add( nc.num )
                        continue
            if i > 0:
                prevLine = lineData[i-1]
                for sym in prevLine.symCoords.items:
                    if sym.coord.s >= nc.coord.s - 1 and sym.coord.s <= nc.coord.e + 1:
                        res.add( nc.num )
                        continue
            if i < lineData.len() - 1:
                nextLine = lineData[i+1]
                for sym in nextLine.symCoords.items:
                    if sym.coord.s >= nc.coord.s - 1 and sym.coord.s <= nc.coord.e + 1:
                        res.add( nc.num )
                        continue
    
    # for e in res.items:
        # echo( "num->", e )
            
    let result_1 = res.foldl( a + b, 0 )
    echo( "Result_1->", result_1 )
    
    var powerPairs: seq[tuple[a: int, b: int]] = @[]
    var hits = [-1, -1]
    for i, v in lineData.pairs:
        let ( numCoords, symCoords ) = v
        for sym in symCoords.items:
            if sym.num == -42:
                var numHits = 0
                for nc in numCoords.items:
                    if sym.coord.s == nc.coord.s - 1 or sym.coord.s == nc.coord.e + 1:
                        if numHits < 2: hits[numHits] = nc.num
                        numHits += 1
                if i > 0:
                    prevLine = lineData[i-1]
                    for nc in prevLine.numCoords.items:
                        if sym.coord.s >= nc.coord.s - 1 and sym.coord.s <= nc.coord.e + 1:
                            if numHits < 2: hits[numHits] = nc.num
                            numHits += 1
                if i < lineData.len() - 1:
                    nextLine = lineData[i+1]
                    for nc in nextLine.numCoords.items:
                        if sym.coord.s >= nc.coord.s - 1 and sym.coord.s <= nc.coord.e + 1:
                            if numHits < 2: hits[numHits] = nc.num
                            numHits += 1
                if numHits == 2:
                    powerPairs.add( ( hits[0], hits[1] ) )

    for e in powerPairs.items:
        echo( "Power->", e )

    let result_2 = powerPairs.mapIt( it.a * it.b ).foldl( a + b, 0 )
    echo( "Result_2->", result_2 )





main()
