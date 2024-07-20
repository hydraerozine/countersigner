export const getAssets = () => {
  const assets = Array.from({ length: 10 }, () => ({
    color: "#" + Math.floor(Math.random() * 16777215).toString(16),
    name: "Asset " + Math.floor(Math.random() * 10000).toString(),
    description: "Description " + Math.floor(Math.random() * 10000).toString(),
    assetId: Math.floor(Math.random() * 10000).toString(),
    totalInvested: Math.random() * 10000,
    roi: Math.random() * 100,
    endDate: new Date(),
    reward: Math.random() * 1000,
    daysRemaining: Math.floor(Math.random() * 365),
    price: Math.random() * 1000,
  }));

  return assets;
};
