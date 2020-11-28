codeunit 80100 "GetFishSpecies"
{
    procedure GetFishSpecies(country: Integer)
    begin

    end;

    procedure GetFishSpecies(var Latitude: Decimal; var Longitude: Decimal)
    var
        country: Integer;
    begin
        GetCountry(country, Latitude, Longitude);
        GetFishSpecies(country);
    end;

    local procedure GetCountry(var country: Integer; var Latitude: Decimal; var Longitude: Decimal)
    begin

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
        exit('?limit=100&fields=SpecCode,Status,Saltwater,Land')
    end;

    local procedure AddCountryFilterToTheUrl(country: Integer): Text
    begin
        if country = 0 then
            exit;

        exit(StrSubstNo('&CountryRefNo=%1', country));
    end;


}