table 70112 Credsetuptable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; clientid; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(2; clientsecret; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(3; MicrosoftOAuth2Url; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Scope; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Primary Key"; Text[100])
        {
            DataClassification = ToBeClassified;

        }


    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}