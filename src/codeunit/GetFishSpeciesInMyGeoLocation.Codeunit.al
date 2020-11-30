codeunit 80103 "GetFishSpeciesInMyGeoLocation"
{
    /// <summary> 
    /// Call to 6 different API's to get information about fish species around me
    /// <remarks>
    /// <list type="bullet">
    /// <item>
    /// <description>Business Central <i>GeoLocation</i> module to get client geo coordinates</description>
    /// </item>
    /// <item>
    /// <description>https://geocode.xyz to get country name from geo coordinates</description>
    /// </item>
    /// <item>
    /// <description>https://restcountries.eu to get country iso code from country name</description>
    /// </item>
    /// <item>
    /// <description>https://fishbase.ropensci.org/country to get list of fish species in the country</description>
    /// </item>
    /// <item>
    /// <description>https://fishbase.ropensci.org/species to get information about fish</description>
    /// </item>
    /// <item>
    /// <description>https://www.fishbase.de/images to get image of fish</description>
    /// </item>
    /// </list>
    /// </remarks>
    /// </summary>
    /// <param name="Rec">Temporary MyGeoLocationBuffer buffer. Will save the geo information from the api's</param>
    /// <seealso cref="https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-xml-comments"/>
    procedure GetFishSpeciesInMyGeoLocation(var Rec: Record "MyGeoLocationBuffer")
    var
        GetGeoLocation: Codeunit GetGeoLocation;
        GetCountry: Codeunit GetCountry;
        GetCountryISO: Codeunit GetCountryISO;
        GetFishSpecies: Codeunit GetFishSpecies;
    begin
        with Rec do begin
            GetGeoLocation.GetGeoLocation(Latitude, Longitude);
            GetCountry.GetCountry(Country, Latitude, Longitude);
            GetCountryISO.GetCountryISO(CountryISOCode, Country);
            GetFishSpecies.GetFishSpecies(CountryISOCode);
        end;
    end;
}