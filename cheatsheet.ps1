$var = "Hello"; $num = 10; $flag = $true
if ($number -gt 10) {
    Write-Host "Greater than 10"
}
elseif ($number -eq 10) {
    Write-Host "Equal to 10" }

foreach ($item in $collection) {
    # use $item
}
function MyFunction {
    param(
        [string]$Name,
        [int]$Age
    )

    Write-Host "Name: $Name, Age: $Age"
    return $a + $b
}
MyFunction -Name "John" -Age 25
-------------------------------------------------------------------
FIBONACCI SERIES

$Count = Read-Host "Enter how many Fibonacci numbers to print"
$a = 0
$b = 1

Write-Host $a
Write-Host $b

for ($i = 2; $i -lt $Count; $i++) {
    $c = $a + $b
    Write-Host $c
    $a = $b
    $b = $c
}
-----------------------------------------------------------
STRING REVERSE

$str = "hello"
$rev = ""

for ($i = $str.Length - 1; $i -ge 0; $i--) {
    $rev += $str[$i]
}

Write-Host $rev
