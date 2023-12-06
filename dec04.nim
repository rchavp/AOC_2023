import strutils
import sequtils


const
    # S1 = 5 #10
    # S2 = 8 #25
    # B2 = 26 #41
    S1 = 10
    S2 = 25
    B2 = 41


type Card = tuple[num: int, win: array[S1, int], hand: array[S2, int]]


proc parseCard( line: string ): Card =
    # echo( "5..7->", line[5..7] )
    let num = line[5..7].strip().parseInt()
    var win: array[S1, int]
    var hand: array[S2, int]
    for i in 0..( S1-1 ):
        win[i] = line[( 9 + i*3 )..( 9 + i*3 + 2 )].strip().parseInt()
    for i in 0..( S2-1 ):
        hand[i] = line[( B2 + i*3 )..( B2 + i*3 + 2 )].strip().parseInt()
    ( num, win, hand )


proc getPointsFromCopies( cardPoints: seq[int], cardIdx: int ): int =
    let numCopiesForThis = cardPoints[cardIdx]
    
    var numFurtherCopies = 0
    var copyNum = 1
    while cardIdx + copyNum < cardPoints.len() and copyNum < numCopiesForThis:
        numFurtherCopies += getPointsFromCopies( cardPoints, cardIdx + copyNum )
        copyNum += 1
        
    echo( "CardIdx( ", cardIdx, " ) total is: ", 1 + numFurtherCopies )
    1 + numFurtherCopies


proc main() =
    # let data = readFile( "./tmp.txt" )
    let data = readFile( "./input04.txt" )
    let lines = data.split( '\n' )
    
    let cards = lines.mapIt( parseCard( it ) )
    
    for e in cards.items:
        echo( "Card->", e )
        
    var res: seq[int] = @[]
    for card in cards.items:
        let points = card.hand.foldl( if card.win.contains( b ): ( if a > 0: 2 * a else: 1 ) else: a, 0 )
        if points > 0:
            res.add( points )

    for e in res.items:
        echo( "res->", e )

    let result_1 = res.foldl( a + b, 0 )
    echo( "Result_1->", result_1 )

    var cardData: seq[tuple[cardNum: int, points: int, count: int]] = @[]
    for idx, card in cards.pairs:
        let points = card.hand.foldl( if card.win.contains( b ): a + 1 else: a, 0 )
        cardData.add( ( idx, points, 1 ) )

    for i, e in cardData.pairs:
        echo( "cardData( ", i, " )->", e )
        
    for card in cardData.items:
        for copyNum in 1..card.count:
            for pointNum in 1..card.points:
                if card.cardNum + pointNum < cardData.len():
                    cardData[card.cardNum + pointNum].count += 1

    echo( "" )
    for i, e in cardData.pairs:
        echo( "cardData( ", i, " )->", e )
        
    let result_2 = cardData.foldl( a + b.count, 0 )
    echo( "Result_2->", result_2 )



main()

