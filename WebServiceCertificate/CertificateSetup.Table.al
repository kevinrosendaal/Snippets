table 50100 "Certificate Setup"
{
    Caption = 'Certificate Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PK; Code[10])
        {
            Caption = 'PK';
        }
        field(2; Certificate; Blob)
        {
            Caption = 'Certificate';
        }
        field(3; Endpoint; Text[250])
        {
            Caption = 'Endpoint';
        }
    }
    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }
}