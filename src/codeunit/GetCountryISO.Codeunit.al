codeunit 80104 "GetCountryISO"
{
    procedure GetCountryISO(var countryCode: Integer; country: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseJson: Text;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
    begin
        Client.Get(GetRequestUrl(country), Response);
        Response.Content.ReadAs(ResponseJson);
        JsonArray.ReadFrom(ResponseJson);
        JsonArray.Get(0, JsonToken);
        JsonObject := JsonToken.AsObject();
        JsonObject.Get('numericCode', JsonToken);
        countryCode := JsonToken.AsValue().AsInteger();
    end;

    local procedure GetRequestUrl(country: Text): Text
    begin
        exit(StrSubstNo('%1%2%3%4', GetRestcountriesMainUrl(), GetCountryByNameUrlPart(), AddCountryFilterToTheUrl(country), AddDefaultParametersToTheUrl()));
    end;

    local procedure GetRestcountriesMainUrl(): Text
    begin
        exit('https://restcountries.eu/rest/v2');
    end;

    local procedure GetCountryByNameUrlPart(): Text
    begin
        exit('/name');
    end;

    local procedure AddCountryFilterToTheUrl(country: Text): Text
    begin
        if country = '' then
            exit;

        exit(StrSubstNo('/%1', country));
    end;

    local procedure AddDefaultParametersToTheUrl(): Text
    begin
        exit('?fields=name;numericCode')
    end;


}