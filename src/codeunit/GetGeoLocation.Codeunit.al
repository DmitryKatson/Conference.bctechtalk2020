codeunit 80101 "GetGeoLocation"
{
    procedure GetGeoLocation(var Latitude: Decimal; var Longitude: Decimal)
    var
        GeoLocation: Codeunit Geolocation;
    begin
        Geolocation.SetHighAccuracy(true);
        if Geolocation.RequestGeolocation() then
            Geolocation.GetGeolocation(Latitude, Longitude);
    end;
}