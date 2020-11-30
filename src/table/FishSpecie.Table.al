table 80101 "FishSpecie"
{
    DrillDownPageId = FishSpeciesAroundMe;
    DataCaptionFields = "Code", Name;
    fields
    {
        field(1; "Code"; Integer)
        {
        }
        field(2; Name; Text[100])
        {
        }
        field(3; Description; Text[250])
        {

        }
        field(4; PictureUrl; Text[1024])
        {

        }
        field(5; Picture; Media)
        {
            Caption = 'Picture';
        }
        field(6; BodyShapeI; Text[50])
        {
            Caption = 'Body shape';
        }

        field(7; PriceCateg; Text[50])
        {
            Caption = 'Price Category';
        }
        field(8; PriceReliability; Text[100])
        {
            Caption = 'Price reliability';
        }
        field(9; Dangerous; Text[30])
        {
            Caption = 'Dangerous';
        }
        field(10; Weight; Decimal)
        {

        }

    }
    keys
    {
        key(PK; Code) { }
    }
    fieldgroups
    {
        fieldgroup(Brick; Code, Name, Picture) { }
    }
}