table 80100 "MyGeoLocationBuffer"
{
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Latitude; Decimal) { }
        field(3; Longitude; Decimal) { }
        field(4; Country; Text[100]) { }
        field(5; CountryISOCode; Integer) { }
    }
    keys
    {
        key(PK; "Entry No.") { }
    }
}