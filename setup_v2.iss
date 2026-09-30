[Setup]
AppName=ASHH Optimizer
AppVersion=2.0.0
DefaultDirName={autopf}\ASHH Optimizer
DefaultGroupName=ASHH Optimizer
OutputBaseFilename=AshhOptimizer_Setup
OutputDir=.\Output
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64

[Files]
Source: ".\Output\Publish\OptimizerUI\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\Output\Publish\Service\*"; DestDir: "{app}\Service"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\ASHH Optimizer"; Filename: "{app}\ASHH Optimizer.exe"
Name: "{autodesktop}\ASHH Optimizer"; Filename: "{app}\ASHH Optimizer.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Registry]
Root: HKCU; Subkey: "Software\AshhOptimizer"; ValueType: dword; ValueName: "WalkthroughComplete"; ValueData: 0; Flags: uninsdeletevalue

[Run]
Filename: "{sys}\sc.exe"; Parameters: "stop ""AshhOptimizerService"""; Flags: runhidden
Filename: "{sys}\sc.exe"; Parameters: "delete ""AshhOptimizerService"""; Flags: runhidden
Filename: "{sys}\sc.exe"; Parameters: "create ""AshhOptimizerService"" binPath= ""\""{app}\Service\AshhOptimizer.Service.exe\"""" start= auto DisplayName= ""ASHH Optimizer Background Service"""; Flags: runhidden
Filename: "{sys}\sc.exe"; Parameters: "start ""AshhOptimizerService"""; Flags: runhidden
Filename: "{app}\ASHH Optimizer.exe"; Description: "Launch ASHH Optimizer"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\sc.exe"; Parameters: "stop ""AshhOptimizerService"""; Flags: runhidden skipifdoesntexist
Filename: "{sys}\sc.exe"; Parameters: "delete ""AshhOptimizerService"""; Flags: runhidden skipifdoesntexist
