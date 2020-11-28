codeunit 80103 "GetFishSpeciesInMyGeoPosition"
{
    procedure GetFishSpeciesInMyGeoPosition(var Rec: Record MyGeoLocationBuffer)
    var
        GetGeoLocation: Codeunit GetGeoLocation;
        GetCountry: Codeunit GetCountry;
        GetCountryISO: Codeunit GetCountryISO;
        GetFishSpecies: Codeunit GetFishSpecies;
    begin
        GetGeoLocation.GetGeoLocation(Rec.Latitude, Rec.Longitude);
        GetCountry.GetCountry(Rec.Country, Rec.Latitude, Rec.Longitude);
        GetCountryISO.GetCountryISO(Rec.CountryISOCode, Rec.Country);
        GetFishSpecies.GetFishSpecies(Rec.CountryISOCode);
    end;

}