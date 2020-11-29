codeunit 80103 "GetFishSpeciesInMyGeoLocation"
{
    procedure GetFishSpeciesInMyGeoLocation(var Rec: Record "MyGeoLocationBuffer")
    var
        GetGeoLocation: Codeunit GetGeoLocation;
        GetCountry: Codeunit GetCountry;
        GetCountryISO: Codeunit GetCountryISO;
        GetFishSpecies: Codeunit GetFishSpecies;
    begin
        with Rec do begin
            // GetGeoLocation.GetGeoLocation(Latitude, Longitude);
            // GetCountry.GetCountry(Country, Latitude, Longitude);
            // GetCountryISO.GetCountryISO(CountryISOCode, Country);
            // GetFishSpecies.GetFishSpecies(CountryISOCode);
            GetFishSpecies.GetFishSpecies(702);
        end;
    end;

}