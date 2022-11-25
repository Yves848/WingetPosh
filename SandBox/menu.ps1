<#
    A template for interactive, PowerShell menu.

    Created by Wiktor Mrowczynski.
    v.2022.05.25.A
#>

#region FUNCTIONS

# Function used to simply revert console colors
function Reverse-Colors {
    $bColor = [System.Console]::BackgroundColor
    $fColor = [System.Console]::ForegroundColor
    [System.Console]::BackgroundColor = $fColor
    [System.Console]::ForegroundColor = $bColor    
}

# main function showing the menu
function New-Menu {
    param(
        [parameter(Mandatory = $true)][System.Collections.Generic.List[string]]$menuItems, # contains all menu items
        [string]$title = "Menu Title", # the title for the menu
        [string]$hint = "Use arrows or type the number. 'Enter' - Run, 'ESC' - Exit`n", # hint to be displayed above menu entries
        [ValidateSet("green", "yellow", "red", "black", "white")]                                   # you might add more colors allowed by console
        [string]$titleColor = 'green'                                                          # color of the title
    )
  
    # prepare variables with function wide scope
    $invalidChoice = $false                     # initialize the flag indicating whether an ivalid key was pressed
    $selectIndex = 0                          # initialize the variable storing the selection index (by default the first entry)
    $outChar = 'a'                        # initialize the variable storing the Enter or Esc value

    # prepare the cosnole
    [System.Console]::CursorVisible = $false    # hide the cursor, we don't need it
    [Console]::Clear()                          # clear everything before showing the menu

    # main loop showing all the entries and handling the interaction with user
    # end the loop only when Enter or Escape is pressed
    while (([System.Int16]$inputChar.Key -ne [System.ConsoleKey]::Enter) -and ([System.Int16]$inputChar.Key -ne [System.ConsoleKey]::Escape)) {
      
        # show title and hint
        [System.Console]::CursorTop = 0                     # start from top and then overwrite all lines; it's used instead of Clear to avoid blinking
        $tempColor = [System.Console]::ForegroundColor      # keep the default font color 
        [System.Console]::ForegroundColor = $titleColor     # set the color for title according to value of parameter
        [System.Console]::WriteLine("$title`n")             
        [System.Console]::ForegroundColor = $tempColor      # revert back to default font color
      
        [System.Console]::WriteLine($hint)

        # show all entries
        for ($i = 0; $i -lt $menuItems.Count; $i++) {
            [System.Console]::Write("[$i] ")                # add identity number to each entry, it's not highlighted for selection but it's in the same line
            if ($selectIndex -eq $i) {
                Reverse-Colors                              # in case this is the selected entry, reverse color just for it to make the selection visible
                [System.Console]::WriteLine($menuItems[$i])
                Reverse-Colors      
            }
            else {            
                [System.Console]::WriteLine($menuItems[$i]) # in case this is not-selected entry, just show it
            }
        }

        # in case of invalid key, show the message
        if ($invalidChoice) {
            [System.Console]::WriteLine("Invalid button! Try again...")
        }
        else {
            [System.Console]::Write([System.String]::new(' ', [System.Console]::WindowWidth)) # in case the valid key was used after invalid, clean-up this line
            [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop)               # set the cursor back to first column so it's properly back to 1st column, 1st row in next iteration of the loop
        }
        $invalidChoice = $false                                                              # reset the invalid key flag

        # read the key from user
        $inputChar = [System.Console]::ReadKey($true)

        # try to convert it to number
        try {
            $number = [System.Int32]::Parse($inputChar.KeyChar)
        }
        catch {
            $number = -1                                                                     # in case it's not a valid number, set to always invalid -1
        }
      
        # hanlde arrows
        if ([System.Int16]$inputChar.Key -eq [System.ConsoleKey]::DownArrow) {
            if ($selectIndex -lt $menuItems.Count - 1) {
                # avoid selection out of range
                $selectIndex++
            }
        }
        elseif ([System.Int16]$inputChar.Key -eq [System.ConsoleKey]::UpArrow) {
            if ($selectIndex -gt 0) {
                # avoid selection out of range
                $selectIndex--
            }
        }
        elseif ($number -ge 0 -and $number -lt $menuItems.Count) {
            # if it's valid number within the range
            # handle double-digit numbers
            $timestamp = Get-Date       
            while (![System.Console]::KeyAvailable -and ((Get-Date) - $timestamp).TotalMilliseconds -lt 500) {
                Start-Sleep -Milliseconds 250                                               # give the user 500 miliseconds to type in the 2nd digit, check after 250 to improve responsivness
            }
            if ([System.Console]::KeyAvailable) {
                # if user typed a key, read it in next line
                $secondChar = [System.Console]::ReadKey($true).KeyChar
                $fullChar = "$($inputChar.KeyChar)$($secondChar)"                           # join both keys
                try {
                    # set selection
                    $number = [System.Int32]::Parse($fullChar)                              # set the selection accordingly or raise flag for invalid key
                    if ($number -ge 0 -and $number -lt $menuItems.Count) {
                        $selectIndex = $number
                    }
                    else {
                        $invalidChoice = $true
                    }                
                }
                catch {
                    $invalidChoice = $true
                }
            }
            else {
                # set selection
                $selectIndex = $number                                                       # set selection for single digit number
            }
        }
        else {
            $invalidChoice = $true                                                           # key not recognized, raise the flag
        }
        $outChar = $inputChar                                                                # assign the key value to variable with scope outside the loop
    }

    # hanlde the result, just show the selected entry if Enter was pressed; do nothing if Escape was pressed
    if ($outChar.Key -eq [System.ConsoleKey]::Enter) {
        [Console]::WriteLine("You selected $($menuItems[$selectIndex])")
    }
}

#endregion FUNCTIONS

#region MAIN SCRIPT

# populate menuItems with example entries
$menuItems = [System.Collections.Generic.List[string]]::new()
<#
$menuItems.Add("First Option")
$menuItems.Add("Second Option")
$menuItems.Add("Third Option")
#>
1..15 | % { $menuItems.Add("Option un peu plus longue que ça lkfjlsdjflskjflksdjlkfsdjlkfsd $_") }

# show the menu
New-Menu $menuItems

#endregion MAIN SCRIPT