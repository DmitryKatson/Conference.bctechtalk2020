codeunit 80100 "GetFishSpecies"
{
    procedure GetFishSpecies(CountryISOCode: Integer)
    var
        Client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        ResponseJsonAsText: Text;
        DataToken: JsonToken;
        FishSpecieToken: JsonToken;
        i: Integer;

        FishSpecie: Record FishSpecie;

    begin
        PrepareRequest(request);
        request.SetRequestUri(GetFishSpeciesByCountryRequestUrl(CountryISOCode));

        Client.Send(request, response);

        DecompressGZipAndGetRequestResponseInJson(ResponseJsonAsText, response);
        GetDataToken(ResponseJsonAsText, DataToken);

        FishSpecie.DeleteAll();

        for i := 0 to DataToken.AsArray().Count - 1 do begin
            DataToken.AsArray().Get(i, FishSpecieToken);
            InsertFishSpecie(FishSpecie, FishSpecieToken);
            UpdateRecordWithFishSpecieExtraInformation(FishSpecie);
        end;
    end;

    local procedure UpdateRecordWithFishSpecieExtraInformation(var FishSpecie: Record FishSpecie)
    var
        Client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        ResponseJsonAsText: Text;
        ResponseToken: JsonToken;
        DataToken: JsonToken;
    begin
        PrepareRequest(request);
        request.SetRequestUri(GetFishSpeciesByIdRequestUrl(FishSpecie.Code));

        Client.Send(request, response);

        DecompressGZipAndGetRequestResponseInJson(ResponseJsonAsText, response);

        GetDataToken(ResponseJsonAsText, DataToken);

        UpdateFishSpecie(FishSpecie, DataToken);
        UploadFishSpeciePicture(FishSpecie);
    end;


    local procedure GetFishSpeciesByCountryRequestUrl(CountryISOCode: Integer): Text
    begin
        exit(StrSubstNo('%1%2%3%4', GetFishBaseMainUrl(), GetFishBaseCountryUrlPart(), AddDefaultParametersToTheUrl(), AddCountryFilterToTheUrl(CountryISOCode)));
    end;

    local procedure GetFishSpeciesByIdRequestUrl(Id: Integer): Text
    begin
        exit(StrSubstNo('%1%2%3', GetFishBaseMainUrl(), GetFishBaseSpeciesUrlPart(), AddSpeciesIdFilterToTheUrl(Id)));
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

    local procedure GetFishBaseSpeciesUrlPart(): Text
    begin
        exit('/species')
    end;

    local procedure AddDefaultParametersToTheUrl(): Text
    begin
        exit('?limit=15&fields=SpecCode,Status,Saltwater,Land,C_Code')
    end;

    local procedure AddCountryFilterToTheUrl(CountryISOCode: Integer): Text
    begin
        if CountryISOCode = 0 then
            exit;

        exit(StrSubstNo('&C_Code=%1&Saltwater=1', CountryISOCode));
    end;

    local procedure AddSpeciesIdFilterToTheUrl(id: Integer): Text
    begin
        exit(StrSubstNo('/%1?', id));
    end;

    local procedure PrepareRequest(var request: HttpRequestMessage)
    var
        // content: HttpContent;
        contentHeaders: HttpHeaders;
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

        request.Method('GET');
    end;

    local procedure DecompressGZipAndGetRequestResponseInJson(var ResponseJsonAsText: Text; response: HttpResponseMessage)
    var
        responseInStream: InStream;
        responseOutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        convertedInStream: InStream;
        DataCompression: Codeunit "Data Compression";
        decompressedOutStream: OutStream;
    begin
        response.Content.ReadAs(responseInStream);
        TempBlob.CreateOutStream(decompressedOutStream);
        DataCompression.GZipDecompress(responseInStream, decompressedOutStream);
        TempBlob.CreateInStream(convertedInStream);
        convertedInStream.ReadText(ResponseJsonAsText);
    end;

    local procedure GetDataToken(ResponseJsonAsText: Text; var DataToken: JsonToken)
    var
        JsonToken: JsonToken;
    begin
        JsonToken.ReadFrom(ResponseJsonAsText);
        JsonToken.SelectToken('$.data', DataToken);
    end;

    local procedure InsertFishSpecie(var FishSpecie: Record FishSpecie; JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
    begin
        JsonObject := JsonToken.AsObject;

        FishSpecie.init;

        FishSpecie.Code := GetJsonToken(JsonObject, 'SpecCode').AsValue.AsInteger;

        FishSpecie.Insert(true);
    end;

    local procedure UpdateFishSpecie(var FishSpecie: Record FishSpecie; JsonToken: JsonToken)
    var
        JsonObject: JsonObject;
        FishSpecieToken: JsonToken;
    begin
        JsonToken.AsArray().Get(0, FishSpecieToken);
        JsonObject := FishSpecieToken.AsObject;

        FishSpecie.Name := GetJsonToken(JsonObject, 'FBname').AsValue().AsText();
        FishSpecie.Description := CopyStr(GetJsonToken(JsonObject, 'Comments').AsValue().AsText(), 1, MaxStrLen(FishSpecie.Description));
        FishSpecie.BodyShapeI := CopyStr(GetJsonToken(JsonObject, 'BodyShapeI').AsValue().AsText(), 1, MaxStrLen(FishSpecie.BodyShapeI));
        FishSpecie.Dangerous := CopyStr(GetJsonToken(JsonObject, 'Dangerous').AsValue().AsText(), 1, MaxStrLen(FishSpecie.Dangerous));
        FishSpecie.PriceCateg := CopyStr(GetJsonToken(JsonObject, 'PriceCateg').AsValue().AsText(), 1, MaxStrLen(FishSpecie.PriceCateg));
        FishSpecie.PictureUrl := GetJsonToken(JsonObject, 'image').AsValue().AsText();
        FishSpecie.Modify();
    end;

    local procedure UploadFishSpeciePicture(var FishSpecie: Record FishSpecie)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        Client.Get(FishSpecie.PictureUrl, Response);

        Response.Content().ReadAs(InStr);

        FishSpecie.Picture.ImportStream(InStr, FishSpecie.Name);
        FishSpecie.Modify();
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;
}