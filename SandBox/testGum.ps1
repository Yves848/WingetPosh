# test if gum is installed

# $type = Invoke-Command -scriptblock  {gum choose 'fix' 'feat' 'docs' 'style' 'refactor' 'test' 'chore' 'revert'}
# $type

# $type = Invoke-Command -scriptblock  {"fix`nfeat`ndocs`nstyle`nrefactor`ntest`nchore`nrevert`n" | gum choose --no-limit --header "Choisissez ....."}
# $type

# $confirm = Invoke-Command -ScriptBlock {gum confirm --affirmative="Oui" --negative="Non" "Test" && echo "Oui" || echo "Non"}
# $confirm

# $file = Invoke-Command -ScriptBlock {gum file}
# $file


# eza -f -1 | Where-Object {$_ -like "*.ps1"} | gum filter --no-limit --header "Choisissez un fichier"

gum spin --spinner dot --title "List Winget Packages" -- pwsh.exe -noprofile -Command ".\getingetpackages.ps1"
gum table --file .\test.csv --widths 30,30,10,10,30