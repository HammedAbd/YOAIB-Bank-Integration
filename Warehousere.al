page 50120 WhsercptPost
{
    ODataKeyFields = SystemId;
    SourceTable = "Warehouse Receipt Header";
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'ashish';
    APIGroup = 'ashishdemo';
    EntityCaption = 'Whserceipt';
    EntitySetCaption = 'Whserceipt';
    EntityName = 'whserceipt';
    EntitySetName = 'whserceipt';
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Id; rec.SystemId)
                {
                    ApplicationArea = All;
                }

                field(Number; rec."No.")
                {
                    ApplicationArea = All;
                }

                field(LocationCode; rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.ErrorIfUserIsNotWhseEmployee();
    end;

    [ServiceEnabled]
    procedure postwhsercpt(var actionContext: WebServiceActionContext)
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        pager: Codeunit ODataUtility;
        ODataActionManagement: Codeunit "OData Action Management";
        purchase: Page "Purchase Order";
        postedreccpt: Record "Posted Whse. Receipt Header";
    begin
        WhseRcptLine.SetRange("No.", Rec."No.");
        IF WhseRcptLine.FindFirst THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Whse.-Post Receipt", WhseRcptLine);

            actionContext.SetObjectType(ObjectType::Page);
            actionContext.SetObjectId(Page::"Posted Whse. Receipt");
            actionContext.AddEntityKey(Rec.FIELDNO(SystemId), postedreccpt.SystemId);

            // Set the result code to inform the caller that an item was created.
            actionContext.SetResultCode(WebServiceActionResultCode::Created);
            actionContext.SetObjectId(page::"Posted Whse. Receipt");
            //ODataActionManagement.SetCreatedPageResponse(actionContext.GetObjectId2()));

        END;
    end;
}
