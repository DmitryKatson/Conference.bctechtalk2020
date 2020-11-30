page 80102 "FishSpecie Picture"
{
    Caption = 'FishSpecie Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = FishSpecie;

    layout
    {
        area(content)
        {
            field(Picture; Picture)
            {
                ApplicationArea = Basic, Suite, Invoicing;
                ShowCaption = false;
            }
        }
    }
}