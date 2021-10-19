page 70112 Credpage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Credsetuptable;
    Caption = 'Cred Page';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(clientid; rec.clientid)
                {
                    ApplicationArea = All;

                }
                field(clientsecret; Rec.clientsecret)
                {
                    ApplicationArea = All;

                }

                field(MicrosoftOAuth2Url; Rec.MicrosoftOAuth2Url)
                {
                    ApplicationArea = All;

                }
                field(Scope; Rec.Scope)
                {
                    ApplicationArea = All;

                }
                field(Accesstoken; Accesstoken)
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
            action(gettoken)
            {


                ApplicationArea = All;

                trigger OnAction();
                var
                    Scopes: List of [Text];
                    TempBlob: Codeunit "Temp Blob";
                    Client: HttpClient;
                    RequestHeaders: HttpHeaders;
                    MailContentHeaders: HttpHeaders;
                    MailContent: HttpContent;
                    ResponseMessage: HttpResponseMessage;
                    RequestMessage: HttpRequestMessage;
                    JObject: JsonObject;
                    ResponseStream: InStream;
                    APICallResponseMessage: Text;
                    StatusCode: Integer;
                    IsSuccessful: Boolean;
                    customitemtable: Record InsertItems;
                    jsonar: JsonArray;
                    i: Integer;
                    jsontoken: JsonToken;
                    Object: JsonObject;
                begin
                    Scopes.Add(ResourceURL + '.default');
                    OAuth2.AcquireTokenWithClientCredentials(rec.clientid, rec.clientsecret, rec.MicrosoftOAuth2Url, '', Scopes, Accesstoken);
                    Message(Accesstoken);
                    //Client.DefaultRequestHeaders('Authorization', 'Bearer ' + AccessToken);

                    //RequestMessage.GetHeaders(RequestHeaders);
                    //RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

                    Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
                    IF Client.Get('https://api.businesscentral.dynamics.com/v2.0/98b50d32-8c4b-4c4f-947b-6b9c4e7c0c2c/Production/api/v2.0/companies(64d41503-fcd7-eb11-bb70-000d3a299fca)/items'
                    , responseMessage)
                     THEN begin
                        Message('%1..%2', responseMessage.HttpStatusCode, responseMessage.ReasonPhrase);

                        responseMessage.Content.ReadAs(jsontext);
                        JsonText := CopyStr(JsonText, StrPos(JsonText, '['));
                        Message(jsontext);
                        if not jsonar.ReadFrom(JsonText) then
                            Error('Invalid response, expected an JSON array as root object');

                        For i := 0 to jsonar.Count - 1 do begin
                            jsonar.Get(i, jsontoken);
                            object := jsontoken.AsObject();
                            customitemtable.Init();
                            customitemtable.ItemCode := GetJsonToken(object, 'number').AsValue.AsText();
                            customitemtable.ItemDescription := GetJsonToken(object, 'displayName').AsValue.AsText();
                            customitemtable.Insert();
                        end;

                    end;
                    // RequestMessage.GetHeaders(RequestHeaders);
                    // RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

                    // RequestMessage.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/98b50d32-8c4b-4c4f-947b-6b9c4e7c0c2c/Production/api/v2.0/');
                    // RequestMessage.Method('GET');

                    // Clear(TempBlob);
                    // TempBlob.CreateInStream(ResponseStream);

                    // IsSuccessful := Client.Send(RequestMessage, ResponseMessage);




                    // JObject.WriteTo(APICallResponseMessage);
                    // APICallResponseMessage := APICallResponseMessage.Replace(',', '\');
                    // //exit(APICallResponseMessage);

                end;
            }

        }


    }

    var
        Accesstoken: Text;
        oAuth2: Codeunit OAuth2;
        ResourceURL: Label 'https://api.businesscentral.dynamics.com/';
        responseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestHeaders: HttpHeaders;
        httprequest: HttpClient;
        jsontext: Text;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

}