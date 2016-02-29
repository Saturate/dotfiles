# AKJ's Box Starter Script.
# USE: Pase this into cmd/powershell "START http://boxstarter.org/package/nr/url?{RAW-URL-FOR-THIS-FILE}"

# Windows Settings
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
Enable-RemoteDesktop
Update-ExecutionPolicy Unrestricted

# Chocolatey packages
cinst fiddler4 -y
cinst dropbox -y
cinst Atom -y
cinst spotify -y
cinst vlc -y
cinst googlechrome -y
cinst firefox-dev -y 
cinst steam -y
cinst putty.install -y
cinst 7zip.install -y
cinst mongodb -y
cinst nodejs.install -y
cinst tortoisesvn -y
cinst adobe-creative-cloud -y
cinst putty.install -y
cinst teamviewer -y
cinst poshgit -y
cinst slack -y

# Windows Features
cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst IIS-WebServerRole -source windowsfeatures
cinst IIS-HttpCompressionDynamic -source windowsfeatures

# Windows Config
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\Google\Chrome\Application\chrome.exe"

# Node modules (Global)
npm install -g gulp
npm install -g bower
npm install -g yo
npm install -g jshint

# Atom Packages
apm install minimap
apm install language-nunjucks

# Windows Update
Install-WindowsUpdate -AcceptEula
