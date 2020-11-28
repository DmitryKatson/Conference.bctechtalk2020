codeunit 80102 "GetCountry"
{
    procedure GetCountry(var country: Text; Latitude: Decimal; Longitude: Decimal)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseJson: Text;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
    begin
        Client.Get(GetRequestUrl(Latitude, Longitude), Response);
        Response.Content.ReadAs(ResponseJson);
        JsonObject.ReadFrom(ResponseJson);
        JsonObject.Get('country', JsonToken);
        country := JsonToken.AsValue().AsText();
    end;

    local procedure GetRequestUrl(Latitude: Decimal; Longitude: Decimal): Text
    begin
        exit(StrSubstNo('%1%2%3%4', GetGeocodeXYZMainUrl(), AddGeoFilterToTheUrl(Latitude, Longitude), AddDefaultParametersToTheUrl(), AddAuthorizationToTheUrl()));
    end;

    local procedure GetGeocodeXYZMainUrl(): Text
    begin
        exit('https://geocode.xyz');
    end;

    local procedure AddGeoFilterToTheUrl(var Latitude: Decimal; var Longitude: Decimal): Text
    begin
        exit(StrSubstNo('/%1,%2', Latitude, Longitude));
    end;

    local procedure AddDefaultParametersToTheUrl(): Text
    begin
        exit('?json=1')
    end;

    local procedure AddAuthorizationToTheUrl(): Text
    begin
        exit(StrSubstNo('&auth=%1', GetAuthorizationCode()));
    end;

    local procedure GetAuthorizationCode(): Text
    begin
        exit('12135110162959682512x56652');
    end;

}