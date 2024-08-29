page 50101 "Certificate Setup"
{
    ApplicationArea = All;
    Caption = 'Certificate Setup';
    PageType = Card;
    SourceTable = "Certificate Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(HasCertificate; Rec.Certificate.HasValue())
                {
                    Caption = 'Has Certificate';
                    Editable = false;
                }
                field(Endpoint; Rec.Endpoint)
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadCertificate)
            {
                ApplicationArea = All;
                Caption = 'Upload Certificate';

                trigger OnAction()
                var
                    CertInStream: InStream;
                    CertOutStream: OutStream;
                    FileName: Text;
                begin
                    Clear(Rec.Certificate);

                    if File.UploadIntoStream('UploadCert', '', '', FileName, CertInStream) then begin
                        Rec.Certificate.CreateOutStream(CertOutStream);
                        CopyStream(CertOutStream, CertInStream);
                    end;

                    Rec.Modify(true);
                end;
            }
            action(RunRequest)
            {
                ApplicationArea = All;
                Caption = 'Run Request';

                trigger OnAction()
                var
                    Base64Convert: Codeunit "Base64 Convert";
                    RestClient: Codeunit "Rest Client";
                    HttpResponseMessage: Codeunit "Http Response Message";
                    InStr: InStream;
                    Certificate: Text;
                begin
                    if Rec.Certificate.HasValue() then begin
                        Rec.CalcFields(Certificate);
                        Rec.Certificate.CreateInStream(InStr);
                        Certificate := Base64Convert.ToBase64(InStr);
                        RestClient.AddCertificate(Certificate);
                    end;

                    HttpResponseMessage := RestClient.Get(Rec.Endpoint);
                    if HttpResponseMessage.GetIsSuccessStatusCode() then
                        Message(HttpResponseMessage.GetContent().AsText())
                    else
                        Message(HttpResponseMessage.GetErrorMessage());
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Reset();
            Rec.Insert(true);
        end;
    end;
}