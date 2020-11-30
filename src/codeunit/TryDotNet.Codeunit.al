#if ONPREM
codeunit 80105 "TryDotNet"
{
    local procedure TryDotNet()
    var
        DotNetHttpClient: DotNet MyDateTime;
    begin

    end;
}

dotnet
{
    assembly(mscorlib)
    {
        type(System.DateTime; MyDateTime) { }
    }
}
#endif