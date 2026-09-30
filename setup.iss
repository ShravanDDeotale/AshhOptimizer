[Setup]
AppName=ASHH Optimizer
AppVersion=2.0
DefaultDirName={autopf}\ASHH Optimizer
DefaultGroupName=ASHH Optimizer
OutputDir=.\Installer
OutputBaseFilename=AshhOptimizer_Setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin

[Files]
Source: "PublishOutput\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\ASHH Optimizer"; Filename: "{app}\ASHH Optimizer.exe"
Name: "{autodesktop}\ASHH Optimizer"; Filename: "{app}\ASHH Optimizer.exe"

[Run]
Filename: "{app}\ASHH Optimizer.exe"; Description: "Launch ASHH Optimizer"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "sc.exe"; Parameters: "stop ""AshhOptimizerService"""; Flags: runhidden; RunOnceId: "StopService"
Filename: "sc.exe"; Parameters: "delete ""AshhOptimizerService"""; Flags: runhidden; RunOnceId: "DelService"
Filename: "schtasks.exe"; Parameters: "/delete /tn ""ASHH Optimizer"" /f"; Flags: runhidden; RunOnceId: "DelTask"
