Add-Type -A System.IO.Compression.FileSystem
$Source = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\redist\x64\Microsoft.VC120.CRT\msvc*120.dll"
$Destination = "webthree-umbrella\build\_CPack_Packages\win64\NSIS\Ethereum\eth\"
Copy-Item -Path $Source -Destination $Destination -Force -recurse
[IO.Compression.ZipFile]::CreateFromDirectory('webthree-umbrella\build\_CPack_Packages\win64\NSIS\Ethereum\eth\', 'win_eth.zip')
