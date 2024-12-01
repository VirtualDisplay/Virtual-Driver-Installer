# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

$repoName = "PSGallery"
$moduleName1 = "DisplayConfig"
$moduleName2 = "MonitorConfig"
if (!(Get-PSRepository -Name $repoName) -OR !(Find-Module -Name $moduleName1 | Where-Object {$_.Name -eq $moduleName1}) -OR !(Find-Module -Name $moduleName2 | Where-Object {$_.Name -eq $moduleName2})) {
    & .\dep_fix.ps1
}


# Import the local module
$dpth = Get-Module -ListAvailable $moduleName1 | select path | Select-Object -ExpandProperty path
import-module -name $dpth -InformationAction:Ignore -Verbose:$false -WarningAction:SilentlyContinue -Confirm:$false

# Import the other localmodule
$mpth = Get-Module -ListAvailable $moduleName2 | select path | Select-Object -ExpandProperty path
import-module -name $mpth -InformationAction:Ignore -Verbose:$false -WarningAction:SilentlyContinue -Confirm:$false

# Check if there are enough arguments
$numArgs = $args.Count
switch ($numArgs) {
	0 { Write-Error "This script requires at least 1, rotation in degrees ex. 90/180/270."; break }
	1 { $disp = Get-Monitor | Select-String -Pattern "MTT1337" | Select-Object LineNumber | Select-Object -ExpandProperty LineNumber
	    switch ($args[0]) {
		    90  { $degree = "Rotate90"
			      continue
			    }
			180 { $degree = "Rotate180"
			      continue
			    }
			270 { $degree = "Rotate270"
			      continue
			    }
			default	{ Write-Error "Invalid rotation angle(valid 90,180,270)."; break }
	}
    default { Write-Error "Invalid number of arguments: $numArgs"; break }
}
# Setting the resolution on the correct display.
Get-DisplayConfig | Set-DisplayRotation -DisplayId $disp -Rotation $degree | Use-DisplayConfig
# SIG # Begin signature block
# MIIfcAYJKoZIhvcNAQcCoIIfYTCCH10CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAImweVZ9B54+uE
# hUjkKCQXGCmZGq7ALul6rRGxxW5s7qCCA8EwggO9MIICpaADAgECAgEBMA0GCSqG
# SIb3DQEBCwUAMIGhMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExEDAOBgNVBAcT
# B1NhbGluYXMxFDASBgNVBAoTC01pa2VUaGVUZWNoMRQwEgYDVQQLEwtEZXZlbG9w
# bWVudDEfMB0GA1UEAxMWVmlydHVhbCBEaXNwbGF5IERyaXZlcjEmMCQGCSqGSIb3
# DQEJARYXY29udGFjdEBtaWtldGhldGVjaC5jb20wHhcNMjMxMDE0MTc0NjAwWhcN
# MjQxMDE0MTc0NjAwWjCBoTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRAwDgYD
# VQQHEwdTYWxpbmFzMRQwEgYDVQQKEwtNaWtlVGhlVGVjaDEUMBIGA1UECxMLRGV2
# ZWxvcG1lbnQxHzAdBgNVBAMTFlZpcnR1YWwgRGlzcGxheSBEcml2ZXIxJjAkBgkq
# hkiG9w0BCQEWF2NvbnRhY3RAbWlrZXRoZXRlY2guY29tMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEAnOYLIvHtMBmRcwMx8y8wBcMYdkG2svQZRRrOG1FO
# MaWiOQbj8QJVJBPuluKfrRX3AAwMPOta0eEyGx04NB07GjQ1iIS6GNs3H494DBLs
# lGJ5220BQ2MKI9ziUDYwDUL/EkrcVJ1dHvLjroQFgzUK5OS+GiMUqFjkGxmdC7vc
# 3lX7ESHjatY1ODCqRCPA+w3IcemvItmOtIIepiFALZjk/56xtFDEOUJ7dMXokj+L
# DurWpnIT/5bNOJgxL7hANDabAtEf0Hhg+HFsLHp+vIVTFRvyLyqfT8HW0hfbv4zW
# n1uMW9UX9q5kjBeaE4Zu1f9nn92XggdLkM8tYKPIhxz1jwIDAQABMA0GCSqGSIb3
# DQEBCwUAA4IBAQAU+UyHuCHh1M4iebS9qgjT3TzFCU3isETY8vCls4TbtPWdF4iO
# pwyvH8yMu6EV4WuoQmoS8hH9NKrSNkuc/Ehbzja5lOwGM/p2NwLOVRBJJe5t8Abi
# 8oKKDO3JOv+XZ7LhKnMQIXSZm8WeW9GTpwcQfDjWRtkjrpMP4axZojrcEV4zC8Oa
# p8xf/eGwy9S9ijWsJM9HlanFVZM9Xbqgald+Qm57WuvLL1F4V17CQk/nLmkT5Twi
# HDbYeMXaY6oQ0N5Tn6JxSPezDxCSF3fFX0Lo6EqCeGqbvAZwfPeJou5/QkxYUjmD
# hZ1OUYWGodYPCT7CBDjlhmdNp5EkTe0tZFmoMYIbBTCCGwECAQEwgacwgaExCzAJ
# BgNVBAYTAlVTMQswCQYDVQQIEwJDQTEQMA4GA1UEBxMHU2FsaW5hczEUMBIGA1UE
# ChMLTWlrZVRoZVRlY2gxFDASBgNVBAsTC0RldmVsb3BtZW50MR8wHQYDVQQDExZW
# aXJ0dWFsIERpc3BsYXkgRHJpdmVyMSYwJAYJKoZIhvcNAQkBFhdjb250YWN0QG1p
# a2V0aGV0ZWNoLmNvbQIBATANBglghkgBZQMEAgEFAKBeMBAGCisGAQQBgjcCAQwx
# AjAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMC8GCSqGSIb3DQEJBDEiBCDY
# KZ6pSk6Ey5bw7MH47+aZnufw0MAmPpJler0aRA3zNTANBgkqhkiG9w0BAQEFAASC
# AQBZGqay51ajGTt99O/8td06wivz7Qhly+rK8ovwUsic6n20baGL2H87TibfZmNj
# 7NCHzabSWF/pJMZE0qhTYTWmNjBFI8zA+I1MCP7KVHrCmzde/EmDPRyJtwvm0Zf9
# Kr+Y9q+dTWj7gJrAw7YbrH82poKI1WKLgymR/HYLR/58OYIjORY8GV9heVy9ShZw
# rWslLeJuvHUGp/H6Yvl/sDkGOHZnTC3gu/Qru1pnS2IwyPlwhg1Dqnz+3p3JkgUO
# 45Ec/CVBvqObr95qyfb+nZ/TJ96JQujM7x9ucwoikL5p+n5mND2kQNCsgbtLGwCZ
# B7NQX0uw8KNeQOpaskKYsI0UoYIYzjCCGMoGCisGAQQBgjcDAwExghi6MIIYtgYJ
# KoZIhvcNAQcCoIIYpzCCGKMCAQMxDzANBglghkgBZQMEAgIFADCB9AYLKoZIhvcN
# AQkQAQSggeQEgeEwgd4CAQEGCisGAQQBsjECAQEwMTANBglghkgBZQMEAgEFAAQg
# HTXeth76TUR10KTVUFLAT/2zgYu2LoiZ1CPaVjNc+mUCFQDNCt9+XPVJe17iM+9M
# FeES2u97vhgPMjAyNDEwMTEwNjMxMzBaoHKkcDBuMQswCQYDVQQGEwJHQjETMBEG
# A1UECBMKTWFuY2hlc3RlcjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMTAwLgYD
# VQQDEydTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFNpZ25lciBSMzWgghL/
# MIIGXTCCBMWgAwIBAgIQOlJqLITOVeYdZfzMEtjpiTANBgkqhkiG9w0BAQwFADBV
# MQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQD
# EyNTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIENBIFIzNjAeFw0yNDAxMTUw
# MDAwMDBaFw0zNTA0MTQyMzU5NTlaMG4xCzAJBgNVBAYTAkdCMRMwEQYDVQQIEwpN
# YW5jaGVzdGVyMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxMDAuBgNVBAMTJ1Nl
# Y3RpZ28gUHVibGljIFRpbWUgU3RhbXBpbmcgU2lnbmVyIFIzNTCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAI3RZ/TBSJu9/ThJOk1hgZvD2NxFpWEENo0G
# nuOYloD11BlbmKCGtcY0xiMrsN7LlEgcyoshtP3P2J/vneZhuiMmspY7hk/Q3l0F
# PZPBllo9vwT6GpoNnxXLZz7HU2ITBsTNOs9fhbdAWr/Mm8MNtYov32osvjYYlDNf
# efnBajrQqSV8Wf5ZvbaY5lZhKqQJUaXxpi4TXZKohLgxU7g9RrFd477j7jxilCU2
# ptz+d1OCzNFAsXgyPEM+NEMPUz2q+ktNlxMZXPF9WLIhOhE3E8/oNSJkNTqhcBGs
# bDI/1qCU9fBhuSojZ0u5/1+IjMG6AINyI6XLxM8OAGQmaMB8gs2IZxUTOD7jTFR2
# HE1xoL7qvSO4+JHtvNceHu//dGeVm5Pdkay3Et+YTt9EwAXBsd0PPmC0cuqNJNcO
# I0XnwjE+2+Zk8bauVz5ir7YHz7mlj5Bmf7W8SJ8jQwO2IDoHHFC46ePg+eoNors0
# QrC0PWnOgDeMkW6gmLBtq3CEOSDU8iNicwNsNb7ABz0W1E3qlSw7jTmNoGCKCgVk
# LD2FaMs2qAVVOjuUxvmtWMn1pIFVUvZ1yrPIVbYt1aTld2nrmh544Auh3tgggy/W
# luoLXlHtAJgvFwrVsKXj8ekFt0TmaPL0lHvQEe5jHbufhc05lvCtdwbfBl/2ARST
# uy1s8CgFAgMBAAGjggGOMIIBijAfBgNVHSMEGDAWgBRfWO1MMXqiYUKNUoC6s2GX
# GaIymzAdBgNVHQ4EFgQUaO+kMklptlI4HepDOSz0FGqeDIUwDgYDVR0PAQH/BAQD
# AgbAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwSgYDVR0g
# BEMwQTA1BgwrBgEEAbIxAQIBAwgwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0
# aWdvLmNvbS9DUFMwCAYGZ4EMAQQCMEoGA1UdHwRDMEEwP6A9oDuGOWh0dHA6Ly9j
# cmwuc2VjdGlnby5jb20vU2VjdGlnb1B1YmxpY1RpbWVTdGFtcGluZ0NBUjM2LmNy
# bDB6BggrBgEFBQcBAQRuMGwwRQYIKwYBBQUHMAKGOWh0dHA6Ly9jcnQuc2VjdGln
# by5jb20vU2VjdGlnb1B1YmxpY1RpbWVTdGFtcGluZ0NBUjM2LmNydDAjBggrBgEF
# BQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggGB
# ALDcLsn6TzZMii/2yU/V7xhPH58Oxr/+EnrZjpIyvYTz2u/zbL+fzB7lbrPml8ER
# ajOVbudan6x08J1RMXD9hByq+yEfpv1G+z2pmnln5XucfA9MfzLMrCArNNMbUjVc
# RcsAr18eeZeloN5V4jwrovDeLOdZl0tB7fOX5F6N2rmXaNTuJR8yS2F+EWaL5VVg
# +RH8FelXtRvVDLJZ5uqSNIckdGa/eUFhtDKTTz9LtOUh46v2JD5Q3nt8mDhAjTKp
# 2fo/KJ6FLWdKAvApGzjpPwDqFeJKf+kJdoBKd2zQuwzk5Wgph9uA46VYK8p/BTJJ
# ahKCuGdyKFIFfEfakC4NXa+vwY4IRp49lzQPLo7WticqMaaqb8hE2QmCFIyLOvWI
# g4837bd+60FcCGbHwmL/g1ObIf0rRS9ceK4DY9rfBnHFH2v1d4hRVvZXyCVlrL7Z
# QuVzjjkLMK9VJlXTVkHpuC8K5S4HHTv2AJx6mOdkMJwS4gLlJ7gXrIVpnxG+aIni
# GDCCBhQwggP8oAMCAQICEHojrtpTaZYPkcg+XPTH4z8wDQYJKoZIhvcNAQEMBQAw
# VzELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEuMCwGA1UE
# AxMlU2VjdGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBSb290IFI0NjAeFw0yMTAz
# MjIwMDAwMDBaFw0zNjAzMjEyMzU5NTlaMFUxCzAJBgNVBAYTAkdCMRgwFgYDVQQK
# Ew9TZWN0aWdvIExpbWl0ZWQxLDAqBgNVBAMTI1NlY3RpZ28gUHVibGljIFRpbWUg
# U3RhbXBpbmcgQ0EgUjM2MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEA
# zZjYQ0GrboIr7PYzfiY05ImM0+8iEoBUPu8mr4wOgYPjoiIz5vzf7d5wu8GFK1JW
# N5hciN9rdqOhbdxLcSVwnOTJmUGfAMQm4eXOls3iQwfapEFWuOsYmBKXPNSpwZAF
# oLGl5y1EaGGc5LByM8wjcbSF52/Z42YaJRsPXY545E3QAPN2mxDh0OLozhiGgYT1
# xtjXVfEzYBVmfQaI5QL35cTTAjsJAp85R+KAsOfuL9Z7LFnjdcuPkZWjssMETFIu
# eH69rxbFOUD64G+rUo7xFIdRAuDNvWBsv0iGDPGaR2nZlY24tz5fISYk1sPY4gir
# 99aXAGnoo0vX3Okew4MsiyBn5ZnUDMKzUcQrpVavGacrIkmDYu/bcOUR1mVBIZ0X
# 7P4bKf38JF7Mp7tY3LFF/h7hvBS2tgTYXlD7TnIMPrxyXCfB5yQq3FFoXRXM3/Dv
# qQ4shoVWF/mwwz9xoRku05iphp22fTfjKRIVpm4gFT24JKspEpM8mFa9eTgKWWCv
# AgMBAAGjggFcMIIBWDAfBgNVHSMEGDAWgBT2d2rdP/0BE/8WoWyCAi/QCj0UJTAd
# BgNVHQ4EFgQUX1jtTDF6omFCjVKAurNhlxmiMpswDgYDVR0PAQH/BAQDAgGGMBIG
# A1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwEQYDVR0gBAow
# CDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuc2VjdGlnby5j
# b20vU2VjdGlnb1B1YmxpY1RpbWVTdGFtcGluZ1Jvb3RSNDYuY3JsMHwGCCsGAQUF
# BwEBBHAwbjBHBggrBgEFBQcwAoY7aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0
# aWdvUHVibGljVGltZVN0YW1waW5nUm9vdFI0Ni5wN2MwIwYIKwYBBQUHMAGGF2h0
# dHA6Ly9vY3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBDAUAA4ICAQAS13sgrQ41
# WAyegR0lWP1MLWd0r8diJiH2VVRpxqFGhnZbaF+IQ7JATGceTWOS+kgnMAzGYRzp
# m8jIcjlSQ8JtcqymKhgx1s6cFZBSfvfeoyigF8iCGlH+SVSo3HHr98NepjSFJTU5
# KSRKK+3nVSWYkSVQgJlgGh3MPcz9IWN4I/n1qfDGzqHCPWZ+/Mb5vVyhgaeqxLPb
# BIqv6cM74Nvyo1xNsllECJJrOvsrJQkajVz4xJwZ8blAdX5umzwFfk7K/0K3fpjg
# iXpqNOpXaJ+KSRW0HdE0FSDC7+ZKJJSJx78mn+rwEyT+A3z7Ss0gT5CpTrcmhUwI
# w9jbvnYuYRKxFVWjKklW3z83epDVzoWJttxFpujdrNmRwh1YZVIB2guAAjEQoF42
# H0BA7WBCueHVMDyV1e4nM9K4As7PVSNvQ8LI1WRaTuGSFUd9y8F8jw22BZC6mJoB
# 40d7SlZIYfaildlgpgbgtu6SDsek2L8qomG57Yp5qTqof0DwJ4Q4HsShvRl/59T4
# IJBovRwmqWafH0cIPEX7cEttS5+tXrgRtMjjTOp6A9l0D6xcKZtxnLqiTH9KPCy6
# xZEi0UDcMTww5Fl4VvoGbMG2oonuX3f1tsoHLaO/Fwkj3xVr3lDkmeUqivebQTvG
# kx5hGuJaSVQ+x60xJ/Y29RBr8Tm9XJ59AjCCBoIwggRqoAMCAQICEDbCsL18Gzrn
# o7PdNsvJdWgwDQYJKoZIhvcNAQEMBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhl
# IFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRp
# ZmljYXRpb24gQXV0aG9yaXR5MB4XDTIxMDMyMjAwMDAwMFoXDTM4MDExODIzNTk1
# OVowVzELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEuMCwG
# A1UEAxMlU2VjdGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBSb290IFI0NjCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAIid2LlFZ50d3ei5JoGaVFTAfEkF
# m8xaFQ/ZlBBEtEFAgXcUmanU5HYsyAhTXiDQkiUvpVdYqZ1uYoZEMgtHES1l1Cc6
# HaqZzEbOOp6YiTx63ywTon434aXVydmhx7Dx4IBrAou7hNGsKioIBPy5GMN7KmgY
# muu4f92sKKjbxqohUSfjk1mJlAjthgF7Hjx4vvyVDQGsd5KarLW5d73E3ThobSko
# b2SL48LpUR/O627pDchxll+bTSv1gASn/hp6IuHJorEu6EopoB1CNFp/+HpTXeNA
# RXUmdRMKbnXWflq+/g36NJXB35ZvxQw6zid61qmrlD/IbKJA6COw/8lFSPQwBP1i
# tyZdwuCysCKZ9ZjczMqbUcLFyq6KdOpuzVDR3ZUwxDKL1wCAxgL2Mpz7eZbrb/JW
# XiOcNzDpQsmwGQ6Stw8tTCqPumhLRPb7YkzM8/6NnWH3T9ClmcGSF22LEyJYNWCH
# rQqYubNeKolzqUbCqhSqmr/UdUeb49zYHr7ALL8bAJyPDmubNqMtuaobKASBqP84
# uhqcRY/pjnYd+V5/dcu9ieERjiRKKsxCG1t6tG9oj7liwPddXEcYGOUiWLm742st
# 50jGwTzxbMpepmOP1mLnJskvZaN5e45NuzAHteORlsSuDt5t4BBRCJL+5EZnnw0e
# zntk9R8QJyAkL6/bAgMBAAGjggEWMIIBEjAfBgNVHSMEGDAWgBRTeb9aqitKz1SA
# 4dibwJ3ysgNmyzAdBgNVHQ4EFgQU9ndq3T/9ARP/FqFsggIv0Ao9FCUwDgYDVR0P
# AQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wEwYDVR0lBAwwCgYIKwYBBQUHAwgw
# EQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwu
# dXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5
# LmNybDA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVz
# ZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEMBQADggIBAA6+ZUHtaES45aHF1BGH5Lc7
# JYzrftrIF5Ht2PFDxKKFOct/awAEWgHQMVHol9ZLSyd/pYMbaC0IZ+XBW9xhdkkm
# UV/KbUOiL7g98M/yzRyqUOZ1/IY7Ay0YbMniIibJrPcgFp73WDnRDKtVutShPSZQ
# ZAdtFwXnuiWl8eFARK3PmLqEm9UsVX+55DbVIz33Mbhba0HUTEYv3yJ1fwKGxPBs
# P/MgTECimh7eXomvMm0/GPxX2uhwCcs/YLxDnBdVVlxvDjHjO1cuwbOpkiJGHmLX
# XVNbsdXUC2xBrq9fLrfe8IBsA4hopwsCj8hTuwKXJlSTrZcPRVSccP5i9U28gZ7O
# MzoJGlxZ5384OKm0r568Mo9TYrqzKeKZgFo0fj2/0iHbj55hc20jfxvK3mQi+H7x
# pbzxZOFGm/yVQkpo+ffv5gdhp+hv1GDsvJOtJinJmgGbBFZIThbqI+MHvAmMmkfb
# 3fTxmSkop2mSJL1Y2x/955S29Gu0gSJIkc3z30vU/iXrMpWx2tS7UVfVP+5tKuzG
# tgkP7d/doqDrLF1u6Ci3TpjAZdeLLlRQZm867eVeXED58LXd1Dk6UvaAhvmWYXoi
# Lz4JA5gPBcz7J311uahxCweNxE+xxxR3kT0WKzASo5G/PyDez6NHdIUKBeE3jDPs
# 2ACc6CkJ1Sji4PKWVT0/MYIEkTCCBI0CAQEwaTBVMQswCQYDVQQGEwJHQjEYMBYG
# A1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0aWdvIFB1YmxpYyBU
# aW1lIFN0YW1waW5nIENBIFIzNgIQOlJqLITOVeYdZfzMEtjpiTANBglghkgBZQME
# AgIFAKCCAfkwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJ
# BTEPFw0yNDEwMTEwNjMxMzBaMD8GCSqGSIb3DQEJBDEyBDBxVS4yignvzTyOVUnZ
# KTmE+if0ofnZXgcz95RD9t76qVhn3MEPjzdihUVKEZmoNsIwggF6BgsqhkiG9w0B
# CRACDDGCAWkwggFlMIIBYTAWBBT4YJgZpvuILPfoUpfyoRlSGhZ3XzCBhwQUxq5U
# 5HiG8Xw9VRJIjGnDSnr5wt0wbzBbpFkwVzELMAkGA1UEBhMCR0IxGDAWBgNVBAoT
# D1NlY3RpZ28gTGltaXRlZDEuMCwGA1UEAxMlU2VjdGlnbyBQdWJsaWMgVGltZSBT
# dGFtcGluZyBSb290IFI0NgIQeiOu2lNplg+RyD5c9MfjPzCBvAQUhT1jLZOCgmF8
# 0JA1xJHeksFC2scwgaMwgY6kgYswgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpO
# ZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVT
# RVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmlj
# YXRpb24gQXV0aG9yaXR5AhA2wrC9fBs656Oz3TbLyXVoMA0GCSqGSIb3DQEBAQUA
# BIICAFNKT3nKmDEUWYnioOu4Kw2H0vjReFhiGXewycyeK/8TL1AckRpyLU4B2w5x
# 4lPup+zZWqELm+46Y2TLZft32rSxopz+rsIHZHa8fxeFBoMj1BuB49OWj6bFqCFu
# nSKXeOpGtZfDB2RzNM/wYUWVsOUWrbJUMhgr7fQHMt+QL9Ld/56SuASipm12ifkf
# sKbmnKkLv7ID7nVTCrBo3LrlwZ9koyysceYMJgl+RlQ4fz5De9NgF/u3ir+cskoY
# rIeu4KL0IIgFq6gU+y8/uN/JWa+9L6i0VsENKUIkwBvJ5YlMHu7TQf77S+NNmGZ5
# 2gD7IbLMQxf8CB2nlD9+HcYNL/X5o5E1JS0QpMX0kULcy7orfqs3VsgPQQ+MZu8g
# GYah6TydVQd4UpxsVVPZaTF6SVpa88iaeX2X5hUBNlzh4nVM7DyL9pWhy7GwYQ9r
# 4D1/f+1lU75eIkkKv4WEv8WUOdrCez4Atn7L9WMWlR5S56XUNscOXRdshXhk7Z+i
# nMy4Dtv/4+SB4Tl4LPHYCLZNZWN5T+JqZlCHj3Yoe72UtatJrqU52a/epJtH8qn3
# fT+z37MqxAm4o1R4FqHAVUIg8Eijvg5rebLeenAoS2ccJXA+LTeVyRFKOiCOVsnk
# C6JlgVMbUH8KibKT+i/CYByZZscEH+fJlizWu1+ITs5WPOTI
# SIG # End signature block
