param(
  [Parameter(Mandatory = $true)]
  [string] $Key,

  [Parameter(Mandatory = $true)]
  [string] $YouTubeVideoId,

  [Parameter(Mandatory = $true)]
  [string] $Title,

  [string] $Topic = "Sitzbank lernen",
  [string] $ChannelName = "",
  [string] $Language = "de",
  [string] $SectionKey = "de-diy-videos",
  [int] $Priority = 10
)

$ErrorActionPreference = "Stop"

$videoUrl = "https://www.youtube.com/watch?v=$YouTubeVideoId"

[pscustomobject]@{
  key                = $Key
  status             = "curation_needed"
  topic              = $Topic
  youtubeVideoId     = $YouTubeVideoId
  youtubeUrl         = $videoUrl
  sourcePageUrl      = $videoUrl
  title              = $Title
  channelName        = $ChannelName
  language           = $Language
  duration           = ""
  thumbnailUrl       = "https://i.ytimg.com/vi/$YouTubeVideoId/hqdefault.jpg"
  fetchedDescription = ""
  editorSummary      = "TODO: Short Moto Seat Lab summary. What is useful in this video?"
  whatToLookFor      = @(
    "TODO: First concrete thing to observe",
    "TODO: Second concrete thing to observe",
    "TODO: Safety or quality signal"
  )
  fitFor             = @("TODO")
  riskNotes          = "TODO: What should a beginner not copy blindly?"
  embedPolicy        = "TODO: Check embed URL and oEmbed/Data API metadata before marking verified."
  links              = @(
    [pscustomobject]@{
      entityType = "page_section"
      entityKey  = $SectionKey
      usage      = "learning"
      priority   = $Priority
    }
  )
} | ConvertTo-Json -Depth 8
