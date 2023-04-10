# Define a string that contains Kanji characters mixed with normal text
$string = "こんにちは, PowerShell 世界!"

# Convert the string to a byte array using UTF8 encoding
$bytes = [System.Text.Encoding]::UTF8.GetBytes($string)

# Convert the byte array back to a string using UTF8 encoding
$utf8string = [System.Text.Encoding]::UTF8.GetString($bytes)

# Use Substring method on the UTF8 encoded string to get the first 5 characters
$substring = $utf8string.Substring(0, 5)

# Output the result
Write-Output $substring