# Update BIOS Passwort für Dell
# Powershell Script auf dem Client ausführen, dies ermöglicht eine Automatiesierung für das Setzen eines Bios Passworts.
# Version: 1.1.5
# Entwickler: Aydin Voelk - Aydin.Voelk@outlook.de
#
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Abhängigkeiten:
# Um das bereitgestellte PowerShell-Skript fehlerfrei auszuführen, müssen die folgenden Bedingungen erfüllt sein:
# 1. Dell Command | Configure: Dieses Tool muss auf dem Dell-Notebook installiert sein, da das Skript es verwendet,
# um das BIOS-Passwort zu setzen. Sie können es von der Dell-Website herunterladen und installieren.
#
#
# 2. Administratorrechte: Das Skript muss mit Administratorrechten ausgeführt werden,
# da es Änderungen am BIOS vornimmt und Dateien in einem Systemverzeichnis erstellt.
#
#
# 3. PowerShell: Das Skript ist in PowerShell geschrieben, daher muss PowerShell auf dem Computer installiert sein.
# PowerShell ist standardmäßig auf den meisten modernen Windows-Systemen installiert.
#
#
# 4. Zugriff auf das Dateisystem: Das Skript muss in der Lage sein, auf das Dateisystem zuzugreifen, um den Ordner "C:\Logs" zu erstellen und die Log-Datei zu
# schreiben. Es sollte keine Probleme geben, solange das Skript mit Administratorrechten ausgeführt wird und keine anderen Sicherheitsrichtlinien oder Software (wie Antivirus-Programme) den Zugriff blockieren.
#
#
# 5. Korrektes BIOS-Passwort: Das Skript setzt das BIOS-Passwort auf den Wert, den Sie im Skript angeben. Sie müssen sicherstellen, dass das Passwort den Anforderungen 
# des BIOS entspricht (zum Beispiel in Bezug auf die Länge und die verwendeten Zeichen).
#
#
# Bitte beachten Sie, dass das Setzen eines BIOS-Passworts nicht ohne Risiken ist. Wenn Sie das Passwort vergessen, kann es schwierig sein, es zurückzusetzen, und Sie 
# könnten den Zugriff auf das System verlieren. Es wird dringend empfohlen, das Passwort an einem sicheren Ort zu speichern.

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Setzen Sie das Arbeitsverzeichnis auf das Installationsverzeichnis von Dell Command | Configure
Set-Location -Path "C:\Program Files (x86)\Dell\Command Configure"

# Überprüfen Sie, ob der Ordner "C:\Logs" existiert, und erstellen Sie ihn, falls er nicht existiert
if (!(Test-Path -Path "C:\Logs")) {
    New-Item -ItemType Directory -Path "C:\Logs"
}

# Überprüfen Sie, ob die Datei "bios.txt" existiert, und erstellen Sie sie, falls sie nicht existiert
$logFile = "C:\Logs\bios.txt"
if (!(Test-Path -Path $logFile)) {
    New-Item -ItemType File -Path $logFile
}

# Erstellen Sie eine Konfigurationsdatei mit dem gewünschten BIOS-Passwort
& .\cctk.exe --setuppwd=IhrPasswort --output=.\config.ini

# Wenden Sie die Konfigurationsdatei an
$process = Start-Process -FilePath ".\cctk.exe" -ArgumentList "--config=.\config.ini" -NoNewWindow -Wait -PassThru

# Überprüfen Sie, ob der Prozess erfolgreich war, und schreiben Sie das Ergebnis in die Log-Datei
if ($process.ExitCode -eq 0) {
    Add-Content -Path $logFile -Value "OK"
} else {
    Add-Content -Path $logFile -Value "Fehler: Der Prozess hat den Exit-Code $($process.ExitCode) zurückgegeben."
}
