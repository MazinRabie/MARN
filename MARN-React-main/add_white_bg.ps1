Add-Type -AssemblyName System.Drawing
$source = "c:\Coding\MARN AI\public\Logo2.png"
$dest = "c:\Coding\MARN AI\public\Logo2_white_bg.png"
$img = [System.Drawing.Image]::FromFile($source)
$bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::White)
$g.DrawImage($img, 0, 0)
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Image processed successfully!"
