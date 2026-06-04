param(
  [Parameter(Mandatory = $true)]
  [string] $VideoId,

  [string] $ApiKey = $env:YOUTUBE_API_KEY
)

$ErrorActionPreference = "Stop"

if (-not $ApiKey) {
  throw "Missing YouTube API key. Set YOUTUBE_API_KEY or pass -ApiKey. Do not commit real keys."
}

$endpoint = "https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails,status&id=$([uri]::EscapeDataString($VideoId))&key=$([uri]::EscapeDataString($ApiKey))"
$data = Invoke-RestMethod -Uri $endpoint -Method Get

if (-not $data.items -or $data.items.Count -eq 0) {
  throw "No video metadata returned for VideoId: $VideoId"
}

$video = $data.items[0]
$snippet = $video.snippet
$status = $video.status

[pscustomobject]@{
  videoId          = $VideoId
  title            = $snippet.title
  channelTitle     = $snippet.channelTitle
  publishedAt      = $snippet.publishedAt
  description      = $snippet.description
  defaultThumbnail = $snippet.thumbnails.default.url
  highThumbnail    = $snippet.thumbnails.high.url
  tags             = $snippet.tags
  duration         = $video.contentDetails.duration
  embeddable       = $status.embeddable
  privacyStatus    = $status.privacyStatus
  note             = "Store a short editorial summary separately; do not copy long descriptions into page copy."
} | ConvertTo-Json -Depth 8
