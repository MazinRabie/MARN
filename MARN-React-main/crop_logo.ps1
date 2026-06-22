Add-Type -AssemblyName System.Drawing
$source = "c:\Coding\MARN AI\public\Logo.png"
$temp = "c:\Coding\MARN AI\public\Logo_temp.png"

$img = [System.Drawing.Image]::FromFile($source)
$newHeight = [math]::Round($img.Height * 0.94)
$bmp = New-Object System.Drawing.Bitmap($img.Width, $newHeight)
$g = [System.Drawing.Graphics]::FromImage($bmp)

$rect = New-Object System.Drawing.Rectangle(0, 0, $img.Width, $newHeight)
$g.DrawImage($img, $rect, $rect, [System.Drawing.GraphicsUnit]::Pixel)

$bmp.Save($temp, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
$img.Dispose()

Remove-Item $source -Force
Rename-Item $temp -NewName "Logo.png"

Write-Host "Image cropped successfully! New Height: $newHeight"
