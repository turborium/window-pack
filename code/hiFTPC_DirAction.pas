unit hiFTPC_DirAction;

interface

uses Kol, Share, Debug, WinInet, Windows, hiFTP_Client;

type
  THIFTPC_DirAction = class(TDebug)
   private
    CurrentDir: string;    
   public
    _prop_Action: byte;
    _prop_Directory: string;
    _prop_FTP_Client: IFTP_Client;
    _prop_ErrorEvent: byte; 

    _data_Directory: THI_Event;

    _event_onError,
    _event_onDirAction: THI_Event;


    procedure _work_doDirAction0(var _Data: TData; Index: word); // SetCurrentDir
    procedure _work_doDirAction1(var _Data: TData; Index: word); // GetCurrentDir
    procedure _work_doDirAction2(var _Data: TData; Index: word); // CreateDir       
    procedure _work_doDirAction3(var _Data: TData; Index: word); // RemoveDir;    

    procedure _var_CurrentDir(var _Data: TData; Index: word);
  end;

implementation

procedure THIFTPC_DirAction._work_doDirAction0;
var
  hFTP: HINTERNET;
  dir: string;
begin
  if not Assigned(_prop_FTP_Client) then exit;
  dir := ReadString(_Data, _data_Directory, _prop_Directory);
  hFTP := _prop_FTP_Client.getftphandle;
  if not FtpSetCurrentDirectory(hFTP, PChar(dir)) then
  begin
    if (_prop_ErrorEvent = 0) or (_prop_ErrorEvent = 2) then _prop_FTP_Client.onerror(3);
    if (_prop_ErrorEvent = 1) or (_prop_ErrorEvent = 2) then _hi_onEvent(_event_onError, 3);
  end  
  else
    _hi_onEvent(_event_onDirAction, dir);  
end;

procedure THIFTPC_DirAction._work_doDirAction1;
var
  hFTP: HINTERNET;
  len: Cardinal;
begin
  if not Assigned(_prop_FTP_Client) then exit;
  hFTP := _prop_FTP_Client.getftphandle;
  len := MAX_PATH; 
  CurrentDir := '';
  SetLength(CurrentDir, len);
  if not FtpGetCurrentDirectory(hFTP, @CurrentDir[1], len) then
  begin
    if (_prop_ErrorEvent = 0) or (_prop_ErrorEvent = 2) then _prop_FTP_Client.onerror(10);
    if (_prop_ErrorEvent = 1) or (_prop_ErrorEvent = 2) then _hi_onEvent(_event_onError, 10);    
    exit;
  end;  
  SetLength(CurrentDir, len);
  _hi_onEvent(_event_onDirAction, CurrentDir);
end;

procedure THIFTPC_DirAction._work_doDirAction2;
var
  hFTP: HINTERNET;
  dir: string;
begin
  if not Assigned(_prop_FTP_Client) then exit;
  dir := ReadString(_Data, _data_Directory, _prop_Directory);
  hFTP := _prop_FTP_Client.getftphandle;
  if not FtpCreateDirectory(hFTP, PChar(dir)) then
  begin
    if (_prop_ErrorEvent = 0) or (_prop_ErrorEvent = 2) then _prop_FTP_Client.onerror(8);
    if (_prop_ErrorEvent = 1) or (_prop_ErrorEvent = 2) then _hi_onEvent(_event_onError, 8);    
  end  
  else
    _hi_onEvent(_event_onDirAction, dir);    
end;

procedure THIFTPC_DirAction._work_doDirAction3;
var
  hFTP: HINTERNET;
  dir: string;
begin
  if not Assigned(_prop_FTP_Client) then exit;
  dir := ReadString(_Data, _data_Directory, _prop_Directory);
  hFTP := _prop_FTP_Client.getftphandle;
  if not FtpRemoveDirectory(hFTP, PChar(dir)) then
  begin
    if (_prop_ErrorEvent = 0) or (_prop_ErrorEvent = 2) then _prop_FTP_Client.onerror(9);
    if (_prop_ErrorEvent = 1) or (_prop_ErrorEvent = 2) then _hi_onEvent(_event_onError, 9);
  end  
  else
    _hi_onEvent(_event_onDirAction, dir);
end;

procedure THIFTPC_DirAction._var_CurrentDir;
begin
  dtString(_Data, CurrentDir);
end;

end.