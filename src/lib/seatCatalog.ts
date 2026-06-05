import seatCatalog from "../data/products/seat-catalog.json";

export type SeatManufacturer = (typeof seatCatalog.manufacturers)[number];
export type SeatProduct = (typeof seatCatalog.products)[number];
export type SeatFitment = SeatProduct["fitments"][number];

export type SeatCatalogItem = SeatProduct & {
  manufacturer: SeatManufacturer | undefined;
  fitment: SeatFitment;
};

const manufacturersByKey = new Map(
  seatCatalog.manufacturers.map((manufacturer) => [manufacturer.key, manufacturer])
);

export const getSeatCatalogForMotorcycle = (motorcycleSlug: string): SeatCatalogItem[] =>
  seatCatalog.products
    .flatMap((product) =>
      product.fitments
        .filter((fitment) => fitment.motorcycleSlug === motorcycleSlug)
        .map((fitment) => ({
          ...product,
          manufacturer: manufacturersByKey.get(product.manufacturerKey),
          fitment,
        }))
    )
    .sort((a, b) => {
      const score = (item: SeatCatalogItem) => {
        if (item.status === "verified_source") return 0;
        if (item.status === "verified_reseller_source") return 1;
        if (item.status === "category_verified") return 2;
        return 3;
      };
      return score(a) - score(b) || a.name.localeCompare(b.name);
    });

export const getSeatCatalogSummary = () => ({
  manufacturers: seatCatalog.manufacturers.length,
  products: seatCatalog.products.length,
  fitments: seatCatalog.products.reduce((sum, product) => sum + product.fitments.length, 0),
});
