import strutils
import sequtils
# import sugar

# func str2Num( chunk: string ): int =
#     case chunk:
#         of "one":
#             1
#         of "two":
#             2
#         of "three":
#             3
#         of "four":
#             4
#         of "five":
#             5
#         of "six":
#             6
#         of "seven":
#             7
#         of "eight":
#             8
#         of "nine":
#             9
#         of "zero":
#             0
#         else:
#             -1


# func getFirstNum( line: string ): tuple[num: int, pos: int] =
#     var p = 0
#     while p < line.len() - 1:
#         if line[p].isDigit():
#             return ( ( ""&line[p] ).parseInt(), p )
#         let tmp = line[0..p]
#         let num = str2Num( tmp )
#         if num > -1:
#             return ( num, p )
#         inc p

# func getAllNums( line: string ): seq[int] =
#     let len = line.len()
#     var tmp: string
#     var p = 0
#     var res: seq[int] = @[]
#     while p < len:
#         tmp = line[p..^len]
#         let ( num, pos ) = getFirstNum( tmp )
#         res.add( num )
#         p = pos + 1
#         break
#     return res

proc replaceWordsWithNums( line: string ): string =
    line.replace( "one", "1" )
        .replace( "two", "2" )
        .replace( "three", "3" )
        .replace( "four", "4" )
        .replace( "five", "5" )
        .replace( "six", "6" )
        .replace( "seven", "7" )
        .replace( "eight", "8" )
        .replace( "nine", "9" )
        .replace( "zero", "0" )
        
proc getAllNumsInOrder( line: string ): seq[string] =
    var res: seq[string] = @[]
    var p = 0
    var tmp = ""
    while p < line.len():
        tmp = line[p..^1]
        # echo( "tmp->", tmp, " / len->", tmp.len() )
        if tmp[0].isDigit():
            res.add( ""&tmp[0] )
        elif tmp.len() > 2 and tmp[0..2] == "one":
            res.add( "1" )
        elif tmp.len() > 2 and tmp[0..2] == "two":
            res.add( "2" )
        elif tmp.len() > 4 and tmp[0..4] == "three":
            res.add( "3" )
        elif tmp.len() > 3 and tmp[0..3] == "four":
            res.add( "4" )
        elif tmp.len() > 3 and tmp[0..3] == "five":
            res.add( "5" )
        elif tmp.len() > 2 and tmp[0..2] == "six":
            res.add( "6" )
        elif tmp.len() > 4 and tmp[0..4] == "seven":
            res.add( "7" )
        elif tmp.len() > 4 and tmp[0..4] == "eight":
            res.add( "8" )
        elif tmp.len() > 3 and tmp[0..3] == "nine":
            res.add( "9" )
        # elif tmp.len() > 3 and tmp[0..3] == "zero":
        #     res.add( "0" )
        #     p += 4
        # else:
            # echo( "got nothing..." )
        # echo( "res[]->", res )
        p += 1
    res
        


proc main() =
    # let s = "1234567890"
    # let n2 = s[n..n+2]
    # echo( n2 )
    # echo( n2 == "345" )
    # return
    # let tt = "2fiveshtds4oneightsjg"
    # let t2 = getAllNumsInOrder( tt )
    # echo( t2 )
    # return
    # let line = "1two5four9xx"
    # let tt = line.find( "four" )
    # echo( "pos: ", tt )
    # return
    let data = readFile( "./input01.txt" )
    let lines = data.split( '\n' )
    
    let nums = lines.mapIt( it.foldl( if b.isDigit(): a & b else: a, "" ) )
    let numsFL = nums.mapIt( it[it.low] & it[it.high] ).mapIt( it.parseInt() )
    
    # for r in numsFL.items:
        # echo( r )
        
    let result = numsFL.foldl( a + b, 0 )
    echo( "Result1: ", result )

    # Part 2
    let nums2 = lines.mapIt( getAllNumsInOrder( it ) )
        .mapIt( it[it.low] & it[it.high] )
        .mapIt( it.parseInt() )
    echo( nums2 )

    let lines2 = lines.mapIt( replaceWordsWithNums( it ) )
    let nums22 = lines2.mapIt( it.foldl( if b.isDigit(): a & b else: a, "" ) )
    let numsFL2 = nums22.mapIt( it[it.low] & it[it.high] ).mapIt( it.parseInt() )
    
    # for r in numsFL2.items:
    #     echo( r )
        
    let result2 = nums2.foldl( a + b, 0 )
    let result22 = numsFL2.foldl( a + b, 0 )
    echo( "Result2: ", result2 )
    echo( "Result22: ", result22 )
    


    
main()
