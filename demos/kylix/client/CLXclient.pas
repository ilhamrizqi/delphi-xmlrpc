
{*******************************************************}
{                                                       }
{ XML-RPC Library for Delphi, Kylix and DWPL (DXmlRpc)  }
{ Demo project                                          }
{                                                       }
{ for Delphi 6, 7                                       }
{ Release 2.0.0                                         }
{ Copyright (c) 2001-2003 by Team-DelphiXml-Rpc         }
{ e-mail: team-dxmlrpc@dwp42.org                        }
{ www: http://sourceforge.net/projects/delphixml-rpc/   }
{                                                       }
{ The initial developer of the code is                  }
{   Clifford E. Baeseman, codepunk@codepunk.com         }
{                                                       }
{ This file may be distributed and/or modified under    }
{ the terms of the GNU Lesser General Public License    }
{ (LGPL) version 2.1 as published by the Free Software  }
{ Foundation and appearing in the included file         }
{ license.txt.                                          }
{                                                       }
{*******************************************************}
{
  $Header: /cvsroot/delphixml-rpc/dxmlrpc/demos/kylix/client/CLXclient.pas,v 1.1.1.1 2003/12/03 22:37:16 iwache Exp $
  ----------------------------------------------------------------------------

  $Log: CLXclient.pas,v $
  Revision 1.1.1.1  2003/12/03 22:37:16  iwache
  Initial import of release 2.0.0

  ----------------------------------------------------------------------------
}
unit CLXclient;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, XmlRpcClient, XmlRpcTypes;

type
  TForm3 = class(TForm)
    Button1: TButton;
    ebMessage: TEdit;
    lstMessages: TListBox;
    btnMany: TButton;
    speHelloCount: TSpinEdit;
    ebHost: TEdit;
    sePort: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnManyClick(Sender: TObject);
    procedure lstMessagesDblClick(Sender: TObject);
  private
    FRpcCaller: TRpcCaller;
    FRpcFunction: IRpcFunction;
    procedure AddMessage(const Msg: string);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.xfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  FRpcFunction := TRpcFunction.Create;
  FRpcCaller := TRpcCaller.Create;
  sePort.Value := 8080;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FRpcCaller.Free;
end;

procedure TForm3.AddMessage(const Msg: string);
begin
  lstMessages.Items.Add(Msg);
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  RpcResult: IRpcResult;
begin
  { A function and caller object is used to perform this
    miracle. Set the host name and port and the endpoint
    to be called. We then set the function name to be called
    and add a single string parameter. The function object is
    passed to the execute method and a tresult object is returned}

  FRpcCaller.HostName := ebHost.Text;
  FRpcCaller.HostPort := sePort.Value;
  FRpcCaller.EndPoint := '/RPC2';

  FRpcFunction.Clear;
  FRpcFunction.ObjectMethod := 'example.getHello';
  FRpcFunction.AddItem(ebMessage.Text);
  AddMessage('Starting call');

  try
    RpcResult := FRpcCaller.Execute(FRpcFunction);
    if RpcResult.IsError then
      AddMessage(Format('Error: (%d) %s', [RpcResult.ErrorCode,
          RpcResult.ErrorMsg]))
    else
      AddMessage(RpcResult.AsString);
  except
    on E: Exception do
      AddMessage(StringReplace(E.Message, #13#10, ': ', [rfReplaceAll]));
  end;

end;

procedure TForm3.btnManyClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to speHelloCount.Value - 1 do
    Button1Click(Self);
end;

procedure TForm3.lstMessagesDblClick(Sender: TObject);
begin
  lstMessages.Clear;
end;

end.

