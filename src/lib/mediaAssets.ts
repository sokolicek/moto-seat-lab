import mediaAssets from "../data/media/media-assets.json";

export type MediaAsset = (typeof mediaAssets)[number];

export const mediaAssetRegistry = mediaAssets;
export const allMediaAssets = mediaAssets.filter((asset) => asset.status === "active");

export const getMediaByKey = (key: string) => allMediaAssets.find((asset) => asset.key === key);

export const getMediaForEntity = (entityType: string, entityKey: string, usage = "card") =>
  getMediaForEntityVariants(entityType, entityKey, usage)[0];

export const getMediaForEntityVariants = (entityType: string, entityKey: string, usage = "card") =>
  allMediaAssets
    .filter((asset) =>
      asset.links?.some((link) => link.entityType === entityType && link.entityKey === entityKey && link.usage === usage)
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
