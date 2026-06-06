import countries from "../data/i18n/countries.json";
import localizedHome from "../data/i18n/localized-home.json";
import uiCopy from "../data/i18n/ui-copy.json";

export type LocaleStatus = "active" | "draft" | "planned";

export interface CountryProfile {
  code: string;
  flagEmoji: string;
  slug: string;
  name: string;
  nativeName: string;
  primaryLanguage: string;
  languages: string[];
  region: string;
  marketTier: string;
  currency: string;
  seatStrategy: string;
  defaultPath: string;
  status: LocaleStatus;
  priority: number;
  notes: string;
  designHints: Record<string, string>;
  contentFocus: string[];
}

type CopyMap = Record<string, Record<string, string>>;
type LocalizedHomeMap = Record<
  string,
  {
    title: string;
    description: string;
    eyebrow: string;
    headline: string;
    lead: string;
    primaryAction: string;
    secondaryAction: string;
    assetNote: string;
    strategyEyebrow: string;
    strategyTitle: string;
    strategyText: string;
    priorityEyebrow: string;
    priorityTitle: string;
    priorities: string[];
  }
>;

const countryProfiles = countries as CountryProfile[];
const copyMap = uiCopy as CopyMap;
const localizedHomeMap = localizedHome as LocalizedHomeMap;

export const defaultLocale = "de";

export const getLocaleFromPath = (pathname: string) => {
  const firstSegment = pathname.split("/").filter(Boolean)[0];
  return firstSegment && copyMap[firstSegment] ? firstSegment : defaultLocale;
};

export const getCopy = (locale: string, key: string) =>
  copyMap[locale]?.[key] ?? copyMap[defaultLocale]?.[key] ?? key;

export const getCountryByCode = (code: string) =>
  countryProfiles.find((country) => country.code === code.toLowerCase());

export const getCountriesForSwitcher = () =>
  [...countryProfiles].sort((left, right) => left.priority - right.priority);

export const getCountryHreflang = (country: Pick<CountryProfile, "code" | "primaryLanguage">) => {
  const regionByCountry: Record<string, string> = {
    de: "DE",
    at: "AT",
    ch: "CH",
    fr: "FR",
    it: "IT",
    sk: "SK",
    hu: "HU",
    pl: "PL",
    ru: "RU",
    tr: "TR",
    th: "TH",
    id: "ID",
    my: "MY",
    cn: "CN",
  };
  const region = regionByCountry[country.code];
  return region ? `${country.primaryLanguage}-${region}` : country.primaryLanguage;
};

export const getLanguageCodes = () =>
  Array.from(
    new Set([
      ...countryProfiles.flatMap((country) => country.languages),
      ...Object.keys(copyMap),
    ])
  ).sort();

export const getCountryStatusLabel = (status: LocaleStatus, locale: string) =>
  getCopy(locale, `locale.${status}`);

export const getLocalizedHome = (countryCode: string) =>
  localizedHomeMap[countryCode] ?? localizedHomeMap.sk;
