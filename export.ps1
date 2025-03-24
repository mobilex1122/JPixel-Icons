

function Export-Aseprite() {
    param (
        $type,
        $scale,
        $index,
        $prefix
    )

    $dstFolder= "dist/$prefix/$type/x$scale"
    $i = $index - 1

    New-Item $dstFolder -ItemType directory -Force
    Get-ChildItem src/  -Filter *.aseprite |
    Foreach-Object {
        aseprite --frame-range "$i,$i" -b $_.FullName --scale $scale --save-as "$dstFolder/{title}.$type"
    }
}

function Export-Set() {
    param (
        $name,
        $index
    )
    if (Test-Path -Path "dist/$name/") {
        Remove-Item "dist/$name/" -Force -Recurse
    }

    Export-Aseprite -type png -scale 1 -index $index -prefix $name
    Export-Aseprite -type png -scale 2 -index $index -prefix $name
    #Export-Aseprite -type png -scale 4 -index $index -prefix $name
    #Export-Aseprite -type png -scale 6 -index $index -prefix $name
    Export-Aseprite -type svg -scale 2 -index $index -prefix $name

    $s = 2

    $w = (16 * $s) * 20
    $i = $index - 1
    aseprite --frame-range "$i,$i" -b src/* --sheet-width $w --scale $s --sheet "dist/$name.png"
}


Export-Set -name color -index 1
Export-Set -name black -index 2
Export-Set -name white -index 3
