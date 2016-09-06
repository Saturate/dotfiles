# AKJ's Box Starter Script.
# USE: Pase this into cmd/powershell "START http://boxstarter.org/package/nr/url?{RAW-URL-FOR-THIS-FILE}"
# Example: START http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/Saturate/dotfiles/master/windows/BoxStarter.ps1

# Windows Settings
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
Enable-RemoteDesktop
Update-ExecutionPolicy Unrestricted

# Chocolatey packages

## General
cinst dropbox -y
cinst 7zip.install -y
cinst adobe-creative-cloud -y
cinst teamviewer -y
cinst slack -y

## Developer
cinst Atom -y
cinst poshgit -y
cinst tortoisesvn -y
cinst putty.install -y
cinst googlechrome -y
cinst firefox-dev -y
cinst fiddler4 -y

## Developer Enviorment
cinst nodejs.install -y
# cinst mongodb -y

## Entertainment
cinst steam -y
cinst spotify -y
cinst vlc -y

# Windows Features
cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst IIS-WebServerRole -source windowsfeatures
cinst IIS-HttpCompressionDynamic -source windowsfeatures

# Windows Config
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\Google\Chrome\Application\chrome.exe"

# Node Modules (Global)
npm install -g gulp-cli
npm install -g bower
npm install -g yo
npm install -g jshint

# Atom Packages
apm install minimap
apm install project-manager
apm install pigments
apm install file-icons
apm install language-nunjucks
apm install language-powershell
apm install language-docker
apm install editorconfig

# Windows Update
Install-WindowsUpdate -AcceptEula
