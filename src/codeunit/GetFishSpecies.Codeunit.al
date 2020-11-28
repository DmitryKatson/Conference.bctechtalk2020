codeunit 80100 "GetFishSpecies"
{
    procedure GetFishSpecies(CountryISOCode: Integer)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseJson: Text;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        i: Integer;
    begin
        Client.Get(GetRequestUrl(CountryISOCode), Response);
        Response.Content.ReadAs(ResponseJson);
        JsonObject.ReadFrom(ResponseJson);
        JsonObject.Get('data', JsonToken);
        JsonToken.WriteTo(ResponseJson);
        JsonArray.ReadFrom(ResponseJson);
        for i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            InsertFishSpecie(JsonToken);
        end;
    end;

    local procedure GetRequestUrl(CountryISOCode: Integer) url: Text
    begin
        url := StrSubstNo('%1%2%3%4', GetFishBaseMainUrl(), GetFishBaseCountryUrlPart(), AddDefaultParametersToTheUrl(), AddCountryFilterToTheUrl(CountryISOCode));

        // exit(StrSubstNo('%1%2%3%4', GetFishBaseMainUrl(), GetFishBaseCountryUrlPart(), AddDefaultParametersToTheUrl(), AddCountryFilterToTheUrl(CountryISOCode)));
    end;


    procedure GetFishSpecies(var Latitude: Decimal; var Longitude: Decimal)
    var
        country: Integer;
    begin
        GetCountry(country, Latitude, Longitude);
        GetFishSpecies(country);
    end;

    local procedure GetCountry(var CountryISOCode: Integer; Latitude: Decimal; Longitude: Decimal)
    var
        GetCountry: Codeunit GetCountry;
        GetCountryISO: Codeunit GetCountryISO;
        country: Text;
    begin
        GetCountry.GetCountry(Country, Latitude, Longitude);
        GetCountryISO.GetCountryISO(CountryISOCode, Country);
    end;

    local procedure GetFishBaseMainUrl(): Text
    begin
        exit('https://fishbase.ropensci.org')
    end;

    local procedure GetFishBaseCountryUrlPart(): Text
    begin
        exit('/country')
    end;

    local procedure AddDefaultParametersToTheUrl(): Text
    begin
        exit('?limit=10&fields=SpecCode,Status,Saltwater,Land,C_Code')
    end;

    local procedure AddCountryFilterToTheUrl(CountryISOCode: Integer): Text
    begin
        if CountryISOCode = 0 then
            exit;

        exit(StrSubstNo('&C_Code=%1&Saltwater=1', CountryISOCode));
    end;

    procedure InsertFishSpecie(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
        FishSpecie: Record FishSpecie;
    begin
        JsonObject := JsonToken.AsObject;

        FishSpecie.init;

        FishSpecie.Code := GetJsonToken(JsonObject, 'SpecCode').AsValue.AsInteger;

        FishSpecie.Insert(true);
    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;



}