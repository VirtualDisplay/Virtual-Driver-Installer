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
	0 { Write-Error "This script requires at least 2 arguments Xres Yres."; break }
	1 { Write-Error "This script requires at least 2 arguments Xres Yres."; break }
	2 { $disp = Get-Monitor | Select-String -Pattern "MTT1337" | Select-Object LineNumber | Select-Object -ExpandProperty LineNumber
	    $vres = $args[0]
		$hres = $args[1]
		continue
	}
    default { Write-Error "Invalid number of arguments: $numArgs"; break }
}
# Setting the resolution on the correct display.
Get-DisplayConfig | Set-DisplayResolution -DisplayId $disp -Width $vres -Height $hres | Use-DisplayConfig
# SIG # Begin signature block
# MIIfbwYJKoZIhvcNAQcCoIIfYDCCH1wCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDyheuPZv3ydwVT
# ZMYlAd982xZOlfjakg6wd9uXcqyjV6CCA8EwggO9MIICpaADAgECAgEBMA0GCSqG
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
# hZ1OUYWGodYPCT7CBDjlhmdNp5EkTe0tZFmoMYIbBDCCGwACAQEwgacwgaExCzAJ
# BgNVBAYTAlVTMQswCQYDVQQIEwJDQTEQMA4GA1UEBxMHU2FsaW5hczEUMBIGA1UE
# ChMLTWlrZVRoZVRlY2gxFDASBgNVBAsTC0RldmVsb3BtZW50MR8wHQYDVQQDExZW
# aXJ0dWFsIERpc3BsYXkgRHJpdmVyMSYwJAYJKoZIhvcNAQkBFhdjb250YWN0QG1p
# a2V0aGV0ZWNoLmNvbQIBATANBglghkgBZQMEAgEFAKBeMBAGCisGAQQBgjcCAQwx
# AjAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMC8GCSqGSIb3DQEJBDEiBCCS
# cCJClAhsV/2Cka5NVCRkEHy+un9aZO/74dfW8zdMYzANBgkqhkiG9w0BAQEFAASC
# AQCIDw0AzIlj450/txOTpRl5uXbwEx7LfHka76kitomnU7reb0BI1D6sAEWd9FAS
# 4rlOarYCWVBpyj4sFBvHQWJVtlThuSJ7ME9HSC2jCfLyndd1SgiSIvUGy/ewcURA
# 8qB+2YZc4g5VJfMv/k6O2bt67Av+09ywXqNGqER50M6v+RKSW5kQjn/06TfP/f7Z
# 8mArIM2hBKCriSZBjdmz4bJdINVii+ON9Yz9OTCWg4ncjk4ldJ/fjs/KNfFS41RO
# l/iO9TnkC8+JcPnwzzBW4CcancpD1OcQclpJDxV9b8FmdcPYL7lWKmPRehD0JHoz
# mnqRqUB5vQOj7hjem1XzjuX4oYIYzTCCGMkGCisGAQQBgjcDAwExghi5MIIYtQYJ
# KoZIhvcNAQcCoIIYpjCCGKICAQMxDzANBglghkgBZQMEAgIFADCB8wYLKoZIhvcN
# AQkQAQSggeMEgeAwgd0CAQEGCisGAQQBsjECAQEwMTANBglghkgBZQMEAgEFAAQg
# bXAwwmXnXfEtRrWlIoMcOse9rCRW5qkACOk7eaHg0aMCFEkMxFoWRDeUQlC/esOt
# efUT9ZWmGA8yMDI0MTAxMTA2MzExNVqgcqRwMG4xCzAJBgNVBAYTAkdCMRMwEQYD
# VQQIEwpNYW5jaGVzdGVyMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxMDAuBgNV
# BAMTJ1NlY3RpZ28gUHVibGljIFRpbWUgU3RhbXBpbmcgU2lnbmVyIFIzNaCCEv8w
# ggZdMIIExaADAgECAhA6UmoshM5V5h1l/MwS2OmJMA0GCSqGSIb3DQEBDAUAMFUx
# CzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxLDAqBgNVBAMT
# I1NlY3RpZ28gUHVibGljIFRpbWUgU3RhbXBpbmcgQ0EgUjM2MB4XDTI0MDExNTAw
# MDAwMFoXDTM1MDQxNDIzNTk1OVowbjELMAkGA1UEBhMCR0IxEzARBgNVBAgTCk1h
# bmNoZXN0ZXIxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEwMC4GA1UEAxMnU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBTaWduZXIgUjM1MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAjdFn9MFIm739OEk6TWGBm8PY3EWlYQQ2jQae
# 45iWgPXUGVuYoIa1xjTGIyuw3suUSBzKiyG0/c/Yn++d5mG6IyayljuGT9DeXQU9
# k8GWWj2/BPoamg2fFctnPsdTYhMGxM06z1+Ft0Bav8ybww21ii/faiy+NhiUM195
# +cFqOtCpJXxZ/lm9tpjmVmEqpAlRpfGmLhNdkqiEuDFTuD1GsV3jvuPuPGKUJTam
# 3P53U4LM0UCxeDI8Qz40Qw9TPar6S02XExlc8X1YsiE6ETcTz+g1ImQ1OqFwEaxs
# Mj/WoJT18GG5KiNnS7n/X4iMwboAg3IjpcvEzw4AZCZowHyCzYhnFRM4PuNMVHYc
# TXGgvuq9I7j4ke281x4e7/90Z5Wbk92RrLcS35hO30TABcGx3Q8+YLRy6o0k1w4j
# RefCMT7b5mTxtq5XPmKvtgfPuaWPkGZ/tbxInyNDA7YgOgccULjp4+D56g2iuzRC
# sLQ9ac6AN4yRbqCYsG2rcIQ5INTyI2JzA2w1vsAHPRbUTeqVLDuNOY2gYIoKBWQs
# PYVoyzaoBVU6O5TG+a1YyfWkgVVS9nXKs8hVti3VpOV3aeuaHnjgC6He2CCDL9aW
# 6gteUe0AmC8XCtWwpePx6QW3ROZo8vSUe9AR7mMdu5+FzTmW8K13Bt8GX/YBFJO7
# LWzwKAUCAwEAAaOCAY4wggGKMB8GA1UdIwQYMBaAFF9Y7UwxeqJhQo1SgLqzYZcZ
# ojKbMB0GA1UdDgQWBBRo76QySWm2Ujgd6kM5LPQUap4MhTAOBgNVHQ8BAf8EBAMC
# BsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBKBgNVHSAE
# QzBBMDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3Rp
# Z28uY29tL0NQUzAIBgZngQwBBAIwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL2Ny
# bC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3Js
# MHoGCCsGAQUFBwEBBG4wbDBFBggrBgEFBQcwAoY5aHR0cDovL2NydC5zZWN0aWdv
# LmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3J0MCMGCCsGAQUF
# BzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEA
# sNwuyfpPNkyKL/bJT9XvGE8fnw7Gv/4SetmOkjK9hPPa7/Nsv5/MHuVus+aXwRFq
# M5Vu51qfrHTwnVExcP2EHKr7IR+m/Ub7PamaeWfle5x8D0x/MsysICs00xtSNVxF
# ywCvXx55l6Wg3lXiPCui8N4s51mXS0Ht85fkXo3auZdo1O4lHzJLYX4RZovlVWD5
# EfwV6Ve1G9UMslnm6pI0hyR0Zr95QWG0MpNPP0u05SHjq/YkPlDee3yYOECNMqnZ
# +j8onoUtZ0oC8CkbOOk/AOoV4kp/6Ql2gEp3bNC7DOTlaCmH24DjpVgryn8FMklq
# EoK4Z3IoUgV8R9qQLg1dr6/BjghGnj2XNA8ujta2JyoxpqpvyETZCYIUjIs69YiD
# jzftt37rQVwIZsfCYv+DU5sh/StFL1x4rgNj2t8GccUfa/V3iFFW9lfIJWWsvtlC
# 5XOOOQswr1UmVdNWQem4LwrlLgcdO/YAnHqY52QwnBLiAuUnuBeshWmfEb5oieIY
# MIIGFDCCA/ygAwIBAgIQeiOu2lNplg+RyD5c9MfjPzANBgkqhkiG9w0BAQwFADBX
# MQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS4wLAYDVQQD
# EyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2MB4XDTIxMDMy
# MjAwMDAwMFoXDTM2MDMyMTIzNTk1OVowVTELMAkGA1UEBhMCR0IxGDAWBgNVBAoT
# D1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJsaWMgVGltZSBT
# dGFtcGluZyBDQSBSMzYwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQDN
# mNhDQatugivs9jN+JjTkiYzT7yISgFQ+7yavjA6Bg+OiIjPm/N/t3nC7wYUrUlY3
# mFyI32t2o6Ft3EtxJXCc5MmZQZ8AxCbh5c6WzeJDB9qkQVa46xiYEpc81KnBkAWg
# saXnLURoYZzksHIzzCNxtIXnb9njZholGw9djnjkTdAA83abEOHQ4ujOGIaBhPXG
# 2NdV8TNgFWZ9BojlAvflxNMCOwkCnzlH4oCw5+4v1nssWeN1y4+RlaOywwRMUi54
# fr2vFsU5QPrgb6tSjvEUh1EC4M29YGy/SIYM8ZpHadmVjbi3Pl8hJiTWw9jiCKv3
# 1pcAaeijS9fc6R7DgyyLIGflmdQMwrNRxCulVq8ZpysiSYNi79tw5RHWZUEhnRfs
# /hsp/fwkXsynu1jcsUX+HuG8FLa2BNheUPtOcgw+vHJcJ8HnJCrcUWhdFczf8O+p
# DiyGhVYX+bDDP3GhGS7TmKmGnbZ9N+MpEhWmbiAVPbgkqykSkzyYVr15OApZYK8C
# AwEAAaOCAVwwggFYMB8GA1UdIwQYMBaAFPZ3at0//QET/xahbIICL9AKPRQlMB0G
# A1UdDgQWBBRfWO1MMXqiYUKNUoC6s2GXGaIymzAOBgNVHQ8BAf8EBAMCAYYwEgYD
# VR0TAQH/BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNVHSAECjAI
# MAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5zZWN0aWdvLmNv
# bS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nUm9vdFI0Ni5jcmwwfAYIKwYBBQUH
# AQEEcDBuMEcGCCsGAQUFBzAChjtodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3Rp
# Z29QdWJsaWNUaW1lU3RhbXBpbmdSb290UjQ2LnA3YzAjBggrBgEFBQcwAYYXaHR0
# cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBABLXeyCtDjVY
# DJ6BHSVY/UwtZ3Svx2ImIfZVVGnGoUaGdltoX4hDskBMZx5NY5L6SCcwDMZhHOmb
# yMhyOVJDwm1yrKYqGDHWzpwVkFJ+996jKKAXyIIaUf5JVKjccev3w16mNIUlNTkp
# JEor7edVJZiRJVCAmWAaHcw9zP0hY3gj+fWp8MbOocI9Zn78xvm9XKGBp6rEs9sE
# iq/pwzvg2/KjXE2yWUQIkms6+yslCRqNXPjEnBnxuUB1fm6bPAV+Tsr/Qrd+mOCJ
# emo06ldon4pJFbQd0TQVIMLv5koklInHvyaf6vATJP4DfPtKzSBPkKlOtyaFTAjD
# 2Nu+di5hErEVVaMqSVbfPzd6kNXOhYm23EWm6N2s2ZHCHVhlUgHaC4ACMRCgXjYf
# QEDtYEK54dUwPJXV7icz0rgCzs9VI29DwsjVZFpO4ZIVR33LwXyPDbYFkLqYmgHj
# R3tKVkhh9qKV2WCmBuC27pIOx6TYvyqiYbntinmpOqh/QPAnhDgexKG9GX/n1Pgg
# kGi9HCapZp8fRwg8RftwS21Ln61euBG0yONM6noD2XQPrFwpm3GcuqJMf0o8LLrF
# kSLRQNwxPDDkWXhW+gZswbaiie5fd/W2ygcto78XCSPfFWveUOSZ5SqK95tBO8aT
# HmEa4lpJVD7HrTEn9jb1EGvxOb1cnn0CMIIGgjCCBGqgAwIBAgIQNsKwvXwbOuej
# s902y8l1aDANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Ck5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUg
# VVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkwHhcNMjEwMzIyMDAwMDAwWhcNMzgwMTE4MjM1OTU5
# WjBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS4wLAYD
# VQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2MIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAiJ3YuUVnnR3d6LkmgZpUVMB8SQWb
# zFoVD9mUEES0QUCBdxSZqdTkdizICFNeINCSJS+lV1ipnW5ihkQyC0cRLWXUJzod
# qpnMRs46npiJPHrfLBOifjfhpdXJ2aHHsPHggGsCi7uE0awqKggE/LkYw3sqaBia
# 67h/3awoqNvGqiFRJ+OTWYmUCO2GAXsePHi+/JUNAax3kpqstbl3vcTdOGhtKShv
# ZIvjwulRH87rbukNyHGWX5tNK/WABKf+Gnoi4cmisS7oSimgHUI0Wn/4elNd40BF
# dSZ1EwpuddZ+Wr7+Dfo0lcHflm/FDDrOJ3rWqauUP8hsokDoI7D/yUVI9DAE/WK3
# Jl3C4LKwIpn1mNzMyptRwsXKrop06m7NUNHdlTDEMovXAIDGAvYynPt5lutv8lZe
# I5w3MOlCybAZDpK3Dy1MKo+6aEtE9vtiTMzz/o2dYfdP0KWZwZIXbYsTIlg1YIet
# Cpi5s14qiXOpRsKqFKqav9R1R5vj3NgevsAsvxsAnI8Oa5s2oy25qhsoBIGo/zi6
# GpxFj+mOdh35Xn91y72J4RGOJEoqzEIbW3q0b2iPuWLA911cRxgY5SJYubvjay3n
# SMbBPPFsyl6mY4/WYucmyS9lo3l7jk27MAe145GWxK4O3m3gEFEIkv7kRmefDR7O
# e2T1HxAnICQvr9sCAwEAAaOCARYwggESMB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh
# 2JvAnfKyA2bLMB0GA1UdDgQWBBT2d2rdP/0BE/8WoWyCAi/QCj0UJTAOBgNVHQ8B
# Af8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUEDDAKBggrBgEFBQcDCDAR
# BgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51
# c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHku
# Y3JsMDUGCCsGAQUFBwEBBCkwJzAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNl
# cnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEADr5lQe1oRLjlocXUEYfktzsl
# jOt+2sgXke3Y8UPEooU5y39rAARaAdAxUeiX1ktLJ3+lgxtoLQhn5cFb3GF2SSZR
# X8ptQ6IvuD3wz/LNHKpQ5nX8hjsDLRhsyeIiJsms9yAWnvdYOdEMq1W61KE9JlBk
# B20XBee6JaXx4UBErc+YuoSb1SxVf7nkNtUjPfcxuFtrQdRMRi/fInV/AobE8Gw/
# 8yBMQKKaHt5eia8ybT8Y/Ffa6HAJyz9gvEOcF1VWXG8OMeM7Vy7Bs6mSIkYeYtdd
# U1ux1dQLbEGur18ut97wgGwDiGinCwKPyFO7ApcmVJOtlw9FVJxw/mL1TbyBns4z
# OgkaXFnnfzg4qbSvnrwyj1NiurMp4pmAWjR+Pb/SIduPnmFzbSN/G8reZCL4fvGl
# vPFk4Uab/JVCSmj59+/mB2Gn6G/UYOy8k60mKcmaAZsEVkhOFuoj4we8CYyaR9vd
# 9PGZKSinaZIkvVjbH/3nlLb0a7SBIkiRzfPfS9T+JesylbHa1LtRV9U/7m0q7Ma2
# CQ/t392ioOssXW7oKLdOmMBl14suVFBmbzrt5V5cQPnwtd3UOTpS9oCG+ZZheiIv
# PgkDmA8FzPsnfXW5qHELB43ET7HHFHeRPRYrMBKjkb8/IN7Po0d0hQoF4TeMM+zY
# AJzoKQnVKOLg8pZVPT8xggSRMIIEjQIBATBpMFUxCzAJBgNVBAYTAkdCMRgwFgYD
# VQQKEw9TZWN0aWdvIExpbWl0ZWQxLDAqBgNVBAMTI1NlY3RpZ28gUHVibGljIFRp
# bWUgU3RhbXBpbmcgQ0EgUjM2AhA6UmoshM5V5h1l/MwS2OmJMA0GCWCGSAFlAwQC
# AgUAoIIB+TAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkF
# MQ8XDTI0MTAxMTA2MzExNVowPwYJKoZIhvcNAQkEMTIEMKfgUBqm7ayGw2doNywR
# /iPUKzxoUmlPqViadcAIDR1t8uIw5agPQ8Yt0zMNPKZUVDCCAXoGCyqGSIb3DQEJ
# EAIMMYIBaTCCAWUwggFhMBYEFPhgmBmm+4gs9+hSl/KhGVIaFndfMIGHBBTGrlTk
# eIbxfD1VEkiMacNKevnC3TBvMFukWTBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMP
# U2VjdGlnbyBMaW1pdGVkMS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0
# YW1waW5nIFJvb3QgUjQ2AhB6I67aU2mWD5HIPlz0x+M/MIG8BBSFPWMtk4KCYXzQ
# kDXEkd6SwULaxzCBozCBjqSBizCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5l
# dyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNF
# UlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNh
# dGlvbiBBdXRob3JpdHkCEDbCsL18Gzrno7PdNsvJdWgwDQYJKoZIhvcNAQEBBQAE
# ggIAPeigyFgzIfIc56JxeZg44/Xx1G1Y3K2Vsz5pxrAjgYUvsL13wOEg+k5bK1CY
# z0VowxTeCrY0f7+n76RoMIaND5nLm6q55jhcorils5mG4gGhQN0KkErsicCUyQj8
# WcANnblSmikGYJoR4bLbeSpdMHkXAzR0e9xQOZ3xM5TuTJyqNKw+Qwh8/zgfjFJn
# hegxMrWX65ZeubA+1ZTkujwfad+9HW7+2BvarVw0FHFCmTGHR2LaHYZ64ZkREHW/
# ViLDoLsugQJ10Jstk6Pp+uSnWnsCCZfgRtMjkLMTm1jf6VWjo370L45EeXjaYZHX
# Zv6s3JWKLHlE8Wz6as/cO+KVabn0AsJex6lzOwSxnxa7YN+yZh3Td/tKEPTd6kLu
# kbgSBETJDMVlhvzAff2mAgBr+xe8aMRCtaQwfVc4Vxz/UdEzwRYogA00OFaX3y8u
# HPKrOHX4Y4PiqRjmMzF0bkngTDwvK/VT4iZphLXQPcW2F65g4m/dMr6f013alSBD
# NVRelziIdR4EA+LEB80v+LNgkwDhblSMK9e1SHlr6Jlbxz0veXLaFzLRCWa2/vpF
# GWE3f03WQJmgTkQlrHF08q/A0gdhQ2IrJEl+iqNgiH7W0nMrCUFmm/shPMRrEkru
# DEzoD7MTjAvjLqrHcmT16LSh+ie6O5YMlOQtN4RPstUaGtk=
# SIG # End signature block
