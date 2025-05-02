Set WShell = CreateObject("WScript.Shell")
WShell.Run "cmd /c python app.py", 0
WScript.Sleep 2000
WShell.Run "cmd /c cd frontend && npm start", 0
WScript.Sleep 3000
WShell.Run "http://localhost:3000" 