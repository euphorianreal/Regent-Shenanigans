Compress-Archive -Path .\game\* -DestinationPath .\game.zip -Force
if (Test-Path .\game.love) { Remove-Item .\game.love }
Rename-Item .\game.zip game.love
node .\node_modules\love.js\index.js .\game.love .\build -c -t "Regent Shenanigans"