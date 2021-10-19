table 70113 InsertItems
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ItemCode; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(2; ItemDescription; Text[50])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; ItemCode)
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