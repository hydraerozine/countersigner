<!-- src/routes/lend/+page.svelte -->
<script>
  import { onMount } from 'svelte';
  import { backend } from "$lib/canisters";
  import { goto } from '$app/navigation';

  let assets = [];
  let selectedAsset = null;
  let investmentAmount = '';

  onMount(async () => {
    try {
      assets = await backend.getAllAssets();
    } catch (error) {
      console.error("Error fetching assets:", error);
    }
  });

  function selectAsset(asset) {
    selectedAsset = asset;
  }

  async function invest() {
    if (selectedAsset && investmentAmount) {
      try {
        await backend.investInAsset(selectedAsset.assetId, parseFloat(investmentAmount));
        goto('/');
      } catch (error) {
        console.error("Error investing in asset:", error);
      }
    }
  }
</script>

<h2>Lend and Earn</h2>
{#if !selectedAsset}
  <ul>
    {#each assets as asset}
      <li>
        <button on:click={() => selectAsset(asset)}>
          {asset.name} - {asset.price} (Funded: {asset.totalInvested})
        </button>
      </li>
    {/each}
  </ul>
{:else}
  <h3>{selectedAsset.name}</h3>
  <p>{selectedAsset.description}</p>
  <p>Price: {selectedAsset.price}</p>
  <p>Currently Funded: {selectedAsset.totalInvested}</p>
  <input bind:value={investmentAmount} type="number" placeholder="Investment Amount" />
  <button on:click={invest}>Invest</button>
  <button on:click={() => selectedAsset = null}>Back to Asset List</button>
{/if}
<button on:click={() => goto('/')}>Back to Main Menu</button>