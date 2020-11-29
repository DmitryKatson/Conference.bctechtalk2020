codeunit 80100 "GetFishSpecies"
{
    procedure GetFishSpecies(CountryISOCode: Integer)
    var
        Client: HttpClient;
        // content: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        ResponseJsonAsText: Text;
        ResponseToken: JsonToken;
        DataToken: JsonToken;
        FishSpecieToken: JsonToken;
        i: Integer;

        responseInStream: InStream;
        responseOutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        convertedInStream: InStream;
        DataCompression: Codeunit "Data Compression";
        decompressedOutStream: OutStream;
        FishSpecie: Record FishSpecie;

    begin
        // content.GetHeaders(contentHeaders);
        // contentHeaders.Clear();
        // contentHeaders.Remove('Content-Type');
        // contentHeaders.Remove('Content-Encoding');
        // contentHeaders.Add('Content-Encoding', 'gzip');
        // contentHeaders.Add('Content-Type', 'application/json; charset=utf8');

        request.GetHeaders(contentHeaders);
        contentHeaders.Remove('Accept');
        contentHeaders.Remove('accept-encoding');
        contentHeaders.Add('Accept', 'application/vnd.ropensci.v6+json');
        contentHeaders.Add('accept-encoding', 'gzip, deflate');

        request.SetRequestUri(GetRequestUrl(CountryISOCode));
        request.Method('GET');

        Client.Send(request, response);

        response.Content.ReadAs(responseInStream);
        TempBlob.CreateOutStream(decompressedOutStream);
        DataCompression.GZipDecompress(responseInStream, decompressedOutStream);
        TempBlob.CreateInStream(convertedInStream);
        convertedInStream.ReadText(ResponseJsonAsText);

        FishSpecie.DeleteAll();

        ResponseToken.ReadFrom(ResponseJsonAsText);
        ResponseToken.SelectToken('$.data', DataToken);
        for i := 0 to DataToken.AsArray().Count - 1 do begin
            DataToken.AsArray().Get(i, FishSpecieToken);
            InsertFishSpecie(FishSpecieToken);
        end;
    end;

    local procedure GetRequestUrl(CountryISOCode: Integer): Text
    begin
        exit(StrSubstNo('%1%2%3%4', GetFishBaseMainUrl(), GetFishBaseCountryUrlPart(), AddDefaultParametersToTheUrl(), AddCountryFilterToTheUrl(CountryISOCode)));
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