<!-- src/routes/+page.svelte -->
<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { backend } from "$lib/canisters";

  onMount(async () => {
    try {
      await backend.registerUser();
    } catch (error) {
      console.error("Error registering user:", error);
    }
  });

  function showRegisterAsset() {
    goto('/register');
  }

  function showLendAndEarn() {
    goto('/lend');
  }
</script>

<main>
  <h1>Countersigner</h1>
  <button on:click={showRegisterAsset}>Register Asset for Borrowing</button>
  <button on:click={showLendAndEarn}>Lend and Earn</button>
</main>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
  }

  button {
    margin: 10px;
    padding: 10px;
    background-color: #ff3e00;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
