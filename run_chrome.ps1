# Run Flutter web app in Chrome with dev session and CORS disabled.
# Uses a temp profile dir to avoid "Account Web Data" / file-in-use locks (errno 1224).
$ChromeProfileDir = Join-Path $env:TEMP "intimetpro_flutter_chrome"
if (-not (Test-Path $ChromeProfileDir)) { New-Item -ItemType Directory -Path $ChromeProfileDir -Force | Out-Null }
$env:CHROME_EXECUTABLE = "C:\Program Files\Google\Chrome\Application\chrome.exe"
flutter run -d chrome `
  --web-browser-flag=--disable-web-security `
  --web-browser-flag="--user-data-dir=$ChromeProfileDir"
