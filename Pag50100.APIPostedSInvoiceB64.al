page 50100 "API - Posted S. Invoice B64"
{
    PageType = API;
    APIPublisher = 'kevinrosendaal';
    APIGroup = 'sample';
    APIVersion = 'v1.0';
    EntityName = 'postedSalesInvoiceB64';
    EntitySetName = 'postedSalesInvoiceB64';
    SourceTable = "Sales Invoice Header";
    ODataKeyFields = SystemId;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Invoices)
            {
                field(systemId; Rec.SystemId) { }
                field(base64; Base64) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ReportSelections: Record "Report Selections";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        if Rec.Count > 1 then
            Error('Specify Invoice ID.');
        ReportSelections.GetPdfReportForCust(TempBlob, Enum::"Report Selection Usage"::"S.Invoice", Rec, Rec."Sell-to Customer No.");
        TempBlob.CreateInStream(InStr);
        Base64 := Base64Convert.ToBase64(InStr);
    end;

    var
        Base64Convert: Codeunit "Base64 Convert";
        SalesInvoiceNo: Code[20];
        Base64: Text;
}