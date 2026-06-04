param(
  [Parameter(Mandatory = $true)]
  [string] $Url
)

$ErrorActionPreference = "Stop"

$endpoint = "https://www.youtube.com/oembed?format=json&url=$([uri]::EscapeDataString($Url))"
$data = Invoke-RestMethod -Uri $endpoint -Method Get

[pscustomobject]@{
  title        = $data.title
  authorName   = $data.author_name
  authorUrl    = $data.author_url
  providerName = $data.provider_name
  thumbnailUrl = $data.thumbnail_url
  html         = $data.html
  note         = "oEmbed is useful for title, channel and thumbnail. It does not provide the full YouTube description."
} | ConvertTo-Json -Depth 4
