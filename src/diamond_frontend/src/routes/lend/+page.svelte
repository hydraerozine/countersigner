<!-- src/routes/lend/+page.svelte -->
<script>
  import { onMount } from 'svelte';
  import { backend } from "$lib/canisters";
  import { goto } from '$app/navigation';
  import { getAssets } from '$lib/getAssets';

  let assets = getAssets();
  let selectedAsset = null;
  let investmentAmount = '';
  let totalAssets = 0;
  let totalLiquidityValue = 0;
  let ecosystemValue = 0;

  onMount(async () => {
    // try {
    //   assets = await backend.getAllAssets();
    //   totalAssets = assets.length;
    //   totalLiquidityValue = assets.reduce((sum, asset) => sum + asset.totalInvested, 0);
    //   ecosystemValue = totalLiquidityValue * 0.01; // Example calculation
    // } catch (error) {
    //   console.error("Error fetching assets:", error);
    // }
  });

  function selectAsset(asset) {
    selectedAsset = asset;

    console.log("Selected asset:", asset);
  }

  async function invest() {
    if (selectedAsset && investmentAmount) {
      try {
        await backend.investInAsset(selectedAsset.assetId, parseFloat(investmentAmount));
        selectedAsset = null;
        investmentAmount = '';
        assets = await backend.getAllAssets(); // Refresh asset list
        totalAssets = assets.length;
        totalLiquidityValue = assets.reduce((sum, asset) => sum + asset.totalInvested, 0);
        ecosystemValue = totalLiquidityValue * 0.01;
      } catch (error) {
        console.error("Error investing in asset:", error);
      }
    }
  }
</script>

<main>
  <header>
    <div class="logo">
      <svg viewBox="0 0 100 100" width="40" height="40">
        <path d="M50 0 L100 50 L50 100 L0 50 Z" fill="#00BFFF" />
      </svg>
      <span>Countersigner</span>
    </div>
    <div class="timestamp">{new Date().toLocaleString()}</div>
    <div class="menu-toggle">☰</div>
  </header>

  <div class="content">
    <nav>
      <ul>
        <li>Account</li>
        <li>Assets</li>
        <li>Shards</li>
        <li>Transactions</li>
        <li>Send | Receive</li>
        <li>Buy | Sell | Trade</li>
        <li>Liquidity Exchange</li>
        <li>Deposit | Withdraw</li>
      </ul>
      <div class="version">Countersigner | Version 1.0</div>
    </nav>

    <section class="main-content">
      <div class="asset-summary">
        <div class="asset-icon">
          <svg viewBox="0 0 100 100" width="80" height="80">
            <polygon points="50,0 100,25 100,75 50,100 0,75 0,25" fill="#00BFFF" />
          </svg>
        </div>
        <div class="asset-details">
          <p>Total Assets: {totalAssets}</p>
          <p>Price per Shard: N/A</p>
          <p>Liquidity Value: £{totalLiquidityValue.toFixed(2)}</p>
          <p>Ecosystem Value: £{ecosystemValue.toFixed(2)}</p>
        </div>
        <div class="action-buttons">
          <button class="buy">Buy Liquidity</button>
          <button class="sell">Sell Liquidity</button>
          <button class="trade">Trade Liquidity</button>
        </div>
      </div>

      <div class="asset-list">
        <table>
          <thead>
            <tr>
              <th>Icon</th>
              <th>Shard UID</th>
              <th>Value</th>
              <th>ROI</th>
              <th>End Time / Date</th>
              <th>Reward</th>
              <th>Days</th>
            </tr>
          </thead>
          <tbody>
            {#each assets as asset}
              <tr on:click={() => selectAsset(asset)}>
                <td><div class="asset-color" style="background-color: {asset.color}; width: 20px; height: 20px; border-radius: 50%;"></div></td>
                <td>{asset.assetId}</td>
                <td>£{asset.totalInvested.toFixed(2)}</td>
                <td>{(asset.roi).toFixed(2)}%</td>
                <td>{new Date(asset.endDate).toLocaleString()}</td>
                <td>£{asset.reward.toFixed(2)}</td>
                <td>{asset.daysRemaining}</td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>

      {#if selectedAsset}
        <div class="selected-asset">
          <h3>{selectedAsset.name}</h3>
          <p>{selectedAsset.description}</p>
          <p>Price: £{selectedAsset.price}</p>
          <p>Currently Funded: £{selectedAsset.totalInvested}</p>
          <input bind:value={investmentAmount} type="number" placeholder="Investment Amount" />
          <button on:click={invest}>Invest</button>
          <button on:click={() => selectedAsset = null}>Back to Asset List</button>
        </div>
      {/if}
    </section>

    <aside class="sharding-contract">
      <h3>Sharding Contract</h3>
      <div class="contract-icon">
        <svg viewBox="0 0 100 100" width="60" height="60">
          <rect x="10" y="10" width="80" height="80" fill="none" stroke="#00BFFF" stroke-width="4" />
          <line x1="30" y1="30" x2="70" y2="30" stroke="#00BFFF" stroke-width="2" />
          <line x1="30" y1="50" x2="70" y2="50" stroke="#00BFFF" stroke-width="2" />
          <line x1="30" y1="70" x2="70" y2="70" stroke="#00BFFF" stroke-width="2" />
        </svg>
      </div>
    </aside>
  </div>
</main>

<style>
  :global(body) {
    background-color: #000;
    color: #fff;
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
  }

  main {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    background-color: #111;
  }

  .logo {
    display: flex;
    align-items: center;
  }

  .logo span {
    margin-left: 10px;
    font-size: 1.2em;
  }

  .timestamp, .menu-toggle {
    font-size: 0.8em;
  }

  .content {
    display: flex;
    flex-grow: 1;
  }

  nav {
    width: 200px;
    background-color: #111;
    padding: 20px;
  }

  nav ul {
    list-style-type: none;
    padding: 0;
  }

  nav li {
    margin-bottom: 15px;
    cursor: pointer;
  }

  .version {
    position: absolute;
    bottom: 20px;
    font-size: 0.8em;
  }

  .main-content {
    flex-grow: 1;
    padding: 20px;
    overflow-y: auto;
  }

  .asset-summary {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #111;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 20px;
  }

  .asset-icon svg {
    width: 80px;
    height: 80px;
  }

  .action-buttons button {
    margin-left: 10px;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }

  .buy { background-color: #00BFFF; }
  .sell { background-color: #00FF00; }
  .trade { background-color: #FFA500; }

  .asset-list table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
  }

  .asset-list th, .asset-list td {
    text-align: left;
    padding: 10px;
    border-bottom: 1px solid #333;
  }

  .asset-color {
    width: 20px;
    height: 20px;
    border-radius: 50%;
  }

  .sharding-contract {
    width: 200px;
    background-color: #111;
    padding: 20px;
    text-align: center;
  }

  .contract-icon {
    margin-top: 20px;
  }

  .selected-asset {
    background-color: #111;
    padding: 20px;
    border-radius: 10px;
    margin-top: 20px;
  }

  .selected-asset input {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    background-color: #222;
    border: 1px solid #444;
    color: #fff;
  }

  .selected-asset button {
    margin-right: 10px;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    background-color: #00BFFF;
    color: #fff;
  }
</style>
