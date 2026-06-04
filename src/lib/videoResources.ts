import videoResources from "../data/videos/seat-videos.json";

export type VideoResource = (typeof videoResources)[number];

export const videoResourceRegistry = videoResources;

export const getVideosForEntity = (entityType: string, entityKey: string, usage = "learning") =>
  videoResources
    .filter((video) =>
      video.links?.some((link) => link.entityType === entityType && link.entityKey === entityKey && link.usage === usage)
    )
    .sort((left, right) => {
      const leftLink = left.links?.find(
        (link) => link.entityType === entityType && link.entityKey === entityKey && link.usage === usage
      );
      const rightLink = right.links?.find(
        (link) => link.entityType === entityType && link.entityKey === entityKey && link.usage === usage
      );
      return (leftLink?.priority ?? 10) - (rightLink?.priority ?? 10);
    });
