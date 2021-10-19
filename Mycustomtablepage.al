page 70114 Customitempagelist
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = InsertItems;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ItemCode; rec.ItemCode)
                {
                    ApplicationArea = All;

                }
                field(ItemDescription; rec.ItemDescription)
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Postaction)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    url: text;
                    objecttext: Text;
                    typehel: Codeunit "Type Helper";
                    object: JsonObject;
                    httpclient: HttpClient;
                    content: HttpContent;
                    httpheader: HttpHeaders;
                    htprep: HttpResponseMessage;
                    responsetext: text;
                    credtable: Record Credsetuptable;
                    Scopes: List of [Text];
                begin
                    credtable.Get();
                    Scopes.Add(ResourceURL + '.default');
                    OAuth2.AcquireTokenWithClientCredentials(credtable.clientid, credtable.clientsecret, credtable.MicrosoftOAuth2Url, '', Scopes, Accesstoken);
                    Message(Accesstoken);
                    //Client.DefaultRequestHeaders('Authorization', 'Bearer ' + AccessToken);

                    //RequestMessage.GetHeaders(RequestHeaders);
                    //RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);


                    url := 'https://api.businesscentral.dynamics.com/v2.0/98b50d32-8c4b-4c4f-947b-6b9c4e7c0c2c/Production/api/v2.0/companies(64d41503-fcd7-eb11-bb70-000d3a299fca)/items';

                    //object.Add('Content-Type', 'application/json');
                    //object.Add('Authorization', 'Basic QVNISVNIOjA1SFltK1dZUmxmdDlqZFdZWFZiQ3A3bXdjTEhjQmJGbGZFS0M5TUpBc2c9');
                    object.add('number', Rec.ItemCode);
                    object.Add('displayName', rec.ItemDescription);

                    object.WriteTo(objecttext);
                    content.WriteFrom(objecttext);
                    content.GetHeaders(httpheader);

                    httpheader.Remove('Content-Type');
                    httpheader.Add('Content-Type', 'application/json');
                    //httpclient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
                    httpclient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
                    Message(objecttext);
                    IF httpclient.Post(url, content, htprep) then BEGIN
                        htprep.Content.ReadAs(responsetext);
                        Message(responsetext);
                    END;
                   
                end;
            }

        }

    }
    var
        OAuth2: Codeunit OAuth2;
        ResourceURL: Label 'https://api.businesscentral.dynamics.com/';
        Accesstoken: Text;

}