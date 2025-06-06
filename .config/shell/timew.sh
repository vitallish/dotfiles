
function timew-tagrename()
{
# Rename tags in timewarrior
# https://github.com/GothenburgBitFactory/timewarrior/issues/210
        local oldtag=$1; shift
        local newtag=$1; shift
        local idlist=$(timew summary 1970W01 - now "$oldtag" :ids |\
                       sed -nr 's/.* (@[0-9]+) .*/\1/p')
        echo "$idlist" | xargs -I ids timew tag ids "$newtag"
        echo "$idlist" | xargs -I ids timew untag ids "$oldtag"
}


