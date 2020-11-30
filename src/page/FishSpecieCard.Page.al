page 80101 "FishSpecie Card"
{
    Caption = 'Fish Card';
    PageType = Card;
    SourceTable = FishSpecie;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(BodyShapeI; BodyShapeI)
                {
                    ApplicationArea = All;
                }
                field(Dangerous; Dangerous)
                {
                    ApplicationArea = All;
                }
            }
            group(Price)
            {
                field(PriceCateg; PriceCateg)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(FishPicture; "FishSpecie Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "Code" = FIELD("Code");
            }
        }
    }
}