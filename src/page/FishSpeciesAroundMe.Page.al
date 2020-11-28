page 80100 "FishSpeciesAroundMe"
{
    PageType = List;
    Editable = false;
    Caption = 'Fish around me';
    layout
    {
        area(Content)
        {
            group(MyGeoLocation)
            {
                Caption = 'My geo location';
                field(Latitude; MyGeoLocationBuffer.Latitude)
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 6;
                    BlankZero = true;
                }
                field(Longitude; MyGeoLocationBuffer.Longitude)
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 6;
                    BlankZero = true;
                }
                field(Country; MyGeoLocationBuffer.Country)
                {
                    ApplicationArea = all;
                }
                field(CountryISOCode; MyGeoLocationBuffer.CountryISOCode)
                {
                    Caption = 'ISO code';
                    ApplicationArea = all;
                    BlankZero = true;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Update)
            {
                ApplicationArea = all;
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MainCodeunit: Codeunit GetFishSpeciesInMyGeoPosition;
                begin
                    MainCodeunit.GetFishSpeciesInMyGeoPosition(MyGeoLocationBuffer);
                end;
            }
        }
    }
    var
        MyGeoLocationBuffer: Record MyGeoLocationBuffer;
}